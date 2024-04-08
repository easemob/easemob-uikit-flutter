import 'package:flutter/widgets.dart';

typedef ChatUIKitActionItemOnTap = void Function(BuildContext context);

class ChatUIKitModelAction {
  ChatUIKitModelAction({
    this.title,
    required this.icon,
    this.iconSize,
    this.packageName,
    this.onTap,
  });

  final String? title;
  final ChatUIKitActionItemOnTap? onTap;
  final String icon;
  final Size? iconSize;
  final String? packageName;
}
