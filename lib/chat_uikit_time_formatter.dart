import 'package:flutter/material.dart';

/// 用来表示当前时间是消息时间还是会话时间
enum ChatUIKitTimeType { conversation, message }

typedef TimeFormatterHandler = String? Function(
  BuildContext context,
  ChatUIKitTimeType type,
  int time,
);

class ChatUIKitTimeFormatter {
  static ChatUIKitTimeFormatter? _instance;
  static ChatUIKitTimeFormatter get instance {
    _instance ??= ChatUIKitTimeFormatter._();
    return _instance!;
  }

  ChatUIKitTimeFormatter._();

  TimeFormatterHandler? formatterHandler;
}
