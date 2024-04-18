import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ShowImageViewArguments implements ChatUIKitViewArguments {
  ShowImageViewArguments({
    required this.message,
    this.onLongPressed,
    this.onTap,
    this.appBar,
    this.enableAppBar = true,
    this.viewObserver,
    this.attributes,
    this.appBarTrailingActionsBuilder,
  });

  final Message message;
  final void Function(BuildContext context, Message message)? onLongPressed;
  final void Function(BuildContext context, Message message)? onTap;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;

  ShowImageViewArguments copyWith(
      {Message? message,
      void Function(BuildContext context, Message message)? onLongPressed,
      void Function(BuildContext context, Message message)? onTap,
      ChatUIKitAppBar? appBar,
      bool? enableAppBar,
      ChatUIKitViewObserver? viewObserver,
      String? attributes,
      ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder}) {
    return ShowImageViewArguments(
      message: message ?? this.message,
      onLongPressed: onLongPressed ?? this.onLongPressed,
      onTap: onTap ?? this.onTap,
      appBar: appBar ?? this.appBar,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
      appBarTrailingActionsBuilder: appBarTrailingActionsBuilder ?? this.appBarTrailingActionsBuilder,
    );
  }
}
