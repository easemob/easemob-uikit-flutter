import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:em_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:em_chat_uikit/chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';
import 'package:em_chat_uikit/chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

class ChatRoomMessagesView extends StatefulWidget {
  const ChatRoomMessagesView({
    required this.roomId,
    this.onTap,
    this.onLongPress,
    this.itemBuilder,
    super.key,
  });

  final String roomId;

  final Widget? Function(
      BuildContext content, Message msg, ChatUIKitProfile? user)? itemBuilder;
  final void Function(
      BuildContext content, Message msg, ChatUIKitProfile? user)? onTap;
  final void Function(
      BuildContext content, Message msg, ChatUIKitProfile? user)? onLongPress;
  @override
  State<ChatRoomMessagesView> createState() => _ChatRoomMessagesViewState();
}

class _ChatRoomMessagesViewState extends State<ChatRoomMessagesView>
    with
        RoomObserver,
        ChatObserver,
        MessageObserver,
        ChatUIKitProviderObserver,
        ChatUIKitThemeMixin {
  final scrollController = ScrollController();
  final List<Message> messages = [];

  final Map<String, ChatUIKitProfile> profileCache = {};
  int unreadCount = 0;
  ValueNotifier<bool> canMoveToBottom = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    ChatRoomUIKit.instance.addObserver(this);
    ChatUIKitProvider.instance.addObserver(this);
  }

  @override
  void dispose() {
    ChatRoomUIKit.instance.removeObserver(this);
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map, [String? belongId]) {
    if (belongId == widget.roomId) {
      if (ChatRoomUIKit.instance.currentUserId != null) {
        final profile = map[ChatRoomUIKit.instance.currentUserId!];
        if (profile != null && profile.type == ChatUIKitProfileType.contact) {
          profileCache[profile.id] = profile;
          setState(() {});
        }
      }
    }
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final profile = profileCache[msg.from!];
        Widget? listItem = widget.itemBuilder?.call(context, msg, profile) ??
            ChatMessageListItemManager.getMessageListItem(
              msg,
              profileCache[msg.from!],
            );
        listItem = InkWell(
          key: ValueKey(msg.msgId),
          onLongPress: widget.onLongPress != null
              ? () {
                  widget.onLongPress?.call(context, msg, profile);
                }
              : null,
          onTap: widget.onTap != null
              ? () {
                  widget.onTap?.call(context, msg, profile);
                }
              : null,
          child: listItem,
        );
        return listItem;
      },
      findChildIndexCallback: (key) {
        final index = messages.indexWhere((element) {
          return element.msgId == (key as ValueKey<String>).value;
        });

        return index > -1 ? index : null;
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 4);
      },
    );

    content = NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          canMoveToBottom.value = scrollController.position.pixels >=
              scrollController.position.maxScrollExtent;
          if (canMoveToBottom.value) {
            unreadCount = 0;
          }
        }
        return false;
      },
      child: content,
    );

    content = Stack(
      children: [
        content,
        Positioned(
          bottom: 0,
          child: unreadCountWidget(),
        )
      ],
    );

    return content;
  }

  Widget unreadCountWidget() {
    return InkWell(
      onTap: () {
        unreadCount = 0;
        moveToBottom();
      },
      child: ValueListenableBuilder(
        valueListenable: canMoveToBottom,
        builder: (context, value, child) {
          if (value || unreadCount == 0) {
            return const SizedBox.shrink();
          }
          return Container(
            constraints: const BoxConstraints(maxHeight: 26, maxWidth: 181),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: (theme.color.isDark
                  ? theme.color.neutralColor1
                  : theme.color.neutralColor98),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: (theme.color.isDark
                      ? theme.color.primaryColor6
                      : theme.color.primaryColor5),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    () {
                      if (unreadCount < 99) {
                        return '$unreadCount 条新消息';
                      } else {
                        return '99+ 条新消息';
                      }
                    }(),
                    style: TextStyle(
                      height: 1.2,
                      fontWeight: theme.font.labelMedium.fontWeight,
                      fontSize: theme.font.labelMedium.fontSize,
                      color: (theme.color.isDark
                          ? theme.color.primaryColor6
                          : theme.color.primaryColor5),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  onMessagesReceived(messages) {
    List<Message> localMsgs = List.from(messages);
    localMsgs.removeWhere((element) {
      return element.conversationId != widget.roomId || element.isBroadcast;
    });

    for (var msg in localMsgs) {
      final profile = msg.getUserInfo();
      if (profile != null && profile.type == ChatUIKitProfileType.contact) {
        profileCache[profile.id] = profile;
      }
    }

    setState(() {
      this.messages.addAll(localMsgs);
      if (canMoveToBottom.value) {
        moveToBottom();
      } else {
        unreadCount += localMsgs.length;
      }
    });
  }

  @override
  onMessagesRecalledInfo(
    List<RecallMessageInfo> infos,
    List<Message> replaces,
  ) {
    List<String> needDeleteMsgIds =
        infos.map((info) => info.recallMessageId).toList();

    messages.removeWhere((element) {
      return needDeleteMsgIds.contains(element.msgId);
    });

    setState(() {});
  }

  @override
  void onMessageSendSuccess(String msgId, Message msg) {
    if (msg.bodyType == MessageType.CMD) return;

    if (msg.conversationId == widget.roomId && !msg.isBroadcast) {
      final profile = msg.getUserInfo();
      if (profile != null && profile.type == ChatUIKitProfileType.contact) {
        profileCache[profile.id] = profile;
      }
      setState(() {
        messages.add(msg);
        canMoveToBottom.value = true;
        unreadCount = 0;
        moveToBottom();
      });
    }
  }

  void moveToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    }
  }

  @override
  void onMemberJoinedFromChatRoom(
    String roomId,
    String participant,
    String? ext,
  ) {}
}
