import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitMessageReactionInfo extends StatefulWidget {
  const ChatUIKitMessageReactionInfo(this.model, {super.key});

  final MessageModel model;
  @override
  State<ChatUIKitMessageReactionInfo> createState() =>
      _ChatUIKitMessageReactionInfoState();
}

class _ChatUIKitMessageReactionInfoState
    extends State<ChatUIKitMessageReactionInfo>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: widget.model.reactions!.length,
      vsync: this,
    );
    tabController.addListener(() {
      setState(() {
        selectIndex = tabController.index;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          height: 28,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.model.reactions!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () {
                    tabController.animateTo(index);
                  },
                  child: ChatUIkitReactionWidget(
                    widget.model.reactions![index],
                    theme: theme,
                    highlightColor: Colors.transparent,
                    highlightTextColor: theme.color.isDark
                        ? theme.color.neutralColor95
                        : theme.color.neutralColor3,
                    bgColor: selectIndex == index
                        ? (theme.color.isDark
                            ? theme.color.neutralColor2
                            : theme.color.neutralColor9)
                        : Colors.transparent,
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: widget.model.reactions!
                .map(
                  (e) => ChatReactionInfoWidget(
                    msgId: widget.model.message.msgId,
                    reaction: e,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class ChatReactionInfoWidget extends StatefulWidget {
  const ChatReactionInfoWidget(
      {required this.msgId, required this.reaction, super.key});
  final String msgId;
  final MessageReaction reaction;

  @override
  State<ChatReactionInfoWidget> createState() => _ChatReactionInfoWidgetState();
}

class _ChatReactionInfoWidgetState extends State<ChatReactionInfoWidget>
    with AutomaticKeepAliveClientMixin, ChatUIKitProviderObserver {
  List<ChatUIKitProfile> profiles = [];
  String? cursor;
  bool fetching = false;
  @override
  void initState() {
    super.initState();
    ChatUIKitProvider.instance.addObserver(this);
    fetchReactionInfo();
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onProfilesUpdate(
    Map<String, ChatUIKitProfile> map,
  ) {}

  void fetchReactionInfo() async {
    if (fetching) return;
    fetching = true;
    try {
      CursorResult<MessageReaction> result =
          await ChatUIKit.instance.fetchReactionDetail(
        messageId: widget.msgId,
        cursor: cursor,
        reaction: widget.reaction.reaction,
      );
      cursor = result.cursor;
      MessageReaction reaction = result.data.first;
      reaction.userList.remove(ChatUIKit.instance.currentUserId);
      Map<String, ChatUIKitProfile> map =
          ChatUIKitProvider.instance.getProfiles(
        reaction.userList.map((e) => ChatUIKitProfile.contact(id: e)).toList(),
      );

      for (var userId in reaction.userList) {
        profiles.add(map.values.firstWhere((element) => element.id == userId));
      }

      if (reaction.isAddedBySelf) {
        profiles.insert(
          0,
          ChatUIKitProfile.contact(id: ChatUIKit.instance.currentUserId!),
        );
      }
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
    fetching = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return ChatUIKitContactListViewItem(
          ContactItemModel.fromProfile(profiles[index]),
        );
      },
      itemCount: profiles.length,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
