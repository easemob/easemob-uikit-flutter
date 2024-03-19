import 'package:em_chat_uikit/chat_uikit.dart';

class ThreadMessagesViewArguments implements ChatUIKitViewArguments {
  ThreadMessagesViewArguments({
    this.controller,
    this.attributes,
    this.viewObserver,
    this.appBar,
    this.enableAppBar = true,
    this.title,
    this.subtitle,
    required this.model,
  });

  @override
  String? attributes;

  @override
  ChatUIKitViewObserver? viewObserver;

  final String? title;
  final String? subtitle;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final ThreadMessagesViewController? controller;
  final MessageModel model;
}
