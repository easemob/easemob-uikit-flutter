import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitInputBar extends StatefulWidget {
  const ChatUIKitInputBar({
    this.leading,
    this.trailing,
    required this.textEditingController,
    this.hintText,
    this.hintTextStyle,
    this.inputTextStyle,
    this.textCapitalization = TextCapitalization.sentences,
    this.mixHeight = 36,
    this.borderRadius,
    this.onChanged,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final Widget? leading;
  final Widget? trailing;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final TextStyle? inputTextStyle;
  final TextEditingController textEditingController;
  final BorderRadiusGeometry? borderRadius;
  final TextCapitalization textCapitalization;
  final void Function(String input)? onChanged;
  final FocusNode? focusNode;
  final double mixHeight;
  final bool autofocus;

  @override
  State<ChatUIKitInputBar> createState() => _ChatUIKitInputBarState();
}

class _ChatUIKitInputBarState extends State<ChatUIKitInputBar> {
  TextEditingController? _textEditingController;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textEditingController = widget.textEditingController;
    _textEditingController!.addListener(textFieldOnChange);
  }

  void textFieldOnChange() {
    _scrollController!.jumpTo(_scrollController!.position.maxScrollExtent);
  }

  @override
  void didUpdateWidget(covariant ChatUIKitInputBar oldWidget) {
    if (oldWidget.textEditingController != widget.textEditingController) {
      _scrollController?.dispose();
      _scrollController = ScrollController();
      _textEditingController?.dispose();
      _textEditingController = widget.textEditingController;
      _textEditingController!.addListener(textFieldOnChange);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildLeading(),
        Expanded(child: _buildInputField()),
        _buildTrailing(),
      ],
    );

    content = Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      constraints: BoxConstraints(minHeight: widget.mixHeight),
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        border: Border(
            top: BorderSide(
                color: theme.color.isDark
                    ? theme.color.neutralColor2
                    : theme.color.neutralColor9,
                width: 0.5)),
      ),
      child: content,
    );

    return content;
  }

  Widget _buildInputField() {
    final theme = ChatUIKitTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.neutralColor2
            : theme.color.neutralColor95,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
      ),
      child: TextField(
        scrollController: _scrollController,
        keyboardAppearance: ChatUIKitTheme.of(context).color.isDark
            ? Brightness.dark
            : Brightness.light,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        focusNode: widget.focusNode,
        textCapitalization: widget.textCapitalization,
        maxLines: 4,
        minLines: 1,
        style: widget.inputTextStyle ??
            TextStyle(
              color: theme.color.isDark
                  ? theme.color.neutralColor98
                  : theme.color.neutralColor1,
              fontSize: theme.font.bodyLarge.fontSize,
              fontWeight: theme.font.bodyLarge.fontWeight,
            ),
        scrollPadding: EdgeInsets.zero,
        controller: _textEditingController,
        // cursorHeight: 11,
        cursorWidth: 1,
        cursorColor: theme.color.isDark
            ? theme.color.primaryColor6
            : theme.color.primaryColor5,
        cursorRadius: const Radius.circular(1),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: widget.hintText ?? 'Aa',
          hintStyle: widget.hintTextStyle ??
              TextStyle(
                color: theme.color.isDark
                    ? theme.color.neutralColor4
                    : theme.color.neutralColor6,
                fontSize: theme.font.bodyLarge.fontSize,
                fontWeight: theme.font.bodyLarge.fontWeight,
              ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    Widget content = widget.leading ?? const SizedBox(width: 0);
    content = Container(
        margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: SizedBox(
          height: widget.mixHeight - 8,
          child: content,
        ));
    return content;
  }

  Widget _buildTrailing() {
    Widget content = widget.trailing ?? const SizedBox(width: 0);
    content = Container(
        margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: SizedBox(
          height: widget.mixHeight - 8,
          child: content,
        ));
    return content;
  }
}
