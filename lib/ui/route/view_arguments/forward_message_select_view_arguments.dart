import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ForwardMessageSelectViewArguments implements ChatUIKitViewArguments {
  final List<Message> messages;
  final bool enableAppBar;
  final ChatUIKitAppBar? appBar;
  final String? title;
  final String? Function(BuildContext context, Message message)? summaryBuilder;

  final bool isMulti;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  ForwardMessageSelectViewArguments({
    required this.messages,
    this.enableAppBar = true,
    this.appBar,
    this.title,
    this.viewObserver,
    this.summaryBuilder,
    this.isMulti = true,
    this.attributes,
  });

  ForwardMessageSelectViewArguments copyWith({
    List<Message>? messages,
    bool? enableAppBar,
    ChatUIKitAppBar? appBar,
    String? title,
    List<Widget>? pages,
    List<String>? pageTitles,
    ChatUIKitViewObserver? viewObserver,
    String? Function(BuildContext context, Message message)? summaryBuilder,
    bool? multiMessages,
    String? attributes,
  }) {
    return ForwardMessageSelectViewArguments(
      messages: messages ?? this.messages,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBar: appBar ?? this.appBar,
      title: title ?? this.title,
      summaryBuilder: summaryBuilder ?? this.summaryBuilder,
      viewObserver: viewObserver ?? this.viewObserver,
      isMulti: multiMessages ?? this.isMulti,
      attributes: attributes ?? this.attributes,
    );
  }
}
