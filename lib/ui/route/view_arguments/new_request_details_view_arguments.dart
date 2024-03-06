import 'package:em_chat_uikit/chat_uikit.dart';

class NewRequestDetailsViewArguments implements ChatUIKitViewArguments {
  NewRequestDetailsViewArguments({
    required this.profile,
    this.isReceivedRequest = false,
    this.btnText,
    this.attributes,
    this.appBar,
    this.title,
    this.viewObserver,
    this.enableAppBar = true,
  });
  final ChatUIKitProfile profile;
  final bool isReceivedRequest;
  final String? btnText;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final String? title;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  NewRequestDetailsViewArguments copyWith({
    ChatUIKitProfile? profile,
    bool? isReceivedRequest,
    String? btnText,
    ChatUIKitAppBar? appBar,
    bool? enableAppBar,
    String? title,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return NewRequestDetailsViewArguments(
      profile: profile ?? this.profile,
      isReceivedRequest: isReceivedRequest ?? this.isReceivedRequest,
      btnText: btnText ?? this.btnText,
      appBar: appBar ?? this.appBar,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      title: title ?? this.title,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
