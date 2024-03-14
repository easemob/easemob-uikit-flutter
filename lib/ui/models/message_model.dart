import 'dart:math';

import 'package:em_chat_uikit/chat_uikit.dart';

class MessageModel {
  final String id;
  final Message message;
  final List<MessageReaction>? reactions;
  final Message? quoteMessage;

  MessageModel({
    String? modelId,
    required this.message,
    this.reactions,
    this.quoteMessage,
  }) : id = modelId ?? randomId(message);

  MessageModel copyWith({
    Message? message,
    List<MessageReaction>? reactions,
    Message? quoteMessage,
  }) {
    return MessageModel(
      modelId: id,
      message: message ?? this.message,
      reactions: reactions ?? this.reactions,
      quoteMessage: quoteMessage ?? this.quoteMessage,
    );
  }

  static String randomId(Message message) {
    return Random().nextInt(999999999).toString() +
        message.localTime.toString();
  }
}
