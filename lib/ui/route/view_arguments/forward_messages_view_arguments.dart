import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ForwardMessagesViewArguments implements ChatUIKitViewArguments {
  final Message message;
  final bool enableAppBar;
  final ChatUIKitAppBar? appBar;
  final String? title;
  final String? Function(BuildContext context, Message message)? summaryBuilder;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  ForwardMessagesViewArguments({
    required this.message,
    this.enableAppBar = true,
    this.appBar,
    this.title,
    this.viewObserver,
    this.summaryBuilder,
    this.attributes,
  });

  ForwardMessagesViewArguments copyWith({
    Message? message,
    bool? enableAppBar,
    ChatUIKitAppBar? appBar,
    String? title,
    List<Widget>? pages,
    List<String>? pageTitles,
    ChatUIKitViewObserver? viewObserver,
    String? Function(BuildContext context, Message message)? summaryBuilder,
    String? attributes,
  }) {
    return ForwardMessagesViewArguments(
      message: message ?? this.message,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBar: appBar ?? this.appBar,
      title: title ?? this.title,
      summaryBuilder: summaryBuilder ?? this.summaryBuilder,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}