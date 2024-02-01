import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/foundation.dart';

typedef ConversationListViewShowHandler = List<ConversationModel> Function(
    List<ConversationModel> conversations);

class ConversationListViewController extends ChatUIKitListViewControllerBase {
  ConversationListViewController({
    this.pageSize = 50,
    this.willShowHandler,
  });
  final int pageSize;
  final ConversationListViewShowHandler? willShowHandler;

  String? cursor;

  @override
  Future<void> fetchItemList({bool force = false}) async {
    loadingType.value = ChatUIKitListViewType.loading;
    List<Conversation> items = await ChatUIKit.instance.getAllConversations();
    try {
      if ((items.isEmpty &&
              !ChatUIKitContext.instance.isConversationLoadFinished()) ||
          force == true) {
        await fetchConversations();
        items = await ChatUIKit.instance.getAllConversations();
      }
      items = await clearEmpty(items);
      List<ConversationModel> tmp = await mappers(items);
      list.clear();
      list.addAll(tmp);
      list = willShowHandler?.call(list.cast<ConversationModel>()) ?? list;
      if (list.isEmpty) {
        loadingType.value = ChatUIKitListViewType.empty;
      } else {
        loadingType.value = ChatUIKitListViewType.normal;
      }
    } catch (e) {
      debugPrintStack();
      loadingType.value = ChatUIKitListViewType.error;
    }
  }

  @override
  Future<void> reload() async {
    loadingType.value = ChatUIKitListViewType.refresh;
    List<Conversation> items = await ChatUIKit.instance.getAllConversations();
    items = await clearEmpty(items);
    List<ConversationModel> tmp = await mappers(items);
    list.clear();
    list.addAll(tmp);
    list = willShowHandler?.call(list.cast<ConversationModel>()) ?? list;
    if (list.isEmpty) {
      loadingType.value = ChatUIKitListViewType.empty;
    } else {
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  // @override
  // Future<List<ChatUIKitListItemModelBase>> fetchMoreItemList() async {
  //   List<ChatUIKitListItemModelBase> list = [];
  //   return list;
  // }

  Future<List<Conversation>> clearEmpty(List<Conversation> list) async {
    List<Conversation> tmp = [];
    for (var item in list) {
      final latest = await item.latestMessage();
      if (latest != null) {
        tmp.add(item);
      }
    }
    return tmp;
  }

  bool hasFetchPinned = false;
  Future<List<Conversation>> fetchConversations() async {
    List<Conversation> items = [];
    if (!hasFetchPinned) {
      CursorResult<Conversation> result =
          await ChatUIKit.instance.fetchPinnedConversations(
        pageSize: 50,
      );
      items.addAll(result.data);
      hasFetchPinned = true;
    }
    try {
      CursorResult<Conversation> result =
          await ChatUIKit.instance.fetchConversations(
        pageSize: pageSize,
        cursor: cursor,
      );
      cursor = result.cursor;
      items.addAll(result.data);
      if (result.data.length < pageSize) {
        ChatUIKitContext.instance.setConversationLoadFinished();
        hasMore = false;
      }
      // ignore: empty_catches
    } catch (e) {}

    await updateMuteType(items);

    if (hasMore) {
      List<Conversation> tmp = await fetchConversations();
      items.addAll(tmp);
    }
    return items;
  }

  Future<void> updateMuteType(List<Conversation> items) async {
    try {
      await ChatUIKit.instance.fetchSilentModel(conversations: items);

      // ignore: empty_catches
    } catch (e) {}
  }

  Future<List<ConversationModel>> mappers(
      List<Conversation> conversations) async {
    List<ChatUIKitProfile> tmp = () {
      List<ChatUIKitProfile> ret = [];
      for (var item in conversations) {
        if (item.type == ConversationType.GroupChat) {
          ret.add(ChatUIKitProfile.group(id: item.id));
        } else if (item.type == ConversationType.Chat) {
          ret.add(ChatUIKitProfile.contact(id: item.id));
        }
      }
      return ret;
    }();

    Map<String, ChatUIKitProfile> profilesMap =
        ChatUIKitProvider.instance.getProfiles(tmp);
    List<ConversationModel> list = [];
    for (var item in conversations) {
      ConversationModel info = await ConversationModel.fromConversation(
        item,
        profilesMap[item.id]!,
      );
      list.add(info);
    }
    return list;
  }
}
