import 'package:em_chat_uikit/chat_uikit.dart';

class ThreadMembersViewArguments implements ChatUIKitViewArguments {
  ThreadMembersViewArguments({
    required this.thread,
    this.enableAppBar = true,
    this.appBar,
    this.controller,
    this.attributes,
    this.viewObserver,
    this.appBarTrailingActionsBuilder,
  });

  final ChatThread thread;
  final ThreadMembersViewController? controller;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;
  final bool enableAppBar;
  final ChatUIKitAppBar? appBar;

  ThreadMembersViewArguments copyWith({
    ChatThread? thread,
    ThreadMembersViewController? controller,
    String? attributes,
    bool? enableAppBar,
    ChatUIKitAppBar? appBar,
    ChatUIKitViewObserver? viewObserver,
    ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder,
  }) {
    return ThreadMembersViewArguments(
      thread: thread ?? this.thread,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBar: appBar ?? this.appBar,
      controller: controller ?? this.controller,
      attributes: attributes ?? this.attributes,
      viewObserver: viewObserver ?? this.viewObserver,
      appBarTrailingActionsBuilder: appBarTrailingActionsBuilder ?? this.appBarTrailingActionsBuilder,
    );
  }
}
