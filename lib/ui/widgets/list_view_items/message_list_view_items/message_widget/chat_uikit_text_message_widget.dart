// ignore_for_file: deprecated_member_use
import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitTextMessageWidget extends StatelessWidget {
  const ChatUIKitTextMessageWidget({
    required this.message,
    this.style,
    this.isLeft,
    super.key,
  });
  final TextStyle? style;
  final Message message;
  final bool? isLeft;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    bool left = isLeft ?? message.direction == MessageDirection.RECEIVE;
    Widget content = Text(
      message.textContent,
      textScaleFactor: 1.0,
      style: style ??
          (left
              ? TextStyle(
                  fontWeight: theme.font.bodyLarge.fontWeight,
                  fontSize: theme.font.bodyLarge.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1,
                )
              : TextStyle(
                  fontWeight: theme.font.bodyLarge.fontWeight,
                  fontSize: theme.font.bodyLarge.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor1
                      : theme.color.neutralColor98,
                )),
    );

    if (message.isEdit) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          content,
          Text(
            '已编辑',
            textScaleFactor: 1.0,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: theme.font.bodyExtraSmall.fontWeight,
              fontSize: theme.font.bodyExtraSmall.fontSize,
              color: left
                  ? theme.color.isDark
                      ? theme.color.neutralSpecialColor7
                      : theme.color.neutralSpecialColor5
                  : theme.color.isDark
                      ? theme.color.neutralSpecialColor3
                      : theme.color.neutralSpecialColor98,
            ),
          )
        ],
      );
    }

    return content;
  }
}
