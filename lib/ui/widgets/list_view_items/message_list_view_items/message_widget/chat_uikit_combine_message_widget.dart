import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ChatUIKitCombineMessageWidget extends StatelessWidget {
  const ChatUIKitCombineMessageWidget({
    required this.message,
    this.forceLeft,
    this.style,
    super.key,
  });
  final Message message;
  final TextStyle? style;
  final bool? forceLeft;

  @override
  Widget build(BuildContext context) {
    List<String>? str = message.summary?.split('\n');
    debugPrint('text:: $str');
    final theme = ChatUIKitTheme.of(context);
    bool left = forceLeft ?? message.direction == MessageDirection.RECEIVE;

    Widget content = Text(
      message.summary?.replaceAll('\n', '\n') ?? '',
      textScaler: TextScaler.noScaling,
      maxLines: 4,
      style: style ??
          (left
              ? TextStyle(
                  fontWeight: theme.font.bodySmall.fontWeight,
                  fontSize: theme.font.bodySmall.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1,
                )
              : TextStyle(
                  fontWeight: theme.font.bodySmall.fontWeight,
                  fontSize: theme.font.bodySmall.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor1
                      : theme.color.neutralColor98,
                )),
    );

    return content;
  }
}
