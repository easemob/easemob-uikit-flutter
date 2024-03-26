import 'package:em_chat_uikit/chat_uikit.dart';

class ThreadMembersViewArguments implements ChatUIKitViewArguments {
  ThreadMembersViewArguments({
    required this.thread,
    this.controller,
    this.attributes,
    this.viewObserver,
  });

  final ChatThread thread;
  final ThreadMembersViewController? controller;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;
}
