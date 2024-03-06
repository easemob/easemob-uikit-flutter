import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ForwardMessageViewArguments implements ChatUIKitViewArguments {
  final List<Message> messages;
  final bool enableAppBar;
  final ChatUIKitAppBar? appBar;
  final String? title;

  @override
  String? attributes;

  ForwardMessageViewArguments({
    required this.messages,
    this.enableAppBar = true,
    this.appBar,
    this.title,
    this.attributes,
  });

  ForwardMessageViewArguments copyWith({
    List<Message>? messages,
    bool? enableAppBar,
    ChatUIKitAppBar? appBar,
    String? title,
    List<Widget>? pages,
    List<String>? pageTitles,
    String? attributes,
  }) {
    return ForwardMessageViewArguments(
      messages: messages ?? this.messages,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBar: appBar ?? this.appBar,
      title: title ?? this.title,
      attributes: attributes ?? this.attributes,
    );
  }
}
