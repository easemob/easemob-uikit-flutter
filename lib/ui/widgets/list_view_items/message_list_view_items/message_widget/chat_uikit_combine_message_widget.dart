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
    final theme = ChatUIKitTheme.of(context);
    bool left = forceLeft ?? message.direction == MessageDirection.RECEIVE;

    List<Widget> widgets = [];
    Widget content = Text(
      summary(context),
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

    widgets.add(content);
    widgets.add(const SizedBox(height: 4));
    widgets.add(
      RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
                child: ChatUIKitImageLoader.messageHistory(
              width: 16,
              height: 16,
              color: left
                  ? theme.color.isDark
                      ? theme.color.neutralSpecialColor7
                      : theme.color.neutralSpecialColor5
                  : theme.color.isDark
                      ? theme.color.neutralSpecialColor3
                      : theme.color.neutralSpecialColor98,
            )),
            TextSpan(
              text: '聊天记录',
              style: TextStyle(
                fontWeight: theme.font.labelSmall.fontWeight,
                fontSize: theme.font.labelSmall.fontSize,
                color: left
                    ? theme.color.isDark
                        ? theme.color.neutralSpecialColor7
                        : theme.color.neutralSpecialColor5
                    : theme.color.isDark
                        ? theme.color.neutralSpecialColor3
                        : theme.color.neutralSpecialColor98,
              ),
            ),
          ],
        ),
        textScaler: TextScaler.noScaling,
        overflow: TextOverflow.ellipsis,
      ),
    );
    content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: widgets,
    );

    return content;
  }

  String summary(BuildContext context) {
    List<String> summaries = [];
    List<String> tmpList = message.summary?.split('\n') ?? [];
    for (var str in tmpList) {
      int begin = str.indexOf('[');
      if (begin == -1) {
        summaries.add(str);
        continue;
      }
      int end = str.indexOf(']');
      if (end == -1) {
        summaries.add(str);
        continue;
      }
      String typeStr = str.substring(begin + 1, end);

      if (typeStr == 'Image') {
        typeStr = ChatUIKitLocal.messageCellCombineImage.getString(context);
      }
      if (typeStr == 'Voice') {
        typeStr = ChatUIKitLocal.messageCellCombineVoice.getString(context);
      }
      if (typeStr == 'Location') {
        typeStr = ChatUIKitLocal.messageCellCombineLocation.getString(context);
      }
      if (typeStr == 'Video') {
        typeStr = ChatUIKitLocal.messageCellCombineVideo.getString(context);
      }
      if (typeStr == 'File') {
        typeStr = ChatUIKitLocal.messageCellCombineFile.getString(context);
      }
      if (typeStr == 'Combine') {
        typeStr = ChatUIKitLocal.messageCellCombineCombine.getString(context);
      }

      String tmp = str.substring(0, begin + 1) + typeStr + str.substring(end);

      summaries.add(tmp);
    }
    return summaries.join('\n');
  }
}
