import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ShowVideoViewArguments implements ChatUIKitViewArguments {
  ShowVideoViewArguments({
    required this.message,
    this.onLongPressed,
    this.attributes,
    this.playIcon,
    this.appBar,
    this.enableAppBar = true,
    this.viewObserver,
    this.appBarTrailingActionsBuilder,
  });

  final Message message;
  final void Function(Message message)? onLongPressed;
  final Widget? playIcon;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;

  ShowVideoViewArguments copyWith(
      {Message? message,
      void Function(Message message)? onLongPressed,
      Widget? playIcon,
      ChatUIKitAppBar? appBar,
      bool? enableAppBar,
      String? attributes,
      ChatUIKitViewObserver? viewObserver,
      ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder}) {
    return ShowVideoViewArguments(
      message: message ?? this.message,
      onLongPressed: onLongPressed ?? this.onLongPressed,
      playIcon: playIcon ?? this.playIcon,
      appBar: appBar ?? this.appBar,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
      appBarTrailingActionsBuilder: appBarTrailingActionsBuilder ?? this.appBarTrailingActionsBuilder,
    );
  }
}
