import 'package:em_chat_uikit/chat_uikit.dart';

class PinMessageController with ChatUIKitProviderObserver {
  ChatUIKitProfile? profile;
  List<Message> pinnedMessage = [];

  Future<List<Message>> fetchPinnedMessage() async {
    pinnedMessage = await ChatUIKit.instance.fetchPinnedMessages(
      conversationId: profile!.id,
    );

    return pinnedMessage;
  }

  Future<void> pinMessage(String messageId) async {
    await ChatUIKit.instance.pinMessage(messageId: messageId);
  }

  Future<void> unpinMessage(String messageId) async {
    await ChatUIKit.instance.unpinMessage(messageId: messageId);
  }

  void dispose() {
    pinnedMessage.clear();
  }
}
