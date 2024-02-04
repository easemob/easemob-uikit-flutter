// ignore_for_file: deprecated_member_use

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    required this.title,
    this.imageWidget,
    this.trailingString,
    this.trailingWidget,
    this.enableArrow = false,
    super.key,
  });

  final Widget? imageWidget;
  final String title;
  final String? trailingString;
  final Widget? trailingWidget;
  final bool enableArrow;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = SizedBox(
      height: 54,
      child: Row(
        children: [
          if (imageWidget != null)
            SizedBox(
              width: 28,
              height: 28,
              child: imageWidget,
            ),
          if (imageWidget != null) const SizedBox(width: 8),
          Text(
            title,
            textScaleFactor: 1.0,
            style: TextStyle(
              fontSize: theme.font.titleMedium.fontSize,
              fontWeight: theme.font.titleMedium.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor100
                  : theme.color.neutralColor1,
            ),
          ),
          Expanded(child: Container()),
          if (trailingWidget != null) trailingWidget!,
          if (trailingWidget == null)
            Text(
              trailingString ?? '',
              textAlign: TextAlign.right,
              textScaleFactor: 1.0,
              style: TextStyle(
                fontSize: theme.font.labelMedium.fontSize,
                fontWeight: theme.font.labelMedium.fontWeight,
                color: theme.color.isDark
                    ? theme.color.neutralColor7
                    : theme.color.neutralColor5,
              ),
            ),
          if (enableArrow) const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );

    content = Padding(
      padding: const EdgeInsets.only(left: 16, right: 10),
      child: content,
    );

    content = Stack(
      children: [
        content,
        Positioned(
          left: imageWidget != null ? 36 : 16,
          right: 0,
          bottom: 0,
          child: Divider(
            height: 0.5,
            color: theme.color.isDark
                ? theme.color.neutralColor2
                : theme.color.neutralColor9,
          ),
        ),
      ],
    );

    return content;
  }
}