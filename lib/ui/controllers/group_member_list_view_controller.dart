import 'package:em_chat_uikit/chat_uikit.dart';

class GroupMemberListViewController with ChatUIKitListViewControllerBase {
  GroupMemberListViewController({
    required this.groupId,
    this.includeOwner = true,
    this.pageSize = 200,
  });
  final String groupId;
  final int pageSize;
  final bool includeOwner;
  String? cursor;

  @override
  Future<void> fetchItemList({bool force = false}) async {
    try {
      loadingType.value = ChatUIKitListViewType.loading;
      cursor = null;
      List<String> ret = await fetchAllMembers();

      List<String> userIds = ret;
      if (includeOwner) {
        Group? group = await ChatUIKit.instance.getGroup(groupId: groupId);
        if (group?.owner?.isNotEmpty == true) {
          userIds.insert(0, group!.owner!);
        }
      }
      List<ContactItemModel> tmp = mappers(userIds);
      list.clear();
      list.addAll(tmp);

      if (list.isEmpty) {
        loadingType.value = ChatUIKitListViewType.empty;
      } else {
        loadingType.value = ChatUIKitListViewType.normal;
      }
    } catch (e) {
      loadingType.value = ChatUIKitListViewType.error;
    }
  }

  Future<List<String>> fetchAllMembers() async {
    List<String> ret = [];
    do {
      CursorResult<String> items =
          await ChatUIKit.instance.fetchGroupMemberList(
        groupId: groupId,
        pageSize: pageSize,
        cursor: cursor,
      );

      cursor = items.cursor;
      ret.addAll(items.data);
      if (items.data.length < pageSize) {
        hasMore = false;
      }
    } while (hasMore);

    return ret;
  }

  @override
  Future<void> fetchMoreItemList() async {
    if (hasMore) {
      try {
        loadingType.value = ChatUIKitListViewType.refresh;
        CursorResult<String> items =
            await ChatUIKit.instance.fetchGroupMemberList(
          groupId: groupId,
          pageSize: pageSize,
          cursor: cursor,
        );
        cursor = items.cursor;
        if (items.data.length < pageSize) {
          hasMore = false;
        }
        List<ContactItemModel> tmp = mappers(items.data);
        list.addAll(tmp);
        loadingType.value = ChatUIKitListViewType.normal;
        // ignore: empty_catches
      } catch (e) {}
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  List<ContactItemModel> mappers(List<String> contacts) {
    List<ContactItemModel> mapperList = [];
    Map<String, ChatUIKitProfile> map =
        ChatUIKitProvider.instance.getProfiles(() {
      List<ChatUIKitProfile> profile = [];
      for (var item in contacts) {
        profile.add(ChatUIKitProfile.contact(id: item));
      }
      return profile;
    }());
    for (var item in contacts) {
      ContactItemModel info = ContactItemModel.fromProfile(map[item]!);
      mapperList.add(info);
    }
    return mapperList;
  }
}
