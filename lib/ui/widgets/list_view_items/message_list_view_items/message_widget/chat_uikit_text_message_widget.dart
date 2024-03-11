import 'dart:math';

import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ChatUIKitTextMessageWidget extends StatelessWidget {
  const ChatUIKitTextMessageWidget({
    required this.model,
    this.style,
    this.forceLeft,
    super.key,
  });
  final TextStyle? style;
  final MessageModel model;
  final bool? forceLeft;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    bool left =
        forceLeft ?? model.message.direction == MessageDirection.RECEIVE;

    String str = model.message.textContent;

    TextStyle tmpStyle = style ??
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
              ));

    Widget content = ChatUIKitEmojiRichText(
      text: str,
      style: tmpStyle,
    );

    List<Widget> widgets = [content];

    if (model.message.isEdit) {
      widgets.add(
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                  child: ChatUIKitImageLoader.messageLongPressEdit(
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
                text: '已编辑',
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
    }
    if (model.message.hasTranslate) {
      widgets.add(
        SizedBox(
            width: getSize(theme),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Divider(
                height: 0.5,
                color: theme.color.isDark
                    ? theme.color.neutralColor3
                    : theme.color.neutralColor95,
              ),
            )),
      );
      widgets.add(
        ChatUIKitEmojiRichText(
          text: model.message.translateText,
          style: TextStyle(
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
            color: left
                ? theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor1
                : theme.color.isDark
                    ? theme.color.neutralColor1
                    : theme.color.neutralColor98,
          ),
        ),
      );

      widgets.add(
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                  child: ChatUIKitImageLoader.messageLongPressTranslate(
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
                text: '已翻译',
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
    }

    content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: widgets,
    );

    return content;
  }

  double getSize(ChatUIKitTheme theme) {
    TextStyle tmpStyle = TextStyle(
      fontWeight: theme.font.bodyLarge.fontWeight,
      fontSize: theme.font.bodyLarge.fontSize,
    );

    TextPainter painter1 = TextPainter(
      text: TextSpan(
        text: model.message.textContent,
        style: tmpStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    TextPainter painter2 = TextPainter(
      text: TextSpan(
        text: model.message.translateText,
        style: tmpStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    TextPainter painter3 = TextPainter(
      text: TextSpan(
        text: '已翻译',
        style: tmpStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    TextPainter painter4 = TextPainter(
      text: TextSpan(
        text: '已编辑',
        style: tmpStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return max(max(painter1.size.width, painter2.size.width),
            max(painter3.size.width, painter4.size.width)) +
        5;
  }

  TextSpan textSpan(Widget widget, String text, ChatUIKitTheme theme) {
    return TextSpan(
      children: [
        WidgetSpan(
            child: ChatUIKitImageLoader.messageLongPressTranslate(
          width: 16,
          height: 16,
        )),
        TextSpan(
          text: '已翻译',
          style: TextStyle(
            fontWeight: theme.font.labelSmall.fontWeight,
            fontSize: theme.font.labelSmall.fontSize,
          ),
        ),
      ],
    );
  }
}
