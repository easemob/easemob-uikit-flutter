import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/ui/custom/custom_tab_indicator.dart';

import 'package:flutter/material.dart';

class ForwardMessageSelectView extends StatefulWidget {
  ForwardMessageSelectView.arguments(
    ForwardMessageSelectViewArguments arguments, {
    super.key,
  })  : messages = arguments.messages,
        enableAppBar = arguments.enableAppBar,
        appBar = arguments.appBar,
        title = arguments.title,
        viewObserver = arguments.viewObserver,
        summaryBuilder = arguments.summaryBuilder,
        isMulti = arguments.isMulti,
        appBarTrailingActionsBuilder = arguments.appBarTrailingActionsBuilder,
        attributes = arguments.attributes;

  const ForwardMessageSelectView({
    required this.messages,
    this.enableAppBar = true,
    this.appBar,
    this.title,
    this.attributes,
    this.viewObserver,
    this.summaryBuilder,
    this.isMulti = true,
    this.appBarTrailingActionsBuilder,
    super.key,
  });

  final List<Message> messages;
  final bool enableAppBar;
  final PreferredSizeWidget? appBar;
  final String? title;
  final String? attributes;
  final bool isMulti;
  final String? Function(BuildContext context, Message message)? summaryBuilder;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;
  @override
  State<ForwardMessageSelectView> createState() =>
      _ForwardMessageSelectViewState();
}

