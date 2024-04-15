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
    super.key,
  });

  final Message message;
  final void Function(Message message)? onLongPressed;
  final Widget? playIcon;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final String? attributes;

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
    );

    content = Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                backgroundColor: Colors.black,
                trailingActions: widget.appBarTrailingActionsBuilder?.call(context, null),
              ),
      body: content,
    );

    return content;
  }

/*
  void longPressed(Message message) {
    showChatUIKitBottomSheet(
        context: context,
        items: [
          ChatUIKitBottomSheetItem.normal(
              label: '保存',
              onTap: () async {
                save();
                Navigator.of(context).pop();
              }),
          ChatUIKitBottomSheetItem.normal(
              label: '转发给朋友',
              onTap: () async {
                Navigator.of(context).pop();
                forward();
              })
        ],
        cancelTitle: '取消');
  }
  */

  void save() async {}

  void forward() async {
    // final profile = await Navigator.of(context).pushNamed(
    //   ChatUIKitRouteNames.selectContactsView,
    //   arguments: SelectContactViewArguments(
    //     title: '选择联系人',
    //     backText: '取消',
    //   ),
    // );

    // if (profile != null && profile is ChatUIKitProfile) {
    //   Message? targetMsg =
    //       await ChatUIKit.instance.loadMessage(messageId: widget.message.msgId);
    //   if (targetMsg != null) {
    //     final msg = Message.createVideoSendMessage(
    //       targetId: profile.id,
    //       chatType: (profile.type == ChatUIKitProfileType.contact ||
    //               profile.type == ChatUIKitProfileType.contact)
    //           ? ChatType.Chat
    //           : ChatType.GroupChat,
    //       filePath: targetMsg.localPath!,
    //       width: targetMsg.width,
    //       height: targetMsg.height,
    //       displayName: targetMsg.displayName,
    //       fileSize: targetMsg.fileSize,
    //     );

    //     ChatUIKit.instance.sendMessage(message: msg);
    //   }
    // }
  }
}
