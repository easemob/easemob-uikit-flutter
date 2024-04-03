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

  ThreadMembersViewArguments copyWith({
    ChatThread? thread,
    ThreadMembersViewController? controller,
    String? attributes,
    ChatUIKitViewObserver? viewObserver,
  }) {
    return ThreadMembersViewArguments(
      thread: thread ?? this.thread,
      controller: controller ?? this.controller,
      attributes: attributes ?? this.attributes,
      viewObserver: viewObserver ?? this.viewObserver,
    );
  }
}
