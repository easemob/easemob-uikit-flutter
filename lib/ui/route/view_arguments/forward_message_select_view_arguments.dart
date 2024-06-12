import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ForwardMessageSelectViewArguments implements ChatUIKitViewArguments {
  final List<Message> messages;
  final bool enableAppBar;
  final PreferredSizeWidget? appBar;
  final String? title;
  final String? Function(BuildContext context, Message message)? summaryBuilder;

  final bool isMulti;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;

  ForwardMessageSelectViewArguments({
    required this.messages,
    this.enableAppBar = true,
    this.appBar,
    this.title,
    this.viewObserver,
    this.summaryBuilder,
    this.isMulti = true,
    this.attributes,
    this.appBarTrailingActionsBuilder,
  });

  ForwardMessageSelectViewArguments copyWith(
      {List<Message>? messages,
      bool? enableAppBar,
      ChatUIKitAppBar? appBar,
      String? title,
      List<Widget>? pages,
      List<String>? pageTitles,
      ChatUIKitViewObserver? viewObserver,
      String? Function(BuildContext context, Message message)? summaryBuilder,
      bool? isMulti,
      String? attributes,
      ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder}) {
    return ForwardMessageSelectViewArguments(
      messages: messages ?? this.messages,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBar: appBar ?? this.appBar,
      title: title ?? this.title,
      summaryBuilder: summaryBuilder ?? this.summaryBuilder,
      viewObserver: viewObserver ?? this.viewObserver,
      isMulti: isMulti ?? this.isMulti,
      attributes: attributes ?? this.attributes,
      appBarTrailingActionsBuilder:
          appBarTrailingActionsBuilder ?? this.appBarTrailingActionsBuilder,
    );
  }
}
