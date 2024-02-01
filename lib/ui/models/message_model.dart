import 'package:em_chat_uikit/chat_uikit.dart';

class MessageModel {
  final String id;
  final Message message;

  MessageModel({
    required this.id,
    required this.message,
  });

  MessageModel coyWith({
    required Message message,
  }) {
    return MessageModel(
      id: id,
      message: message,
    );
  }
}
