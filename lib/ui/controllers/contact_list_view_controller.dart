import 'package:em_chat_uikit/chat_uikit.dart';
// import 'package:username/username.dart';

/// 联系人列表控制器
class ContactListViewController
    with ChatUIKitListViewControllerBase, ChatUIKitProviderObserver {
  ContactListViewController({
    this.willShowHandler,
    this.enableRefresh = true,
  }) {
    ChatUIKitProvider.instance.addObserver(this);
  }

  final bool enableRefresh;

  /// 会话列表显示前的回调，你可以在这里对会话列表进行处理，比如排序或者加减等。如果不设置将会直接显示。
  final ContactListViewShowHandler? willShowHandler;

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  String? cursor;

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {
    if (list.any((element) =>
        map.keys.contains((element as ContactItemModel).profile.id))) {
      for (var element in map.keys) {
        int index = list
            .indexWhere((e) => (e as ContactItemModel).profile.id == element);
        if (index != -1) {
          list[index] = (list[index] as ContactItemModel)
              .copyWith(profile: map[element]!);
        }
      }
      refresh();
    }
  }

  /// 获取联系人列表，会优先从本地获取，如果本地没有，并且没有从服务器获取过，则从服务器获取。
  /// `force` (bool) 是否强制从服务器获取，默认为 `false`。
  @override
  Future<void> fetchItemList({
    bool force = false,
    bool reload = false,
  }) async {
    if (reload) {
      loadingType.value = ChatUIKitListViewType.refresh;
    } else {
      loadingType.value = ChatUIKitListViewType.loading;
    }

    List<String> items = await ChatUIKit.instance.getAllContactIds();
    try {
      if ((items.isEmpty &&
              !ChatUIKitContext.instance.isContactLoadFinished()) ||
          force == true) {
        items = await _fetchContacts();
      }
      ChatUIKitContext.instance.removeRequests(items);
      List<ContactItemModel> tmp = _mappers(items);
      list.clear();
      list.addAll(tmp);
      if (list.isEmpty) {
        loadingType.value = ChatUIKitListViewType.empty;
      } else {
        loadingType.value = ChatUIKitListViewType.normal;
      }
    } catch (e) {
      if (items.isEmpty) {
        loadingType.value = ChatUIKitListViewType.error;
      } else {
        loadingType.value = ChatUIKitListViewType.normal;
      }
    }
  }

  Future<List<String>> _fetchContacts() async {
    List<String> result = await ChatUIKit.instance.fetchAllContactIds();
    ChatUIKitContext.instance.setContactLoadFinished();
    return result;
  }

  List<ContactItemModel> _mappers(List<String> userIds) {
    List<ContactItemModel> list = [];
    Map<String, ChatUIKitProfile> map =
        ChatUIKitProvider.instance.getProfiles(() {
      List<ChatUIKitProfile> profile = [];
      for (var item in userIds) {
        profile.add(ChatUIKitProfile.contact(id: item));
      }
      return profile;
    }());
    for (var item in userIds) {
      ContactItemModel info = ContactItemModel.fromProfile(map[item]!);
      list.add(info);
    }

    List<ContactItemModel>? contacts = willShowHandler?.call(list);
    if (contacts?.isNotEmpty == true) {
      list.clear();
      list.addAll(contacts!);
    }
    return list;
  }

  void addUser(String userId) {
    if (list
        .cast<ContactItemModel>()
        .any((element) => element.profile.id == userId)) {
      return;
    }
    List<ContactItemModel> tmp = _mappers([userId]);
    list.addAll(tmp);
  }

  /// 从新从本地获取联系人列表
  @override
  Future<void> reload() async {
    loadingType.value = ChatUIKitListViewType.refresh;
    List<String> items = await ChatUIKit.instance.getAllContactIds();
    ChatUIKitContext.instance.removeRequests(items);
    List<ContactItemModel> tmp = _mappers(items);
    list.clear();
    list.addAll(tmp);

    loadingType.value = ChatUIKitListViewType.normal;
  }
}
