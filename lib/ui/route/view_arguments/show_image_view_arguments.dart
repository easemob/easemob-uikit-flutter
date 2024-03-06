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
  });

  final Message message;
  final void Function(Message message)? onLongPressed;
  final void Function(Message message)? onTap;
  final AppBar? appBar;
  final bool enableAppBar;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  ShowImageViewArguments copyWith({
    Message? message,
    void Function(Message message)? onLongPressed,
    void Function(Message message)? onTap,
    AppBar? appBar,
    bool? enableAppBar,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return ShowImageViewArguments(
      message: message ?? this.message,
      onLongPressed: onLongPressed ?? this.onLongPressed,
      onTap: onTap ?? this.onTap,
      appBar: appBar ?? this.appBar,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
