import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ShowVideoView extends StatefulWidget {
  ShowVideoView.arguments(ShowVideoViewArguments arguments, {super.key})
      : message = arguments.message,
        onLongPressed = arguments.onLongPressed,
        appBar = arguments.appBar,
        enableAppBar = arguments.enableAppBar,
        playIcon = arguments.playIcon,
        viewObserver = arguments.viewObserver,
        appBarTrailingActionsBuilder = arguments.appBarTrailingActionsBuilder,
        isCombine = arguments.isCombine,
        attributes = arguments.attributes;

  const ShowVideoView({
    required this.message,
    this.onLongPressed,
    this.playIcon,
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
  final Widget? playIcon;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final String? attributes;
  final bool isCombine;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;

  @override
  State<ShowVideoView> createState() => _ShowVideoViewState();
}

class _ShowVideoViewState extends State<ShowVideoView> {
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
    Widget content = ChatUIKitShowVideoWidget(
      message: widget.message,
      onLongPressed: widget.onLongPressed,
      playIcon: widget.playIcon,
      isCombine: widget.isCombine,
    );

    content = Scaffold(
      backgroundColor: Colors.black,
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
