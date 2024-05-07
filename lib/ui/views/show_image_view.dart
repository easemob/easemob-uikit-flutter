import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ShowImageView extends StatefulWidget {
  ShowImageView.arguments(ShowImageViewArguments arguments, {super.key})
      : message = arguments.message,
        onTap = arguments.onTap,
        appBar = arguments.appBar,
        enableAppBar = arguments.enableAppBar,
        onLongPressed = arguments.onLongPressed,
        viewObserver = arguments.viewObserver,
        appBarTrailingActionsBuilder = arguments.appBarTrailingActionsBuilder,
        isCombine = arguments.isCombine,
        attributes = arguments.attributes;

  const ShowImageView({
    required this.message,
    this.onLongPressed,
    this.onTap,
    this.appBar,
    this.enableAppBar = true,
    this.attributes,
    this.viewObserver,
    this.appBarTrailingActionsBuilder,
    this.isCombine = false,
    super.key,
  });

  final Message message;
  final void Function(BuildContext context, Message message)? onLongPressed;
  final void Function(BuildContext context, Message message)? onTap;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final String? attributes;
  final bool isCombine;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;

  @override
  State<ShowImageView> createState() => _ShowImageViewState();
}

class _ShowImageViewState extends State<ShowImageView> {
  @override
  void initState() {
    super.initState();
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ChatUIKitShowImageWidget(
      message: widget.message,
      onLongPressed: widget.onLongPressed,
      onTap: widget.onTap,
      isCombine: widget.isCombine,
    );

    content = Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          content,
        ],
      ),
    );

    content = Scaffold(
      extendBodyBehindAppBar: true,
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                backgroundColor: Colors.black,
                trailingActions:
                    widget.appBarTrailingActionsBuilder?.call(context, null),
              ),
      body: content,
    );

    return content;
  }
}
