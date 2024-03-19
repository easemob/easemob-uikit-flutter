import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ThreadMessagesView extends StatefulWidget {
  ThreadMessagesView.arguments(
    ThreadMessagesViewArguments argument, {
    super.key,
  })  : attributes = argument.attributes,
        viewObserver = argument.viewObserver,
        controller = argument.controller,
        appBar = argument.appBar,
        enableAppBar = argument.enableAppBar,
        title = argument.title,
        subtitle = argument.subtitle,
        model = argument.model;

  const ThreadMessagesView({
    required this.model,
    this.attributes,
    this.viewObserver,
    this.controller,
    this.appBar,
    this.enableAppBar = true,
    this.title,
    this.subtitle,
    super.key,
  });

  final String? attributes;

  final ChatUIKitViewObserver? viewObserver;

  final MessageModel model;

  final String? title;

  final String? subtitle;

  final ChatUIKitAppBar? appBar;

  final bool enableAppBar;

  final ThreadMessagesViewController? controller;

  @override
  State<ThreadMessagesView> createState() => _ThreadMessagesViewState();
}

class _ThreadMessagesViewState extends State<ThreadMessagesView> {
  String? title;
  late ThreadMessagesViewController controller;
  @override
  void initState() {
    super.initState();
    title = widget.title ?? widget.model.threadOverView?.threadName;
    controller = widget.controller ?? ThreadMessagesViewController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        appBar: ChatUIKitAppBar(
          title: title,
          subtitle: widget.subtitle,
          centerTitle: false,
          trailing: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.more_vert,
                color: theme.color.isDark
                    ? theme.color.neutralColor9
                    : theme.color.neutralColor3,
              ),
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: originMsgWidget(theme),
            ),
            msgListWidget(theme),
          ],
        ));
    // body: Column(children: [
    //   originMsgWidget(theme),
    //   msgListWidget(theme),
    // ]),

    return content;
  }

  SliverList msgListWidget(ChatUIKitTheme theme) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (context, index) {
        return Container();
      },
      childCount: 0,
    ));
  }

  Widget originMsgWidget(ChatUIKitTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ChatUIKitAvatar(
            avatarUrl: widget.model.message.fromProfile.avatarUrl,
            size: 28,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.model.message.fromProfile.showName,
                        style: TextStyle(
                          fontWeight: theme.font.titleSmall.fontWeight,
                          fontSize: theme.font.titleSmall.fontSize,
                          color: theme.color.isDark
                              ? theme.color.neutralSpecialColor6
                              : theme.color.neutralSpecialColor5,
                        ),
                      ),
                      Text(
                        ChatUIKitTimeFormatter.instance.formatterHandler?.call(
                                context,
                                ChatUIKitTimeType.message,
                                widget.model.message.serverTime) ??
                            ChatUIKitTimeTool.getChatTimeStr(
                              widget.model.message.serverTime,
                              needTime: true,
                            ),
                        style: TextStyle(
                          fontWeight: theme.font.bodySmall.fontWeight,
                          fontSize: theme.font.bodySmall.fontSize,
                          color: theme.color.isDark
                              ? theme.color.neutralColor6
                              : theme.color.neutralColor5,
                        ),
                      )
                    ],
                  ),
                  Row(children: [subWidget(theme)]),
                  const SizedBox(height: 8),
                  Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: theme.color.isDark
                        ? theme.color.neutralColor2
                        : theme.color.neutralColor98,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget subWidget(ChatUIKitTheme theme) {
    Widget? msgWidget;
    if (widget.model.message.bodyType == MessageType.TXT) {
      msgWidget = Expanded(
          child: ChatUIKitTextMessageWidget(
        model: widget.model,
        style: TextStyle(
          fontWeight: theme.font.bodyMedium.fontWeight,
          fontSize: theme.font.bodyMedium.fontSize,
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor2,
        ),
      ));
    } else if (widget.model.message.bodyType == MessageType.IMAGE) {
      msgWidget = ChatUIKitImageMessageWidget(model: widget.model);
    } else if (widget.model.message.bodyType == MessageType.VOICE) {
      msgWidget =
          ChatUIKitVoiceMessageWidget(model: widget.model, playing: false);
    } else if (widget.model.message.bodyType == MessageType.VIDEO) {
      msgWidget = ChatUIKitVideoMessageWidget(model: widget.model);
    } else if (widget.model.message.bodyType == MessageType.FILE) {
      msgWidget = ChatUIKitFileMessageWidget(model: widget.model);
    } else if (widget.model.message.bodyType == MessageType.COMBINE) {
      msgWidget = ChatUIKitCombineMessageWidget(model: widget.model);
    } else if (widget.model.message.bodyType == MessageType.CUSTOM) {
      if (widget.model.message.isCardMessage) {
        msgWidget = ChatUIKitCardMessageWidget(model: widget.model);
      }
    }
    msgWidget ??= ChatUIKitNonsupportMessageWidget(model: widget.model);
    return msgWidget;
  }
}
