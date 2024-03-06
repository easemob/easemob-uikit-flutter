import 'package:em_chat_uikit/chat_uikit.dart';

class CurrentUserInfoViewArguments implements ChatUIKitViewArguments {
  CurrentUserInfoViewArguments({
    required this.profile,
    this.attributes,
    this.appBar,
    this.enableAppBar = true,
    this.viewObserver,
  });

  final ChatUIKitProfile profile;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  CurrentUserInfoViewArguments copyWith({
    ChatUIKitProfile? profile,
    bool? enableAppBar,
    ChatUIKitAppBar? appBar,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return CurrentUserInfoViewArguments(
      profile: profile ?? this.profile,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBar: appBar ?? this.appBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
