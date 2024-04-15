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
    super.key,
  });

  final Message message;
  final void Function(Message message)? onLongPressed;
  final void Function(Message message)? onTap;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final String? attributes;

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
      onTap: widget.onTap ??
          (message) {
            Navigator.of(context).pop();
          },
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
                trailingActions: widget.appBarTrailingActionsBuilder?.call(context, null),
              ),
      body: content,
    );

    return content;
  }

  void longPressed(Message message) {
    // showChatUIKitBottomSheet(
    //     context: context,
    //     items: [
    //       ChatUIKitBottomSheetItem.normal(
    //           label: '保存',
    //           onTap: () async {
    //             save();
    //             Navigator.of(context).pop();
    //           }),
    //       ChatUIKitBottomSheetItem.normal(
    //           label: '转发给朋友',
    //           onTap: () async {
    //             Navigator.of(context).pop();
    //             forward();
    //           })
    //     ],
    //     cancelTitle: '取消');
  }

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
    //     final msg = Message.createImageSendMessage(
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
