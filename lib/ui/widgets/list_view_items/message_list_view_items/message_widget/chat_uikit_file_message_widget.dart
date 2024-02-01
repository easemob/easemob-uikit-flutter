// ignore_for_file: deprecated_member_use
import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitFileMessageWidget extends StatelessWidget {
  const ChatUIKitFileMessageWidget({
    required this.message,
    this.titleStyle,
    this.subTitleStyle,
    this.bubbleStyle = ChatUIKitMessageListViewBubbleStyle.arrow,
    this.icon,
    this.forceLeft,
    super.key,
  });
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final Message message;
  final Widget? icon;
  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;
  final bool? forceLeft;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    bool left = forceLeft ?? message.direction == MessageDirection.RECEIVE;

    Widget title = Text(
      message.displayName ?? '',
      textScaleFactor: 1.0,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: titleStyle ??
          TextStyle(
            fontWeight: theme.font.titleMedium.fontWeight,
            fontSize: theme.font.titleMedium.fontSize,
            color: left
                ? theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor1
                : theme.color.isDark
                    ? theme.color.neutralColor1
                    : theme.color.neutralColor98,
          ),
    );
    Widget subTitle = Text(
      message.fileSizeStr,
      textScaleFactor: 1.0,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: subTitleStyle ??
          TextStyle(
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
            color: left
                ? theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralSpecialColor5
                : theme.color.isDark
                    ? theme.color.neutralColor2
                    : theme.color.neutralColor95,
          ),
    );

    Widget fileIcon = ChatUIKitImageLoader.file(
        width: 32,
        height: 32,
        color: theme.color.isDark
            ? theme.color.neutralColor6
            : theme.color.neutralColor7);
    fileIcon = Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(
              bubbleStyle == ChatUIKitMessageListViewBubbleStyle.arrow
                  ? 4
                  : 8)),
          color: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor100),
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.only(
        top: 4,
        bottom: 4,
      ),
      width: 44,
      height: 44,
      child: fileIcon,
    );

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [title, subTitle],
    );

    content = Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: !left ? TextDirection.rtl : TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: content),
        const SizedBox(width: 12),
        icon ?? fileIcon
      ],
    );

    return content;
  }
}
