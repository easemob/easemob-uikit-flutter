import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:em_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:em_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';
import 'package:em_chat_uikit/chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

class ChatMessageListItemManager {
  static Widget getMessageListItem(Message message, ChatUIKitProfile? user) {
    if (message.isJoinNotify) {
      return ChatRoomUserJoinListItem(message, user);
    } else if (message.isGift) {
      return ChatRoomGiftListItem(message, user);
    } else {
      return ChatRoomTextMessageListItem(message, user);
    }
  }
}

class ChatRoomMessageListItem extends StatefulWidget {
  const ChatRoomMessageListItem(this.msg, {this.child, this.user, super.key});
  final Message msg;
  final ChatUIKitProfile? user;
  final TextSpan? child;
  @override
  State<ChatRoomMessageListItem> createState() =>
      _ChatRoomMessageListItemState();
}

class _ChatRoomMessageListItemState extends State<ChatRoomMessageListItem>
    with ChatUIKitThemeMixin {
  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    List<InlineSpan> list = [];
    // time
    if (ChatRoomUIKitSettings.enableMsgListTime) {
      list.add(TextSpan(text: TimeTool.timeStrByMs(widget.msg.serverTime)));
    }

    ChatUIKitProfile? userProfile = widget.user ?? widget.msg.getUserInfo();
    if (ChatRoomUIKitSettings.enableMsgListIdentify) {
      if (userProfile?.identify?.isNotEmpty == true) {
        list.add(WidgetSpan(
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7.5))),
            margin: const EdgeInsets.only(left: 4),
            width: 15,
            height: 15,
            child: ChatRoomImageLoader.networkImage(
              image: userProfile!.identify!,
              size: 15,
              placeholderWidget: (ChatRoomUIKitSettings.defaultIdentify == null)
                  ? Container()
                  : Image.asset(ChatRoomUIKitSettings.defaultIdentify!,
                      width: 15, height: 15),
            ),
          ),
          alignment: PlaceholderAlignment.middle,
        ));
      }
    }

    if (ChatRoomUIKitSettings.enableMsgListAvatar) {
      list.add(
        TextSpan(children: [
          WidgetSpan(
            child: ChatRoomUIKitAvatar(
              width: 18,
              height: 18,
              user: userProfile,
              margin: const EdgeInsets.only(left: 4),
            ),
            alignment: PlaceholderAlignment.middle,
          ),
        ]),
      );
    }
    if (ChatRoomUIKitSettings.enableMsgListNickname) {
      list.add(
        TextSpan(children: [
          const WidgetSpan(
            child: Padding(
              padding: EdgeInsets.only(left: 4),
            ),
          ),
          TextSpan(
            text: userProfile?.nickname,
            style: TextStyle(
              color: (theme.color.isDark
                  ? theme.color.primaryColor8
                  : theme.color.primaryColor8),
              fontWeight: theme.font.labelMedium.fontWeight,
              fontSize: theme.font.labelMedium.fontSize,
            ),
          ),
        ]),
      );
    }

    if (widget.child != null) {
      list.add(widget.child!);
    }

    Widget content = Text.rich(
      TextSpan(
        style: TextStyle(
          height: 1,
          color: Colors.white,
          fontSize: theme.font.bodyMedium.fontSize,
          fontWeight: theme.font.bodyMedium.fontWeight,
        ),
        children: list,
      ),
    );

    content = Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.color.isDark
              ? theme.color.barrageColor1
              : theme.color.barrageColor2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: content,
    );

    content = Align(
      alignment: Alignment.centerLeft,
      child: content,
    );

    return content;
  }
}

class ChatRoomUserJoinListItem extends StatefulWidget {
  const ChatRoomUserJoinListItem(this.msg, this.user, {super.key});
  final Message msg;
  final ChatUIKitProfile? user;
  @override
  State<ChatRoomUserJoinListItem> createState() =>
      _ChatRoomUserJoinListItemState();
}

class _ChatRoomUserJoinListItemState extends State<ChatRoomUserJoinListItem>
    with ChatUIKitThemeMixin {
  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    return ChatRoomMessageListItem(
      widget.msg,
      user: widget.user,
      // TODO: 国际化
      child: TextSpan(
          text: " 加入聊天室",
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.secondaryColor7
                : theme.color.secondaryColor8,
          )),
    );
  }
}

