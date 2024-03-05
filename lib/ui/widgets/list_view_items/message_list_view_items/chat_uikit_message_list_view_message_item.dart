// ignore_for_file: deprecated_member_use
import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/universal/defines.dart';
import 'package:flutter/material.dart';

typedef MessageItemBubbleBuilder = Widget? Function(
  BuildContext context,
  Widget child,
  Message message,
);

typedef MessageBubbleContentBuilder = Widget? Function(
  BuildContext context,
  Message message,
);

class ChatUIKitMessageListViewMessageItem extends StatelessWidget {
  const ChatUIKitMessageListViewMessageItem({
    required this.message,
    this.bubbleStyle = ChatUIKitMessageListViewBubbleStyle.arrow,
    this.showAvatar = true,
    this.showNickname = true,
    this.messageWidget,
    this.avatarWidget,
    this.nicknameWidget,
    this.onNicknameTap,
    this.onAvatarTap,
    this.onAvatarLongPressed,
    this.onBubbleTap,
    this.onBubbleLongPressed,
    this.onBubbleDoubleTap,
    this.forceLeft,
    this.isPlaying = false,
    this.quoteBuilder,
    this.onErrorTap,
    this.bubbleBuilder,
    this.bubbleContentBuilder,
    this.enableSelected,
    super.key,
  });

  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;
  final Message message;
  final bool showAvatar;
  final bool showNickname;
  final bool? forceLeft;
  final Widget? messageWidget;
  final Widget? avatarWidget;
  final Widget? nicknameWidget;
  final bool isPlaying;

  final VoidCallback? onAvatarTap;
  final VoidCallback? onAvatarLongPressed;
  final VoidCallback? onNicknameTap;
  final VoidCallback? onBubbleTap;
  final VoidCallback? onBubbleLongPressed;
  final VoidCallback? onBubbleDoubleTap;
  final VoidCallback? enableSelected;
  final Widget Function(BuildContext context, QuoteModel model)? quoteBuilder;
  final VoidCallback? onErrorTap;
  final MessageItemBubbleBuilder? bubbleBuilder;
  final MessageBubbleContentBuilder? bubbleContentBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    bool left = forceLeft ?? message.direction == MessageDirection.RECEIVE;

    Widget? msgWidget = messageWidget;

    if (message.bodyType == MessageType.TXT) {
      msgWidget = _buildTextMessage(context, message, left);
    } else if (message.bodyType == MessageType.IMAGE) {
      msgWidget = _buildImageMessage(context, message, left);
    } else if (message.bodyType == MessageType.VOICE) {
      msgWidget = _buildVoiceMessage(context, message, left);
    } else if (message.bodyType == MessageType.VIDEO) {
      msgWidget = _buildVideoMessage(context, message, left);
    } else if (message.bodyType == MessageType.FILE) {
      msgWidget = _buildFileMessage(context, message, left);
    } else if (message.bodyType == MessageType.CUSTOM) {
      if (message.isCardMessage) {
        msgWidget = _buildCardMessage(context, message, left);
      }
    }
    msgWidget ??= _buildNonsupportMessage(context, message, left);

    Widget content;

    if (message.bodyType == MessageType.VIDEO ||
        message.bodyType == MessageType.IMAGE) {
      content = bubbleBuilder?.call(context, msgWidget, message) ?? msgWidget;
    } else {
      content = bubbleBuilder?.call(context, msgWidget, message) ??
          ChatUIKitMessageListViewBubble(
            key: ValueKey(message.localTime),
            needSmallCorner: message.getQuote == null,
            style: bubbleStyle,
            isLeft: left,
            child: msgWidget,
          );
    }

