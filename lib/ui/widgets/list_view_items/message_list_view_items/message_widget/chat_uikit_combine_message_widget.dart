import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatUIKitCombineMessageWidget extends StatelessWidget {
  const ChatUIKitCombineMessageWidget({
    required this.model,
    this.forceLeft,
    this.style,
    this.summaryBuilder,
    super.key,
  });
  final MessageModel model;
  final TextStyle? style;
  final bool? forceLeft;
  final String? Function(BuildContext context, String summary)? summaryBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    bool left = forceLeft ?? model.message.direction == MessageDirection.RECEIVE;

    List<Widget> widgets = [];
    Widget content = ChatUIKitEmojiRichText(
      emojiSize: const Size(14, 14),
      text: summary(context),
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

    content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );

    content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        content,
        const SizedBox(height: 4),
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
      ],
    );

    return content;
  }

  String summary(BuildContext context) {
    List<String> summaries = [];
    List<String> tmpList = model.message.summary?.split('\n') ?? [];
    for (var str in tmpList) {
      String? summaryTmp = summaryBuilder?.call(context, str);
      if (summaryTmp?.isNotEmpty == true) {
        summaries.add(summaryTmp!);
        continue;
      }
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

      if (begin > end) {
        summaries.add(str);
        continue;
      }

      String typeStr = str.substring(begin, end + 1);

      bool hasCatch = false;
      if (typeStr == '[Image]') {
        typeStr = ChatUIKitLocal.messageCellCombineImage.getString(context);
        hasCatch = true;
      }
      if (typeStr == '[Voice]') {
        typeStr = ChatUIKitLocal.messageCellCombineVoice.getString(context);
        hasCatch = true;
      }
      if (typeStr == '[Location]') {
        typeStr = ChatUIKitLocal.messageCellCombineLocation.getString(context);
        hasCatch = true;
      }
      if (typeStr == '[Video]') {
        typeStr = ChatUIKitLocal.messageCellCombineVideo.getString(context);
        hasCatch = true;
      }
      if (typeStr == '[File]') {
        typeStr = ChatUIKitLocal.messageCellCombineFile.getString(context);
        hasCatch = true;
      }
      if (typeStr == '[Combine]') {
        typeStr = ChatUIKitLocal.messageCellCombineCombine.getString(context);
        hasCatch = true;
      }
      if (hasCatch == true) {
        String tmp = str.substring(0, begin + 1) + typeStr + str.substring(end);
        summaries.add(tmp);
      } else {
        summaries.add(str);
      }
    }
    return summaries.join('\n');
  }
}
