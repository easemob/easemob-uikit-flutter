import 'package:em_chat_uikit/chat_uikit.dart';

class ReportMessageViewArguments implements ChatUIKitViewArguments {
  ReportMessageViewArguments({
    required this.messageId,
    required this.reportReasons,
    this.appBar,
    this.enableAppBar = true,
    this.title,
    this.viewObserver,
    this.attributes,
  });
  final String messageId;
  final List<String> reportReasons;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final String? title;
  @override
  String? attributes;

  @override
  ChatUIKitViewObserver? viewObserver;

  ReportMessageViewArguments copyWith({
    String? messageId,
    List<String>? reportReasons,
    bool? enableAppBar,
    ChatUIKitAppBar? appBar,
    String? title,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return ReportMessageViewArguments(
      messageId: messageId ?? this.messageId,
      reportReasons: reportReasons ?? this.reportReasons,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBar: appBar ?? this.appBar,
      title: title ?? this.title,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
