import 'package:em_chat_uikit/chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

class ChatRoomTextEditingController extends TextEditingController {
  List<EmojiIndex> includeEmojis = [];

  ChatRoomTextEditingController() {
    debugPrint('ChatRoomTextEditingController');
  }

  @override
  set value(TextEditingValue newValue) {
    assert(
      !newValue.composing.isValid || newValue.isComposingRangeValid,
      'New TextEditingValue $newValue has an invalid non-empty composing range '
      '${newValue.composing}. It is recommended to use a valid composing range, '
      'even for readonly text fields',
    );
    super.value = newValue;
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    int firstIndex = 0;
    includeEmojis.clear();
    do {
      firstIndex = text.indexOf('[', firstIndex);
      if (firstIndex != -1 && text.isNotEmpty) {
        final secondIndex = text.indexOf(']', firstIndex);
        if (secondIndex != -1) {
          String subTxt = text.substring(firstIndex, secondIndex + 1);
          if (EmojiMapping.emojis.contains(subTxt)) {
            includeEmojis.add(EmojiIndex(
              index: firstIndex,
              length: subTxt.length,
              emoji: subTxt,
            ));
          }
        } else {
          break;
        }
        firstIndex = secondIndex + 1;
      }
    } while (firstIndex != -1);

    List<InlineSpan> tp = [];

    if (includeEmojis.isNotEmpty) {
      int index = 0;
      for (var item in includeEmojis) {
        if (item.index > index) {
          tp.add(TextSpan(
            text: text.substring(index, item.index),
            style: style,
          ));
        }
        tp.add(
          WidgetSpan(
            child: ChatRoomImageLoader.emoji(item.emoji, size: 20),
          ),
        );
        index = item.index + item.length;
      }
      if (index < text.length) {
        tp.add(TextSpan(
          text: text.substring(index, text.length),
          style: style,
        ));
      }
    } else {
      tp.add(TextSpan(
        text: text,
        style: style,
      ));
    }

    return TextSpan(children: tp);
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
