import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/universal/inner_headers.dart';

mixin ChatUIKitChatActions on ChatSDKWrapper {
  @override
  Future<int> getUnreadMessageCount({List<String>? withoutIds}) async {
    int unreadCount = 0;
    List<Conversation> list = await ChatUIKit.instance.getAllConversations();
    if (list.isEmpty) return unreadCount;
    for (var conversation in list) {
      if (conversation.isChatThread) continue;
      if (withoutIds?.isNotEmpty == true) {
        if (withoutIds!.contains(conversation.id)) continue;
      }

      if (!ChatUIKitContext.instance.conversationIsMute(conversation.id)) {
        int count = await conversation.unreadCount();
        chatPrint('conversation.id: ${conversation.id}, count: $count');
        unreadCount += count;
      }
    }
    return unreadCount;
  }
}
