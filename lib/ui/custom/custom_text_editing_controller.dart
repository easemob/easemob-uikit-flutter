import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class CustomTextEditingController extends TextEditingController {
  final List<MentionModel> mentionList = [];

  bool needMention = false;
  int lastAtCount = 0;
  bool willChange = false;
  bool isAtAll = false;

  final TextStyle? mentionStyle;

  CustomTextEditingController({
    String? text,
    this.mentionStyle,
  }) : super(text: text);

  void addUser(ChatUIKitProfile profile) {
    String addText = '${profile.showName} '; // 在nickname后面添加空格
    int cursorOffset = value.selection.baseOffset + addText.length;
    final mention = MentionModel(profile);
    mentionList.add(mention);
    value = TextEditingValue(
      text: text.substring(0, value.selection.baseOffset) +
          addText +
          text.substring(value.selection.baseOffset),
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }

  void addText(String newStr) {
    String? str;
    TextSelection currentSelection = selection;
    if (currentSelection.baseOffset != currentSelection.extentOffset) {
      str = text.replaceRange(
          currentSelection.start, currentSelection.end, newStr);
      value = TextEditingValue(
        text: str,
        selection: TextSelection.collapsed(
          offset: currentSelection.start + newStr.length,
        ),
      );
    } else if (currentSelection.baseOffset == 0) {
      str = newStr + text.substring(currentSelection.start);

      value = TextEditingValue(
        text: str,
        selection: TextSelection.collapsed(
            offset: currentSelection.start + newStr.length),
      );
    } else {
      if (currentSelection.start < 0) {
        value = TextEditingValue(
          text: newStr + text,
          selection: TextSelection.collapsed(offset: newStr.length),
        );
      } else {
        str = text.substring(0, currentSelection.start) +
            newStr +
            text.substring(currentSelection.start);

        value = TextEditingValue(
            text: str,
            selection: TextSelection.collapsed(
                offset: currentSelection.start + newStr.length));
      }
    }
  }

  void deleteTextOnCursor() {
    TextSelection currentSelection = selection;
    TextEditingValue currentValue = value;
    if (currentSelection.baseOffset != currentSelection.extentOffset) {
      String subText =
          text.replaceRange(currentSelection.start, currentSelection.end, '');
      TextSelection newSelection =
          TextSelection.collapsed(offset: currentSelection.start);
      value = TextEditingValue(
        text: subText,
        selection: newSelection,
      );
    } else if (currentSelection.baseOffset == 0 &&
        currentSelection.extentOffset == 0) {
      return;
    } else if (currentSelection.baseOffset != currentValue.text.length) {
      String subText = currentValue.text.substring(0, currentSelection.start);
      subText = subText.characters.skipLast(1).toString();
      String newText =
          subText + currentValue.text.substring(currentSelection.start);
      TextSelection newSelection =
          TextSelection.collapsed(offset: subText.length);

      value = TextEditingValue(
        text: newText,
        selection: newSelection,
      );
    } else {
      String newText = currentValue.text.characters.skipLast(1).toString();
      TextSelection newSelection =
          TextSelection.collapsed(offset: newText.length);

      value = TextEditingValue(
        text: newText,
        selection: newSelection,
      );
    }
  }

  void atAll() {
    isAtAll = true;
    String addText = 'All ';
    int cursorOffset = value.selection.baseOffset + addText.length;
    value = TextEditingValue(
      text: text.substring(0, value.selection.baseOffset) +
          addText +
          text.substring(value.selection.baseOffset),
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }

  List<ChatUIKitProfile> getMentionList() {
    return mentionList.map((e) => e.profile).toList();
  }

  // @override
  // TextSpan buildTextSpan({
  //   required BuildContext context,
  //   TextStyle? style,
  //   required bool withComposing,
  // }) {
  //   List<InlineSpan> list = [];

  //   List<RegExpMatch> matchList =
  //       ChatUIKitEmojiData.emojiExp.allMatches(text).toList();
  //   int start = 0;
  //   for (var match in matchList) {
  //     String subText = text.substring(start, match.start);
  //     if (subText.isNotEmpty) {
  //       list.add(TextSpan(text: subText));
  //     }
  //     String emojiStr = text.substring(match.start, match.end);
  //     int index = ChatUIKitEmojiData.emojiList.indexOf(emojiStr);
  //     if (index != -1) {
  //       list.add(WidgetSpan(
  //         child: Image.asset(
  //           ChatUIKitEmojiData.emojiImagePaths[index],
  //           package: ChatUIKitEmojiData.packageName,
  //           width: 20,
  //           height: 20,
  //         ),
  //       ));
  //     } else {
  //       list.add(TextSpan(text: emojiStr));
  //     }
  //     start = match.end;
  //   }
  //   String subText = text.substring(start);
  //   if (subText.isNotEmpty) {
  //     list.add(TextSpan(text: subText));
  //   }

  //   return TextSpan(children: list, style: style);
  // }

  @override
  set value(TextEditingValue newValue) {
    newValue = mentionFilter(newValue);
    super.value = newValue;
  }

  TextEditingValue mentionFilter(TextEditingValue newValue) {
    final currentCount =
        newValue.text.split('').where((element) => element == "@").length;
    needMention = currentCount == lastAtCount + 1;
    lastAtCount = currentCount;
    return newValue;
  }

  void clearMentions() {
    mentionList.clear();
    needMention = false;
    lastAtCount = 0;
    willChange = false;
    isAtAll = false;
  }
}

class MentionModel {
  final ChatUIKitProfile profile;

  MentionModel(
    this.profile,
  );
}
