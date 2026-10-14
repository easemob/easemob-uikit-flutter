import 'package:em_chat_uikit/chat_sdk_context/chat_sdk_context.dart';
import 'package:em_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:em_chat_uikit/chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';

/// 联系人列表控制器
class ContactListViewController
    with ChatUIKitListViewControllerBase, ConnectObserver {
  ContactListViewController({
    this.willShowHandler,
    this.enableRefresh = true,
  }) {
    ChatUIKit.instance.addObserver(this);
  }

  /// 是否开启下来刷新
  final bool enableRefresh;

  /// 会话列表显示前的回调，你可以在这里对会话列表进行处理，比如排序或者加减等。如果不设置将会直接显示。
  final ContactListViewShowHandler? willShowHandler;

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onDataSyncFinish(int type, ChatError? error) {
    if (error == null && (type & ChatDataSyncType.contacts) != 0) {
      reload();
    }
  }

  /// 获取 SDK 自动同步到本地的联系人列表。
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

    try {
      List<String> items = await ChatUIKit.instance.getAllContactIds();
      ChatSDKContext.instance.removeRequests(items);
      List<ContactItemModel> tmp = mapperToContactItemModels(items);
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

  List<ContactItemModel> mapperToContactItemModels(List<String> userIds) {
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
    List<ContactItemModel> tmp = mapperToContactItemModels([userId]);
    list.addAll(tmp);
  }

  /// 从新从本地获取联系人列表
  @override
  Future<void> reload() async {
    loadingType.value = ChatUIKitListViewType.refresh;
    List<String> items = await ChatUIKit.instance.getAllContactIds();
    ChatSDKContext.instance.removeRequests(items);
    List<ContactItemModel> tmp = mapperToContactItemModels(items);
    list.clear();
    list.addAll(tmp);

    loadingType.value = ChatUIKitListViewType.normal;
  }
}
