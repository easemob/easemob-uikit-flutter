// ignore_for_file: deprecated_member_use
import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitDetailsListViewItem extends StatelessWidget {
  const ChatUIKitDetailsListViewItem(
      {required this.title, this.trailing, super.key});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textScaleFactor: 1.0,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: theme.font.headlineSmall.fontWeight,
            fontSize: theme.font.headlineSmall.fontSize,
            color: theme.color.isDark
                ? theme.color.neutralColor100
                : theme.color.neutralColor1,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: trailing ?? const SizedBox(),
          ),
        )
      ],
    );

    // Widget content = SizedBox(
    //   height: 54,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       SizedBox(
    //         height: 53.5,
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Text(
    //               title,
    //               textScaleFactor: 1.0,
    //               overflow: TextOverflow.ellipsis,
    //               style: TextStyle(
    //                 fontWeight: theme.font.headlineSmall.fontWeight,
    //                 fontSize: theme.font.headlineSmall.fontSize,
    //                 color: theme.color.isDark
    //                     ? theme.color.neutralColor100
    //                     : theme.color.neutralColor1,
    //               ),
    //             ),
    //             const SizedBox(width: 16),
    //             Expanded(
    //               child: Align(
    //                 alignment: Alignment.centerRight,
    //                 child: trailing ?? const SizedBox(),
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //       Divider(
    //         height: borderHeight,
    //         thickness: borderHeight,
    //         color: theme.color.isDark
    //             ? theme.color.neutralColor2
    //             : theme.color.neutralColor9,
    //       )
    //     ],
    //   ),
    // );

    content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: content,
    );

    content = Stack(
      children: [
        content,
        Positioned(
          bottom: 0,
          left: 16,
          right: 0,
          height: 0.5,
          child: Divider(
            height: borderHeight,
            thickness: borderHeight,
            color: theme.color.isDark
                ? theme.color.neutralColor2
                : theme.color.neutralColor9,
          ),
        )
      ],
    );

    content = SizedBox(height: 54, child: content);

    return content;
  }
}
