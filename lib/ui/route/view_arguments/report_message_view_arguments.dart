import 'package:em_chat_uikit/chat_uikit.dart';

class ReportMessageViewArguments implements ChatUIKitViewArguments {
  ReportMessageViewArguments({
    required this.messageId,
    required this.reportReasons,
    this.appBar,
    this.enableAppBar = true,
    this.attributes,
  });
  final String messageId;
  final List<String> reportReasons;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;

  @override
  String? attributes;

  ReportMessageViewArguments copyWith({
    String? messageId,
    List<String>? reportReasons,
    bool? enableAppBar,
    ChatUIKitAppBar? appBar,
    String? attributes,
  }) {
    return ReportMessageViewArguments(
      messageId: messageId ?? this.messageId,
      reportReasons: reportReasons ?? this.reportReasons,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBar: appBar ?? this.appBar,
      attributes: attributes ?? this.attributes,
    );
  }
}
