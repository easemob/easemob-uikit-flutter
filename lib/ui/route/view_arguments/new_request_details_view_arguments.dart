import 'package:em_chat_uikit/chat_uikit.dart';

class NewRequestDetailsViewArguments implements ChatUIKitViewArguments {
  NewRequestDetailsViewArguments({
    required this.profile,
    this.isReceivedRequest = false,
    this.btnText,
    this.attributes,
    this.appBar,
    this.enableAppBar = true,
  });
  final ChatUIKitProfile profile;
  final bool isReceivedRequest;
  final String? btnText;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;

  @override
  String? attributes;

  NewRequestDetailsViewArguments copyWith({
    ChatUIKitProfile? profile,
    bool? isReceivedRequest,
    String? btnText,
    ChatUIKitAppBar? appBar,
    bool? enableAppBar,
    String? attributes,
  }) {
    return NewRequestDetailsViewArguments(
      profile: profile ?? this.profile,
      isReceivedRequest: isReceivedRequest ?? this.isReceivedRequest,
      btnText: btnText ?? this.btnText,
      appBar: appBar ?? this.appBar,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      attributes: attributes ?? this.attributes,
    );
  }
}
