// ignore_for_file: deprecated_member_use
import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ChatUIKitNonsupportMessageWidget extends StatelessWidget {
  const ChatUIKitNonsupportMessageWidget({
    required this.message,
    this.style,
    this.forceLeft,
    super.key,
  });

  final TextStyle? style;
  final Message message;
  final bool? forceLeft;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    bool left = forceLeft ?? message.direction == MessageDirection.RECEIVE;
    Widget content = Text(
      ChatUIKitLocal.nonSupportMessage.getString(context),
      textScaleFactor: 1.0,
      overflow: TextOverflow.ellipsis,
      style: style ??
          (left
              ? TextStyle(
                  fontWeight: theme.font.bodyLarge.fontWeight,
                  fontSize: theme.font.bodyLarge.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor5
                      : theme.color.neutralColor7,
                )
              : TextStyle(
                  fontWeight: theme.font.bodyLarge.fontWeight,
                  fontSize: theme.font.bodyLarge.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor1
                      : theme.color.neutralColor98,
                )),
    );

    return content;
  }
}
