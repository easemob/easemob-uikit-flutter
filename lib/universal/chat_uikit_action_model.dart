import 'package:flutter/widgets.dart';

typedef ChatUIKitActionItemOnTap = void Function(BuildContext context);

class ChatUIKitActionModel {
  ChatUIKitActionModel({
    required this.title,
    required this.icon,
    this.packageName,
    this.onTap,
  });

  final String title;
  final ChatUIKitActionItemOnTap? onTap;
  final String icon;
  final String? packageName;
}
