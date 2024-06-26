import 'package:em_chat_uikit/universal/defines.dart';
import 'package:flutter/widgets.dart';

typedef ChatUIKitActionItemOnTap = void Function(BuildContext context);

class ChatUIKitModelAction {
  ChatUIKitModelAction({
    this.title,
    required this.icon,
    this.iconSize,
    this.packageName,
    this.singleLine = false,
    this.onTap,
  });

  final String? title;
  final ChatUIKitActionItemOnTap? onTap;
  final String icon;
  final Size? iconSize;
  final String? packageName;
  // 表示是唯一的按钮，不允许其他按钮存在
  final bool singleLine;
}

class ChatUIKitAppBarTrailingAction {
  final Widget child;
  final ChatUIKitActionItemOnTap? onTap;
  final ChatUIKitActionType actionType;

  ChatUIKitAppBarTrailingAction({
    required this.child,
    this.actionType = ChatUIKitActionType.custom,
    this.onTap,
  });

  ChatUIKitAppBarTrailingAction copyWith({
    Widget? child,
    ChatUIKitActionItemOnTap? onTap,
    ChatUIKitActionType? actionType,
  }) {
    return ChatUIKitAppBarTrailingAction(
      child: child ?? this.child,
      actionType: actionType ?? this.actionType,
      onTap: onTap,
    );
  }
}
