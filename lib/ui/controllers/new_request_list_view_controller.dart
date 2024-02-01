import 'package:em_chat_uikit/chat_uikit.dart';
// import 'package:username/username.dart';

class NewRequestListViewController with ChatUIKitListViewControllerBase {
  NewRequestListViewController();

  String? cursor;

  @override
  Future<void> fetchItemList({bool force = false}) async {
    loadingType.value = ChatUIKitListViewType.refresh;
    List items = ChatUIKitContext.instance.requestList();
    List<NewRequestItemModel> tmp = mappers(items);
    list.clear();
    list.addAll(tmp);
    if (list.isEmpty) {
      loadingType.value = ChatUIKitListViewType.empty;
    } else {
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  List<NewRequestItemModel> mappers(List requests) {
    List<NewRequestItemModel> list = [];
    for (var item in requests) {
      NewRequestItemModel info =
          NewRequestItemModel.fromUserId(item['id'], item['reason']);
      list.add(info);
    }
    return list;
  }
}
