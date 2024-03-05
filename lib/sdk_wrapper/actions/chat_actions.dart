import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/sdk_wrapper/chat_sdk_wrapper.dart';

mixin ChatActions on ChatWrapper {
  Future<Message> sendMessage({required Message message}) async {
    return checkResult(ChatSDKEvent.sendMessage, () async {
      return Client.getInstance.chatManager.sendMessage(message);
    });
  }

  /// 只支持单聊
  Future<void> sendTyping({
    required String userId,
  }) async {
    return checkResult(ChatSDKEvent.sendTypingMessage, () async {
      Message msg = Message.createCmdSendMessage(
        targetId: userId,
        action: 'chat_uikit_message_typing',
        deliverOnlineOnly: true,
      );
      await Client.getInstance.chatManager.sendMessage(msg);
    });
  }

  Future<Message> resendMessage({required Message message}) async {
    return checkResult(ChatSDKEvent.sendMessage, () async {
      return Client.getInstance.chatManager.resendMessage(message);
    });
  }

  Future<bool> sendMessageReadAck({required Message message}) async {
    return checkResult(ChatSDKEvent.sendMessageReadAck, () async {
      return Client.getInstance.chatManager.sendMessageReadAck(message);
    });
  }

  Future<void> sendGroupMessageReadAck({
    required String msgId,
    required String groupId,
    String? content,
  }) async {
    return checkResult(ChatSDKEvent.sendGroupMessageReadAck, () async {
      return Client.getInstance.chatManager.sendGroupMessageReadAck(
        msgId,
        groupId,
        content: content,
      );
    });
  }

  Future<void> sendConversationReadAck({required String conversationId}) async {
    return checkResult(ChatSDKEvent.sendConversationReadAck, () async {
      return await Client.getInstance.chatManager.sendConversationReadAck(
        conversationId,
      );
    });
  }

  Future<void> recallMessage({required Message message}) async {
    return checkResult(ChatSDKEvent.recallMessage, () async {
      await Client.getInstance.chatManager.recallMessage(message.msgId);
      onMessagesRecalled([message]);
    });
  }

  Future<Message?> loadMessage({required String messageId}) async {
    return checkResult(ChatSDKEvent.loadMessage, () async {
      return Client.getInstance.chatManager.loadMessage(messageId);
    });
  }

  Future<Conversation> createConversation({
    required String conversationId,
    ConversationType type = ConversationType.Chat,
  }) {
    return checkResult(ChatSDKEvent.createConversation, () async {
      Conversation? conv = await Client.getInstance.chatManager
          .getConversation(conversationId, type: type, createIfNeed: true);
      return conv!;
    });
  }

  Future<Conversation?> getConversation({
    required String conversationId,
    ConversationType type = ConversationType.Chat,
  }) {
    return checkResult(ChatSDKEvent.getConversation, () async {
      Conversation? conv = await Client.getInstance.chatManager
          .getConversation(conversationId, type: type, createIfNeed: false);
      return conv;
    });
  }

  Future<Conversation?> getThreadConversation({
    required String conversationId,
  }) {
    return checkResult(ChatSDKEvent.getThreadConversation, () async {
      return Client.getInstance.chatManager.getThreadConversation(
        conversationId,
      );
    });
  }

  Future<void> markAllConversationsAsRead() async {
    return checkResult(ChatSDKEvent.markAllConversationsAsRead, () async {
      Future<void> ret =
          Client.getInstance.chatManager.markAllConversationsAsRead();
      super.onConversationsUpdate();
      return ret;
    });
  }

  Future<void> markConversationAsRead({
    required String conversationId,
  }) async {
    return checkResult(ChatSDKEvent.markConversationAsRead, () async {
      Conversation? conv = await Client.getInstance.chatManager.getConversation(
        conversationId,
      );
      Future<void>? ret = conv?.markAllMessagesAsRead();
      super.onConversationsUpdate();
      return ret;
    });
  }

  Future<int> getUnreadMessageCount() async {
    return checkResult(ChatSDKEvent.getUnreadMessageCount, () async {
      return Client.getInstance.chatManager.getUnreadMessageCount();
    });
  }

  Future<int> getAppointUnreadCount({required List<String> appointIds}) async {
    return checkResult(ChatSDKEvent.getAppointUnreadCount, () async {
      int unreadCount = 0;
      List<Conversation>? list =
          await Client.getInstance.chatManager.loadAllConversations();
      for (var conversation in list) {
        if (appointIds.contains(conversation.id)) {
          unreadCount += await conversation.unreadCount();
        }
      }
      return unreadCount;
    });
  }

  Future<int> appointNewMessageConversationCount({
    required List<String> appointIds,
  }) async {
    return checkResult(ChatSDKEvent.haveNewMessageConversationCount, () async {
      int unreadConversationCount = 0;
      List<Conversation>? list =
          await Client.getInstance.chatManager.loadAllConversations();

      for (var conversation in list) {
        if (appointIds.contains(conversation.id)) {
          if (await conversation.unreadCount() > 0) {
            unreadConversationCount += 1;
          }
        }
      }

      return unreadConversationCount;
    });
  }

  Future<void> updateMessage({required Message message}) async {
    return checkResult(ChatSDKEvent.updateMessage, () async {
      return Client.getInstance.chatManager.updateMessage(message);
    });
  }

  Future<void> importMessages({required List<Message> messages}) async {
    return checkResult(ChatSDKEvent.importMessages, () async {
      return Client.getInstance.chatManager.importMessages(messages);
    });
  }

  Future<void> insertMessage({required Message message}) async {
    return checkResult(ChatSDKEvent.importMessages, () async {
      Conversation? conversation =
          await Client.getInstance.chatManager.getConversation(
        message.conversationId ?? message.from!,
        type: ConversationType.values[message.chatType.index],
        createIfNeed: true,
      );
      await conversation!.insertMessage(message);
    });
  }

  Future<void> downloadAttachment({required Message message}) async {
    return checkResult(ChatSDKEvent.downloadAttachment, () async {
      return Client.getInstance.chatManager.downloadAttachment(message);
    });
  }

  Future<void> downloadThumbnail({required Message message}) async {
    return checkResult(ChatSDKEvent.downloadThumbnail, () async {
      return Client.getInstance.chatManager.downloadThumbnail(message);
    });
  }

  Future<List<Conversation>> getAllConversations() async {
    return checkResult(ChatSDKEvent.loadAllConversations, () async {
      return Client.getInstance.chatManager.loadAllConversations();
    });
  }

  Future<CursorResult<Conversation>> fetchConversations({
    String? cursor,
    int pageSize = 20,
  }) async {
    return checkResult(ChatSDKEvent.fetchConversations, () async {
      return Client.getInstance.chatManager.fetchConversation(
        cursor: cursor,
        pageSize: pageSize,
      );
    });
  }

  Future<void> deleteRemoteMessagesWithIds({
    required String conversationId,
    required ConversationType type,
    required List<String> msgIds,
  }) async {
    return checkResult(ChatSDKEvent.deleteRemoteMessagesWithIds, () async {
      return Client.getInstance.chatManager.deleteRemoteMessagesWithIds(
        conversationId: conversationId,
        type: type,
        msgIds: msgIds,
      );
    });
  }

  Future<void> deleteRemoteMessagesBefore({
    required String conversationId,
    required ConversationType type,
    required int timestamp,
  }) async {
    return checkResult(ChatSDKEvent.deleteRemoteMessagesBefore, () async {
      return Client.getInstance.chatManager.deleteRemoteMessagesBefore(
        conversationId: conversationId,
        type: type,
        timestamp: timestamp,
      );
    });
  }

  Future<void> deleteLocalConversation({
    required String conversationId,
    bool deleteMessages = true,
  }) async {
    return checkResult(ChatSDKEvent.deleteLocalConversation, () async {
      await Client.getInstance.chatManager.deleteConversation(
        conversationId,
        deleteMessages: deleteMessages,
      );
    });
  }

  Future<CursorResult<Message>> fetchHistoryMessages({
    required String conversationId,
    required ConversationType type,
    FetchMessageOptions? options,
    String? cursor,
    int pageSize = 50,
  }) async {
    return checkResult(ChatSDKEvent.fetchHistoryMessages, () async {
      return Client.getInstance.chatManager.fetchHistoryMessagesByOption(
        conversationId,
        type,
        options: options,
        cursor: cursor,
        pageSize: pageSize,
      );
    });
  }

  Future<List<Message>> searchLocalMessage({
    required String keywords,
    int timestamp = -1,
    int maxCount = 20,
    String? from,
    SearchDirection direction = SearchDirection.Up,
  }) async {
    return checkResult(ChatSDKEvent.searchLocalMessage, () async {
      return Client.getInstance.chatManager.searchMsgFromDB(
        keywords,
        timestamp: timestamp,
        maxCount: maxCount,
        from: from ?? '',
        direction: direction,
      );
    });
  }

  Future<CursorResult<GroupMessageAck>> fetchGroupAckList({
    required String msgId,
    required String groupId,
    String? startAckId,
    int pageSize = 20,
  }) async {
    return checkResult(ChatSDKEvent.fetchGroupAckList, () async {
      return Client.getInstance.chatManager.fetchGroupAcks(
        msgId,
        groupId,
        startAckId: startAckId,
        pageSize: pageSize,
      );
    });
  }

  Future<void> deleteRemoteConversation({
    required String conversationId,
    required ConversationType type,
    bool isDeleteMessage = true,
  }) async {
    return checkResult(ChatSDKEvent.deleteRemoteConversation, () async {
      return Client.getInstance.chatManager.deleteRemoteConversation(
        conversationId,
        conversationType: type,
        isDeleteMessage: isDeleteMessage,
      );
    });
  }

  Future<void> deleteLocalMessages({required int beforeTime}) async {
    return checkResult(ChatSDKEvent.deleteLocalMessages, () async {
      return Client.getInstance.chatManager.deleteMessagesBefore(
        beforeTime,
      );
    });
  }

  Future<void> reportMessage({
    required String messageId,
    required String tag,
    required String reason,
  }) async {
    return checkResult(ChatSDKEvent.reportMessage, () async {
      return Client.getInstance.chatManager.reportMessage(
        messageId: messageId,
        tag: tag,
        reason: reason,
      );
    });
  }

  Future<void> addReaction({
    required String messageId,
    required String reaction,
  }) async {
    return checkResult(ChatSDKEvent.addReaction, () async {
      return Client.getInstance.chatManager.addReaction(
        messageId: messageId,
        reaction: reaction,
      );
    });
  }

  Future<void> deleteReaction({
    required String messageId,
    required String reaction,
  }) async {
    return checkResult(ChatSDKEvent.deleteReaction, () async {
      return Client.getInstance.chatManager.removeReaction(
        messageId: messageId,
        reaction: reaction,
      );
    });
  }

  Future<Map<String, List<MessageReaction>>> fetchReactionList({
    required List<String> messageIds,
    required ChatType type,
    String? groupId,
  }) async {
    return checkResult(ChatSDKEvent.fetchReactionList, () async {
      return Client.getInstance.chatManager.fetchReactionList(
        messageIds: messageIds,
        chatType: type,
        groupId: groupId,
      );
    });
  }

  Future<CursorResult<MessageReaction>> fetchReactionDetail({
    required String messageId,
    required String reaction,
    String? cursor,
    int pageSize = 20,
  }) async {
    return checkResult(ChatSDKEvent.fetchReactionDetail, () async {
      return Client.getInstance.chatManager.fetchReactionDetail(
        messageId: messageId,
        reaction: reaction,
        cursor: cursor,
        pageSize: pageSize,
      );
    });
  }

  Future<Message> translateMessage({
    required Message msg,
    required List<String> languages,
  }) async {
    return checkResult(ChatSDKEvent.translateMessage, () async {
      return Client.getInstance.chatManager.translateMessage(
        msg: msg,
        languages: languages,
      );
    });
  }

  Future<List<TranslateLanguage>> fetchSupportedLanguages() async {
    return checkResult(ChatSDKEvent.fetchSupportedLanguages, () async {
      return Client.getInstance.chatManager.fetchSupportedLanguages();
    });
  }

  Future<CursorResult<Conversation>> fetchPinnedConversations({
    String? cursor,
    int pageSize = 20,
  }) async {
    return checkResult(ChatSDKEvent.fetchPinnedConversations, () async {
      return Client.getInstance.chatManager.fetchPinnedConversations(
        cursor: cursor,
        pageSize: pageSize,
      );
    });
  }

  Future<void> pinConversation({
    required String conversationId,
    required bool isPinned,
  }) async {
    return checkResult(ChatSDKEvent.pinConversation, () async {
      await Client.getInstance.chatManager.pinConversation(
        conversationId: conversationId,
        isPinned: isPinned,
      );
      super.onConversationsUpdate();
    });
  }

  Future<Message> modifyMessage({
    required String messageId,
    required TextMessageBody msgBody,
  }) async {
    return checkResult(ChatSDKEvent.modifyMessage, () async {
      return Client.getInstance.chatManager.modifyMessage(
        messageId: messageId,
        msgBody: msgBody,
      );
    });
  }

  Future<List<Message>> fetchCombineMessageDetail({
    required Message message,
  }) async {
    return checkResult(ChatSDKEvent.fetchCombineMessageDetail, () async {
      return Client.getInstance.chatManager.fetchCombineMessageDetail(
        message: message,
      );
    });
  }

  Future<List<Message>> getMessages({
    required String conversationId,
    required ConversationType type,
    SearchDirection direction = SearchDirection.Up,
    String? startId,
    int count = 30,
  }) async {
    return checkResult(ChatSDKEvent.getMessages, () async {
      final conversation = await createConversation(
        conversationId: conversationId,
        type: type,
      );
      return conversation.loadMessages(
        startMsgId: startId ?? '',
        loadCount: count,
        direction: direction,
      );
    });
  }

  Future<void> deleteLocalMessageById({
    required String conversationId,
    required ConversationType type,
    required String messageId,
  }) async {
    return checkResult(ChatSDKEvent.deleteLocalMessageById, () async {
      final conversation = await getConversation(
        conversationId: conversationId,
        type: type,
      );
      return await conversation!.deleteMessage(messageId);
    });
  }

  Future<void> deleteLocalMessageByIds({
    required String conversationId,
    required ConversationType type,
    required List<String> messageIds,
  }) async {
    return checkResult(ChatSDKEvent.deleteLocalMessageByIds, () async {
      final conversation = await getConversation(
        conversationId: conversationId,
        type: type,
      );
      return await conversation!.deleteMessageByIds(messageIds);
    });
  }
}
