import 'package:em_chat_uikit/chat_uikit.dart';

/// 用来表示当前时间是消息时间还是会话时间
enum ChatUIKitTimeType { conversation, message }

class ChatUIKitTimeFormatter {
  static ChatUIKitTimeFormatter? _instance;
  static ChatUIKitTimeFormatter get instance {
    _instance ??= ChatUIKitTimeFormatter._();
    return _instance!;
  }

  ChatUIKitTimeFormatter._();

  TimeFormatterHandler? formatterHandler;
}
