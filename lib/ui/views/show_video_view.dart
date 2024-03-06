import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ShowVideoView extends StatefulWidget {
  ShowVideoView.arguments(ShowVideoViewArguments argument, {super.key})
      : message = argument.message,
        onLongPressed = argument.onLongPressed,
        appBar = argument.appBar,
        enableAppBar = argument.enableAppBar,
        playIcon = argument.playIcon,
        viewObserver = argument.viewObserver,
        attributes = argument.attributes;

  const ShowVideoView({
    required this.message,
    this.onLongPressed,
    this.playIcon,
    this.appBar,
    this.enableAppBar = true,
    this.attributes,
    this.viewObserver,
    super.key,
  });

  final Message message;
  final void Function(Message message)? onLongPressed;
  final Widget? playIcon;
  final AppBar? appBar;
  final bool enableAppBar;
  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

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
    final theme = ChatUIKitTheme.of(context);
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
              AppBar(
                backgroundColor: const Color.fromARGB(120, 0, 0, 0),
                elevation: 0.0,
                leading: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: theme.color.neutralColor95,
                    ),
                  ),
                ),
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
