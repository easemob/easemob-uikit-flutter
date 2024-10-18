import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitInputBar1 extends StatefulWidget {
  const ChatUIKitInputBar1(
      {required this.focusNode, this.leftItems, this.rightItems, super.key});
  final List<Widget>? leftItems;
  final List<Widget>? rightItems;
  final FocusNode focusNode;
  @override
  State<ChatUIKitInputBar1> createState() => _ChatUIKitInputBar1State();
}

class _ChatUIKitInputBar1State extends State<ChatUIKitInputBar1>
    with ChatUIKitThemeMixin {
  @override
  void dispose() {
    widget.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.leftItems != null) ...widget.leftItems!,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: TextField(
                focusNode: widget.focusNode,
                scrollPadding: EdgeInsets.zero,
                cursorWidth: 1,
                cursorHeight: 20,
                keyboardAppearance:
                    theme.color.isDark ? Brightness.dark : Brightness.light,
                maxLines: 4,
                minLines: 1,
                cursorColor: theme.color.isDark
                    ? theme.color.primaryColor6
                    : theme.color.primaryColor5,
                style: TextStyle(
                  color: theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1,
                  fontSize: theme.font.bodyLarge.fontSize,
                  fontWeight: theme.font.bodyLarge.fontWeight,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(
                      CornerRadiusHelper.inputBarRadius(36),
                    ), // 设置圆角大小
                  ),
                  fillColor: theme.color.isDark
                      ? theme.color.neutralColor2
                      : theme.color.neutralColor95,
                  filled: true,
                  isDense: true,
                  hintText: 'Aa',
                  hintStyle: TextStyle(
                    color: theme.color.isDark
                        ? theme.color.neutralColor4
                        : theme.color.neutralColor6,
                    fontSize: theme.font.bodyLarge.fontSize,
                    fontWeight: theme.font.bodyLarge.fontWeight,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal:
                        ChatUIKitSettings.inputBarRadius == CornerRadius.large
                            ? 18
                            : 8,
                  ),
                ),
              ),
            ),
          ),
          if (widget.rightItems != null) ...widget.rightItems!,
        ],
      ),
    );
  }
}
