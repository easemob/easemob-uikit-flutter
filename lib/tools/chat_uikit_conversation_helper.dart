import 'package:em_chat_uikit/chat_uikit.dart';
import '../universal/defines.dart';

extension ConversationHelp on Conversation {
  Future<void> addMention() async {
    Map<String, String> conversationExt = ext ?? {};
    conversationExt[hasMentionKey] = hasMentionValue;
    await setExt(conversationExt);
  }

  Future<void> removeMention() async {
    if (ext != null && ext?[hasMentionKey] != null) {
      ext?.remove(hasMentionKey);
      await setExt(ext);
    }
  }
}
