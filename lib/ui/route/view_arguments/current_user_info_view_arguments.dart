import 'package:em_chat_uikit/chat_uikit.dart';

class CurrentUserInfoViewArguments implements ChatUIKitViewArguments {
  CurrentUserInfoViewArguments({
    required this.profile,
    this.attributes,
    this.appBar,
    this.enableAppBar = true,
  });

  final ChatUIKitProfile profile;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  @override
  String? attributes;

  CurrentUserInfoViewArguments copyWith({
    ChatUIKitProfile? profile,
    bool? enableAppBar,
    ChatUIKitAppBar? appBar,
    String? attributes,
  }) {
    return CurrentUserInfoViewArguments(
      profile: profile ?? this.profile,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBar: appBar ?? this.appBar,
      attributes: attributes ?? this.attributes,
    );
  }
}
