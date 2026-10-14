import 'dart:math';

import 'package:em_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:em_chat_uikit/chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';
import 'package:flutter/material.dart';

/// 会话列表控制器
class ConversationListViewController
    with
        ChatUIKitListViewControllerBase,
        ChatObserver,
        MultiObserver,
        ConnectObserver {
  ConversationListViewController({
    this.willShowHandler,
  }) {
    ChatUIKit.instance.addObserver(this);
  }

  /// 会话列表显示前的回调，你可以在这里对会话列表进行处理，比如排序或者加减等。如果不设置将会直接显示。
  final ConversationListViewShowHandler? willShowHandler;

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onMessagesReceived(List<Message> messages) async {
    reload();
  }

  @override
  void onMessageContentChanged(
      Message message, String operatorId, int operationTime) {
    int index = list.cast<ConversationItemModel>().indexWhere((element) {
      return element.lastMessage?.msgId == message.msgId;
    });

    if (index != -1) {
      list.cast<ConversationItemModel>()[index] =
          list.cast<ConversationItemModel>()[index].copyWith(
                lastMessage: message,
              );
    }

    refresh();
  }

  @override
  void onMessagesRecalledInfo(
      List<RecallMessageInfo> infos, List<Message> replaces) {
    List<String> recalledIds = infos.map((e) => e.recallMessageId).toList();
    bool has = list.cast<ConversationItemModel>().any((element) {
      return recalledIds.contains(element.lastMessage?.msgId ?? "");
    });
    if (has) {
      reload();
    }
  }

  @override
  void onConversationsUpdate() {
    reload();
  }

  @override
  void onDataSyncFinish(int type, ChatError? error) {
    if (error == null && (type & ChatDataSyncType.conversations) != 0) {
      reload();
    }
  }

  Future<void> deleteConversation({required String conversationId}) async {
    int index = list.indexWhere((element) {
      return (element as ConversationItemModel).profile.id == conversationId;
    });
    if (index != -1) {
      list.removeAt(index);
      await refresh();
      await ChatUIKit.instance.deleteLocalConversation(
        conversationId: conversationId,
      );
    }
  }

  Future<void> pinConversation({
    required String conversationId,
    required bool isPinned,
  }) async {
    int index = list.indexWhere((element) {
      return (element as ConversationItemModel).profile.id == conversationId;
    });
    if (index != -1) {
      ConversationItemModel item = list[index] as ConversationItemModel;
      item = item.copyWith(pinned: !item.pinned);
      list[index] = item;
      await refresh();
      await ChatUIKit.instance.pinConversation(
        conversationId: conversationId,
        isPinned: isPinned,
      );
    }
  }

  Future<void> markConversationAsRead(String conversationId) async {
    try {
      final index = list.cast<ConversationItemModel>().indexWhere(
            (element) => element.profile.id == conversationId,
          );
      final profile =
          index == -1 ? null : (list[index] as ConversationItemModel).profile;
      final conversation = await ChatUIKit.instance.getConversation(
        conversationId: conversationId,
        type: profile?.type == ChatUIKitProfileType.group
            ? ConversationType.GroupChat
            : ConversationType.Chat,
      );
      final unreadCount = await conversation?.unreadCount() ?? 0;
      final messages = unreadCount == 0
          ? <Message>[]
          : (await conversation!.loadMessages(loadCount: 50))
              .where((message) =>
                  message.direction == MessageDirection.RECEIVE &&
                  message.isNeedReadReceipt &&
                  !message.isRead)
              .toList();
      await ChatUIKit.instance.clearConversationUnreadMessageCount(
        conversationId: conversationId,
      );
      if (messages.isNotEmpty) {
        await ChatUIKit.instance.sendMessageReadReceipts(messages: messages);
      }
      reload();
    } catch (e) {
      debugPrint('conversation list markConversationAsRead: $e');
    }
  }

  @override
  void onConversationEvent(
      MultiDevicesEvent event, String conversationId, ConversationType type) {
    if (event == MultiDevicesEvent.CONVERSATION_DELETE ||
        event == MultiDevicesEvent.CONVERSATION_PINNED ||
        event == MultiDevicesEvent.CONVERSATION_UNPINNED) {
      fetchItemList();
    }
  }

  /// 获取 SDK 自动同步到本地的会话列表。
  @override
  Future<void> fetchItemList({bool force = false}) async {
    loadingType.value = ChatUIKitListViewType.loading;
    List<Conversation> items = await ChatUIKit.instance.getAllConversations();
    try {
      await updateConversationMuteType(items);
      items = await clearEmptyAndChatRoomConversations(items);
      List<ConversationItemModel> tmp =
          await mapperToConversationModelItems(items);
      list.clear();
      list.addAll(tmp);
      list = willShowHandler?.call(list.cast<ConversationItemModel>()) ?? list;

      if (list.isEmpty) {
        loadingType.value = ChatUIKitListViewType.empty;
      } else {
        loadingType.value = ChatUIKitListViewType.normal;
      }
    } catch (e) {
      debugPrint('conversation list fetchItemList: $e');
      loadingType.value = ChatUIKitListViewType.error;
    }
  }

  /// 从新从本地获取会话列表
  @override
  Future<void> reload() async {
    loadingType.value = ChatUIKitListViewType.refresh;
    List<Conversation> items = await ChatUIKit.instance.getAllConversations();
    items = await clearEmptyAndChatRoomConversations(items);
    List<ConversationItemModel> tmp =
        await mapperToConversationModelItems(items);
    list.clear();
    list.addAll(tmp);
    list = willShowHandler?.call(list.cast<ConversationItemModel>()) ?? list;
    if (list.isEmpty) {
      loadingType.value = ChatUIKitListViewType.empty;
    } else {
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  Future<List<Conversation>> clearEmptyAndChatRoomConversations(
      List<Conversation> list) async {
    List<Conversation> tmp = [];

    // 获取配置值，判断是否允许空会话
    bool enableEmpty =
        ChatUIKit.instance.options?.enableEmptyConversation ?? false;

    for (var item in list) {
      if (item.type == ConversationType.ChatRoom) {
        continue;
      }
      final latest = await item.latestMessage();
      final unreadCount = await item.unreadCount();

      // 如果启用了空会话，或者会话不为空
      if (enableEmpty || latest != null || unreadCount > 0) {
        tmp.add(item);
      }
    }
    return tmp;
  }

  Future<void> updateConversationMuteType(List<Conversation> items) async {
    try {
      List<List<Conversation>> data = [];
      int index = 0;
      while (index < items.length) {
        int intMin = min((index + 20), items.length);
        data.add(items.sublist(index, intMin));
        index = intMin;
      }
      for (var list in data) {
        if (list.isEmpty) continue;
        await ChatUIKit.instance.fetchSilentModel(conversations: list);
      }
    } catch (e) {
      debugPrint('fetchConversations error: $e');
    }
  }

  Future<List<ConversationItemModel>> mapperToConversationModelItems(
      List<Conversation> conversations) async {
    List<ChatUIKitProfile> tmp = () {
      List<ChatUIKitProfile> ret = [];
      for (var item in conversations) {
        if (item.type == ConversationType.GroupChat) {
          ret.add(ChatUIKitProfile.group(id: item.id));
        } else if (item.type == ConversationType.Chat) {
          ret.add(ChatUIKitProfile.contact(id: item.id));
        } else if (item.type == ConversationType.ChatRoom) {
          ret.add(ChatUIKitProfile.chatroom(id: item.id));
        }
      }
      return ret;
    }();

    Map<String, ChatUIKitProfile> profilesMap =
        ChatUIKitProvider.instance.getProfiles(tmp);
    List<ConversationItemModel> list = [];
    for (var item in conversations) {
      ConversationItemModel info = await ConversationItemModel.fromConversation(
        item,
        profilesMap[item.id]!,
      );
      list.add(info);
    }
    return list;
  }
}