class _ForwardMessageSelectViewState extends State<ForwardMessageSelectView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<String> forwardedList = [];

  ChatUIKitViewObserver? viewObserver;

  late String summary;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
    summary = messagesInfo();
  }

  String messagesInfo() {
    List<Message> msgs = widget.messages.toList();
    msgs.sort((a, b) => a.serverTime - b.serverTime);

    String str = '';
    for (var msg in msgs) {
      String? typeBuilder = widget.summaryBuilder?.call(context, msg);
      if (typeBuilder?.isNotEmpty == true) {
        str += typeBuilder!;
      } else {
        ChatUIKitProfile? profile =
            ChatUIKitProvider.instance.profilesCache[msg.from!];
        str += '${profile?.nickname ?? msg.fromProfile.nickname}: ';
        if (msg.bodyType == MessageType.TXT) {
          str += msg.textContent;
        }

        if (msg.bodyType == MessageType.IMAGE) {
          str += '[Image]';
        }

        if (msg.bodyType == MessageType.VOICE) {
          str += "[Voice] ${msg.duration}'";
        }

        if (msg.bodyType == MessageType.LOCATION) {
          str += '[Location]';
        }

        if (msg.bodyType == MessageType.VIDEO) {
          str += '[Video]';
        }

        if (msg.bodyType == MessageType.FILE) {
          str += '[File]';
        }

        if (msg.bodyType == MessageType.COMBINE) {
          str += '[Combine]';
        }

        if (msg.bodyType == MessageType.CUSTOM && msg.isCardMessage) {
          str += '[Card] ${msg.cardUserNickname ?? msg.cardUserId}';
        }
      }

      if (msg == msgs.last) {
        continue;
      }
      str += "\n";
    }

    return str;
  }

  @override
  void dispose() {
    _tabController.dispose();
    widget.viewObserver?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                showBackButton: true,
                onBackButtonPressed: () {
                  Navigator.of(context).pop(forwardedList.isNotEmpty);
                },
                centerTitle: false,
                title: widget.title ??
                    ChatUIKitLocal.forwardMessageViewTitle.localString(context),
                trailingActions:
                    widget.appBarTrailingActionsBuilder?.call(context, null),
              ),
      body: Column(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            indicator: CustomTabIndicator(
              radius: 2,
              color: ChatUIKitTheme.of(context).color.isDark
                  ? ChatUIKitTheme.of(context).color.primaryColor6
                  : ChatUIKitTheme.of(context).color.primaryColor5,
              size: const Size(28, 4),
            ),
            controller: _tabController,
            labelStyle: TextStyle(
              fontWeight:
                  ChatUIKitTheme.of(context).font.titleMedium.fontWeight,
              fontSize: ChatUIKitTheme.of(context).font.titleMedium.fontSize,
            ),
            labelColor: (ChatUIKitTheme.of(context).color.isDark
                ? ChatUIKitTheme.of(context).color.neutralColor98
                : ChatUIKitTheme.of(context).color.neutralColor1),
            tabs: [
              Tab(
                  text: ChatUIKitLocal.forwardSelectContacts
                      .localString(context)),
              Tab(
                  text:
                      ChatUIKitLocal.forwardSelectGroups.localString(context)),
            ],
          ),
          Expanded(
              child: TabBarView(controller: _tabController, children: [
            ContactsView(
              enableAppBar: false,
              beforeItems: const [],
              onSearchTap: (data) {
                onSearchTap(data, context, theme);
              },
              listViewItemBuilder: (context, model) {
                Widget item = Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ChatUIKitContactListViewItem(model),
                    SizedBox(
                      width: 80,
                      height: 40,
                      child: forwardButton(theme, model.profile.id, false),
                    ),
                  ],
                );
                item = Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: item,
                );

                return item;
              },
            ),
            GroupsView(
                enableAppBar: false,
                listViewItemBuilder: (context, model) {
                  Widget item = Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ChatUIKitGroupListViewItem(model),
                      ),
                      SizedBox(
                        width: 80,
                        height: 40,
                        child: forwardButton(theme, model.profile.id, true),
                      ),
                    ],
                  );
                  item = Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: item,
                  );

                  return item;
                }),
          ])),
        ],
      ),
    );

    return content;
  }

  void onSearchTap(List<ContactItemModel> data, BuildContext context,
      ChatUIKitTheme theme) async {
    viewObserver ??= ChatUIKitViewObserver();
    List<NeedSearch> list = [];
    for (var item in data) {
      list.add(item);
    }

    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.searchUsersView,
      SearchViewArguments(
        attributes: widget.attributes,
        viewObserver: viewObserver,
        itemBuilder: (context, profile, searchKeyword) {
          Widget item = Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ChatUIKitSearchListViewItem(
                profile: profile,
                highlightWord: searchKeyword,
              ),
              SizedBox(
                width: 60,
                height: 28,
                child: Builder(
                  builder: (ctx) {
                    return forwardButton(theme, profile.id, false);
                  },
                ),
              ),
            ],
          );
          item = Padding(
            padding: const EdgeInsets.only(right: 24),
            child: item,
          );

          return item;
        },
        searchHideText:
            ChatUIKitLocal.conversationsViewSearchHint.localString(context),
        searchData: list,
      ),
    ).then((value) => viewObserver = null);
  }

  Widget forwardButton(
    ChatUIKitTheme theme,
    String profileId,
    bool isGroup,
  ) {
    bool hasForwarded = forwardedList.contains(profileId);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor3
            : theme.color.neutralColor95,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: () {
        if (forwardedList.contains(profileId)) {
          return;
        }
        forwardedList.add(profileId);
        forwardMessage(profileId, isGroup);
        setState(() {});
        viewObserver?.refresh();
      },
      child: Text(
        hasForwarded
            ? ChatUIKitLocal.forwardedMessage.localString(context)
            : ChatUIKitLocal.forwardMessage.localString(context),
        textAlign: TextAlign.right,
        textScaler: TextScaler.noScaling,
        style: TextStyle(
            color: hasForwarded
                ? theme.color.isDark
                    ? theme.color.neutralColor5
                    : theme.color.neutralColor7
                : theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor1,
            fontSize: theme.font.labelMedium.fontSize,
            fontWeight: theme.font.labelMedium.fontWeight),
      ),
    );
  }

  void forwardMessage(String to, [bool isGroup = false]) async {
    Message? message;
    if (widget.isMulti) {
      message = Message.createCombineSendMessage(
        targetId: to,
        msgIds: widget.messages.map((e) => e.msgId).toList(),
        summary: summary,
        chatType: isGroup ? ChatType.GroupChat : ChatType.Chat,
      );
    } else {
      message = Message.createSendMessage(
        body: widget.messages.first.body,
        to: to,
        chatType: isGroup ? ChatType.GroupChat : ChatType.Chat,
      );
    }
    message.addProfile();

    final ret = await ChatUIKit.instance.sendMessage(message: message);
    // ignore: invalid_use_of_protected_member
    ChatUIKit.instance.onMessagesReceived([ret]);
    // ignore: invalid_use_of_protected_member
    ChatUIKit.instance.onConversationsUpdate();
  }
}
