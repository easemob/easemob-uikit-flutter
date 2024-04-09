import 'package:em_chat_uikit/chat_uikit.dart';

class ThreadsViewArguments implements ChatUIKitViewArguments {
  ThreadsViewArguments({
    required this.profile,
    this.enableAppBar = true,
    this.appBar,
    this.attributes,
    this.viewObserver,
    this.appBarTrailingActionsBuilder,
  });

  final ChatUIKitProfile profile;
  @override
  String? attributes;

  @override
  ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;
  final bool enableAppBar;
  final ChatUIKitAppBar? appBar;

  ThreadsViewArguments copyWith({
    ChatUIKitProfile? profile,
    bool? enableAppBar,
    ChatUIKitAppBar? appBar,
    String? attributes,
    ChatUIKitViewObserver? viewObserver,
    ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder,
  }) {
    return ThreadsViewArguments(
      profile: profile ?? this.profile,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBar: appBar ?? this.appBar,
      attributes: attributes ?? this.attributes,
      viewObserver: viewObserver ?? this.viewObserver,
      appBarTrailingActionsBuilder: appBarTrailingActionsBuilder ?? this.appBarTrailingActionsBuilder,
    );
  }
}
