import 'package:em_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:em_chat_uikit/chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';

class GroupListViewController
    with ChatUIKitListViewControllerBase, ConnectObserver {
  GroupListViewController() {
    ChatUIKit.instance.addObserver(this);
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onDataSyncFinish(int type, ChatError? error) {
    if (error == null && (type & ChatDataSyncType.joinedGroups) != 0) {
      fetchItemList();
    }
  }

  @override
  Future<void> fetchItemList({bool force = false}) async {
    loadingType.value = ChatUIKitListViewType.loading;
    try {
      List<Group> items = await ChatUIKit.instance.getJoinedGroups();
      hasMore = false;
      List<GroupItemModel> tmp = mapperToGroupItemModelItems(items);
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

  @override
  Future<void> fetchMoreItemList() async {
    hasMore = false;
  }

  void addNewGroup(String groupId) async {
    Group? group = await ChatUIKit.instance.getGroup(groupId: groupId);
    if (group == null) return;
    GroupItemModel info = GroupItemModel.fromProfile(
      ChatUIKitProfile.group(
        id: group.groupId,
        groupName: group.groupName,
      ),
    );
    list.insert(0, info);
    refresh();
  }

  List<GroupItemModel> mapperToGroupItemModelItems(List<Group> groups) {
    List<GroupItemModel> list = [];
    Map<String, ChatUIKitProfile> map =
        ChatUIKitProvider.instance.getProfiles(() {
      List<ChatUIKitProfile> list = [];
      for (var item in groups) {
        list.add(ChatUIKitProfile.group(
          id: item.groupId,
          groupName: item.groupName,
        ));
      }
      return list;
    }());
    for (var item in map.entries) {
      GroupItemModel info = GroupItemModel.fromProfile(item.value);
      list.add(info);
    }
    return list;
  }
}