class ChatRoomGiftListItem extends StatefulWidget {
  const ChatRoomGiftListItem(this.msg, this.user, {super.key});
  final Message msg;
  final ChatUIKitProfile? user;
  @override
  State<ChatRoomGiftListItem> createState() => _ChatRoomGiftListItemState();
}

class _ChatRoomGiftListItemState extends State<ChatRoomGiftListItem>
    with ChatUIKitThemeMixin {
  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    if (!widget.msg.isGift) return const SizedBox();
    ChatRoomGift? gift = widget.msg.getGift();

    return ChatRoomMessageListItem(
      widget.msg,
      user: widget.user,
      // TODO: 国际化
      child: TextSpan(
        children: [
          const WidgetSpan(child: Padding(padding: EdgeInsets.only(left: 4))),
          // TODO 礼物名称国际化
          TextSpan(text: gift!.giftName ?? '礼物'),
          WidgetSpan(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(9)),
              ),
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(left: 4),
              child: ChatRoomImageLoader.networkImage(
                image: gift.giftIcon,
                size: 18,
                placeholderWidget:
                    (ChatRoomUIKitSettings.defaultGiftIcon == null)
                        ? Container()
                        : Image.asset(
                            ChatRoomUIKitSettings.defaultGiftIcon!,
                          ),
              ),
            ),
            alignment: PlaceholderAlignment.middle,
          ),
        ],
      ),
    );
  }
}

class ChatRoomTextMessageListItem extends StatefulWidget {
  const ChatRoomTextMessageListItem(this.msg, this.user, {super.key});
  final Message msg;
  final ChatUIKitProfile? user;
  @override
  State<ChatRoomTextMessageListItem> createState() =>
      _ChatRoomTextMessageListItemState();
}

class _ChatRoomTextMessageListItemState
    extends State<ChatRoomTextMessageListItem> with ChatUIKitThemeMixin {
  String? content;
  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    if (widget.msg.body.type == MessageType.TXT) {
      TextMessageBody body = widget.msg.body as TextMessageBody;
      // TODO: 翻译
      // body.translations?.forEach((key, value) {
      //   if (key.contains(
      //       LanguageConvertor.instance.targetLanguage(context).code)) {
      //     content = value;
      //   }
      // });

      content ??= body.content;
    }

    content = EmojiMapping.replaceEmojiToImage(content!);

    List<InlineSpan> list = [];
    List<EmojiIndex> indexList = [];

    String tmpStr = content!;
    for (var element in EmojiMapping.emojiImages) {
      int indexFirst = 0;
      do {
        indexFirst = tmpStr.indexOf(element, indexFirst);
        if (indexFirst == -1) {
          break;
        }

        indexList.add(EmojiIndex(
          emoji: element,
          index: indexFirst,
          length: element.length,
        ));
        indexFirst += element.length;
      } while (indexFirst != -1);
    }

    indexList.sort((a, b) => a.index.compareTo(b.index));
    EmojiIndex? lastIndex;
    for (final emojiIndex in indexList) {
      if (lastIndex == null) {
        list.add(TextSpan(text: content!.substring(0, emojiIndex.index)));
      } else {
        list.add(
          TextSpan(
            text: content!.substring(
              lastIndex.index + lastIndex.length,
              emojiIndex.index,
            ),
          ),
        );
      }
      list.add((WidgetSpan(
          child: ChatRoomImageLoader.emoji(emojiIndex.emoji, size: 20))));

      lastIndex = emojiIndex;
    }

    if (lastIndex != null) {
      list.add(
        TextSpan(
          text: content!.substring(lastIndex.index + lastIndex.emoji.length),
        ),
      );
    } else {
      list.add(
        TextSpan(text: content),
      );
    }

    return ChatRoomMessageListItem(
      widget.msg,
      user: widget.user,
      child: TextSpan(
        children: [
          const WidgetSpan(child: Padding(padding: EdgeInsets.only(left: 4))),
          TextSpan(children: list),
        ],
      ),
    );
  }
}
