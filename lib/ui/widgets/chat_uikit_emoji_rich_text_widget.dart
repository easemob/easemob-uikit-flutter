import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitEmojiRichText extends StatelessWidget {
  const ChatUIKitEmojiRichText({
    required this.text,
    this.style,
    this.emojiSize = const Size(20, 20),
    super.key,
  });

  final String text;
  final TextStyle? style;
  final Size emojiSize;

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];
    List<String> characters = text.characters.toList();

    String string = '';
    for (var i = 0; i < characters.length; i++) {
      if (!ChatUIKitEmojiData.emojiList.contains(characters[i])) {
        string += characters[i];
      } else {
        spans.add(TextSpan(text: string));
        spans.add(WidgetSpan(
          child: Padding(
            padding: EdgeInsets.only(
              left: string.isNotEmpty ? 2.0 : 0,
              right: (i == characters.length) ? 0 : 2.0,
            ),
            child: Image.asset(
              ChatUIKitEmojiData.emojiMapReversed[characters[i]]!,
              package: ChatUIKitEmojiData.packageName,
              width: emojiSize.width,
              height: emojiSize.height,
            ),
          ),
        ));
        string = '';
      }
    }

    if (string.isNotEmpty) {
      spans.add(TextSpan(text: string));
    }

    return RichText(
      text: TextSpan(children: spans, style: style),
      textScaler: TextScaler.noScaling,
    );
  }
}

class EmojiIndex {
  int index;
  int length;
  String emoji;
  EmojiIndex({
    required this.index,
    required this.length,
    required this.emoji,
  });
}
