// ignore_for_file: deprecated_member_use

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class HighlightTool {
  static Widget highlightWidget(
    BuildContext context,
    String text, {
    String? searchKey,
    TextStyle? textStyle,
    TextStyle? highlightStyle,
  }) {
    final theme = ChatUIKitTheme.of(context);

    TextStyle normalStyle = textStyle ??
        TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontSize: theme.font.titleMedium.fontSize,
          fontWeight: theme.font.titleMedium.fontWeight,
        );

    TextStyle highStyle = highlightStyle ??
        TextStyle(
          color: theme.color.isDark
              ? theme.color.primaryColor6
              : theme.color.primaryColor5,
          fontWeight: theme.font.titleMedium.fontWeight,
          fontSize: theme.font.titleMedium.fontSize,
        );

    String showName = text.toLowerCase();
    String keyword = searchKey?.toLowerCase() ?? '';

    Widget? name;
    int index = showName.indexOf(keyword);
    if (index != -1 && keyword.isNotEmpty) {
      List<InlineSpan> tmp = [];
      tmp.add(TextSpan(text: text.substring(0, index)));
      tmp.add(TextSpan(
          text: text.substring(index, index + keyword.length),
          style: highStyle));
      tmp.add(TextSpan(text: text.substring(index + keyword.length)));

      name = RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: tmp,
          style: normalStyle,
        ),
        textScaleFactor: 1.0,
      );
    }

    name ??= Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: normalStyle,
      textScaleFactor: 1.0,
    );
    return name;
  }
}
