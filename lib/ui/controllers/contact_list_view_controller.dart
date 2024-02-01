import 'package:em_chat_uikit/chat_uikit.dart';
// import 'package:username/username.dart';

class ContactListViewController with ChatUIKitListViewControllerBase {
  ContactListViewController();

  String? cursor;

  @override
  Future<void> fetchItemList({bool force = false}) async {
    loadingType.value = ChatUIKitListViewType.loading;
    List<String> items = await ChatUIKit.instance.getAllContacts();
    try {
      if ((items.isEmpty &&
              !ChatUIKitContext.instance.isContactLoadFinished()) ||
          force == true) {
        items = await _fetchContacts();
      }
      ChatUIKitContext.instance.removeRequests(items);
      List<ContactItemModel> tmp = mappers(items);
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

  List<ContactItemModel> mappers(List<String> contacts) {
    List<ContactItemModel> list = [];
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
      list.add(info);
    }
    return list;
  }

  void addUser(String userId) {
    if (list
        .cast<ContactItemModel>()
        .any((element) => element.profile.id == userId)) {
      return;
    }
    List<ContactItemModel> tmp = mappers([userId]);
    list.addAll(tmp);
  }

  @override
  Future<void> reload() async {
    loadingType.value = ChatUIKitListViewType.refresh;
    List<String> items = await ChatUIKit.instance.getAllContacts();
    ChatUIKitContext.instance.removeRequests(items);
    List<ContactItemModel> tmp = mappers(items);
    list.clear();
    list.addAll(tmp);
    loadingType.value = ChatUIKitListViewType.normal;
  }
}