    if (message.bodyType == MessageType.VOICE) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          if (message.direction == MessageDirection.RECEIVE &&
              !(message.attributes?[voiceHasReadKey] == true))
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            )
        ],
      );
    }
    content = InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: enableSelected != null ? null : onBubbleTap,
      onDoubleTap: enableSelected != null ? null : onBubbleDoubleTap,
      onLongPress: enableSelected != null ? null : onBubbleLongPressed,
      child: content,
    );

    if (left == false ||
        (forceLeft == true && message.direction == MessageDirection.SEND)) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: left ? TextDirection.rtl : TextDirection.ltr,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: ChatUIKitMessageStatusWidget(
              onErrorTap: onErrorTap,
              size: 16,
              statusType: () {
                if (message.status == MessageStatus.CREATE ||
                    message.status == MessageStatus.PROGRESS) {
                  return MessageStatusType.loading;
                } else if (message.status == MessageStatus.FAIL) {
                  return MessageStatusType.fail;
                } else {
                  if (message.hasDeliverAck) {
                    return MessageStatusType.deliver;
                  } else if (message.hasReadAck) {
                    return MessageStatusType.read;
                  }
                  return MessageStatusType.succeed;
                }
              }(),
            ),
          ),
          const SizedBox(width: 4),
          Flexible(flex: 1, fit: FlexFit.loose, child: content),
        ],
      );
    }
    content = Column(
      crossAxisAlignment:
          left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        showNickname
            ? _nickname(theme, context, isLeft: left)
            : const SizedBox(),
        if (message.hasQuote)
          quoteWidget(context, message.getQuote!, isLeft: left),
        content,
        SizedBox(
          height: 16,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                left ? MainAxisAlignment.start : MainAxisAlignment.end,
            textDirection: left ? TextDirection.ltr : TextDirection.rtl,
            children: [
              SizedBox(width: getArrowWidth),
              Text(
                textScaleFactor: 1.0,
                overflow: TextOverflow.ellipsis,
                ChatUIKitTimeFormatter.instance.formatterHandler?.call(
                      context,
                      ChatUIKitTimeType.message,
                      message.serverTime,
                    ) ??
                    ChatUIKitTimeTool.getChatTimeStr(message.serverTime,
                        needTime: true),
                textDirection: left ? TextDirection.ltr : TextDirection.rtl,
                style: TextStyle(
                    fontWeight: theme.font.bodySmall.fontWeight,
                    fontSize: theme.font.bodySmall.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralColor5
                        : theme.color.neutralColor7),
              ),
            ],
          ),
        ),
      ],
    );

    Widget avatar = _avatar(theme, context);
    avatar = Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: avatar,
    );

    content = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      textDirection: left ? TextDirection.ltr : TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
      children: [
        avatar,
        const SizedBox(width: 8),
        Expanded(child: content),
      ],
    );

    content = Container(
      margin: const EdgeInsets.only(top: 16, bottom: 2),
      child: content,
    );

    if (enableSelected != null) {
      content = InkWell(
        onTap: enableSelected,
        child: content,
      );
    }

    return content;
  }

  Widget _buildTextMessage(BuildContext context, Message message, bool isLeft) {
    return bubbleContentBuilder?.call(context, message) ??
        ChatUIKitTextMessageWidget(message: message, isLeft: isLeft);
  }

  Widget _buildImageMessage(
      BuildContext context, Message message, bool isLeft) {
    return bubbleContentBuilder?.call(context, message) ??
        ChatUIKitImageMessageWidget(
          message: message,
          bubbleStyle: bubbleStyle,
          isLeft: isLeft,
        );
  }

  Widget _buildVoiceMessage(
    BuildContext context,
    Message message,
    bool isLeft,
  ) {
    Widget? content = bubbleContentBuilder?.call(context, message);
    content ??= ChatUIKitVoiceMessageWidget(
      message: message,
      playing: isPlaying,
      forceLeft: isLeft,
    );

    return content;
  }

  Widget _buildVideoMessage(
      BuildContext context, Message message, bool isLeft) {
    return bubbleContentBuilder?.call(context, message) ??
        ChatUIKitVideoMessageWidget(
          message: message,
          bubbleStyle: bubbleStyle,
          forceLeft: isLeft,
        );
  }

  Widget _buildFileMessage(BuildContext context, Message message, bool isLeft) {
    return bubbleContentBuilder?.call(context, message) ??
        ChatUIKitFileMessageWidget(
            message: message, bubbleStyle: bubbleStyle, forceLeft: isLeft);
  }

  Widget _buildCardMessage(BuildContext context, Message message, bool isLeft) {
    return bubbleContentBuilder?.call(context, message) ??
        ChatUIKitCardMessageWidget(
          message: message,
          forceLeft: isLeft,
        );
  }

  Widget _buildNonsupportMessage(
      BuildContext context, Message message, bool isLeft) {
    return bubbleContentBuilder?.call(context, message) ??
        ChatUIKitNonsupportMessageWidget(
          message: message,
          forceLeft: isLeft,
        );
  }

  Widget _avatar(ChatUIKitTheme theme, BuildContext context) {
    Widget? content;
    if (!showAvatar) return const SizedBox();
    content = avatarWidget;
    if (content == null) {
      String? avatarUrl = MessageListShareUserData.of(context)
              ?.data[message.from!]
              ?.avatarUrl ??
          message.avatarUrl;
      content = ChatUIKitAvatar(avatarUrl: avatarUrl);
    }

    content = InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: enableSelected != null ? null : onAvatarTap,
      onLongPress: enableSelected != null ? null : onAvatarLongPressed,
      child: content,
    );

    return content;
  }

  Widget _nickname(ChatUIKitTheme theme, BuildContext context,
      {bool isLeft = false}) {
    if (!showNickname) return const SizedBox();
    String nickname =
        MessageListShareUserData.of(context)?.data[message.from!]?.nickname ??
            message.nickname ??
            message.from!;
    Widget content = nicknameWidget ??
        Text(
          nickname,
          textScaleFactor: 1.0,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: theme.font.labelSmall.fontWeight,
              fontSize: theme.font.labelSmall.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralSpecialColor6
                  : theme.color.neutralSpecialColor5),
        );

    content = InkWell(
      onTap: enableSelected != null ? null : onNicknameTap,
      child: content,
    );

    content = Padding(
      padding: EdgeInsets.only(
        left: isLeft ? getArrowWidth : 0,
        right: !isLeft ? getArrowWidth : 0,
      ),
      child: content,
    );

    return content;
  }

  Widget quoteWidget(BuildContext context, QuoteModel model,
      {bool isLeft = false}) {
    Widget? content = quoteBuilder?.call(context, model);
    content = Padding(
      padding: EdgeInsets.only(
        left: isLeft ? getArrowWidth : 0,
        right: !isLeft ? getArrowWidth : 0,
      ),
      child: content,
    );

    return content;
  }

  double get getArrowWidth =>
      bubbleStyle == ChatUIKitMessageListViewBubbleStyle.arrow ? arrowWidth : 0;
}
