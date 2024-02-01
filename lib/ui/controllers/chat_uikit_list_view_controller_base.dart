import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

abstract mixin class ChatUIKitListViewControllerBase {
  ValueNotifier<ChatUIKitListViewType> loadingType =
      ValueNotifier(ChatUIKitListViewType.normal);

  bool alphabeticalSorting = false;

  bool hasMore = true;

  Future<void> fetchItemList({bool force = false}) async {
    return;
  }

  Future<void> fetchMoreItemList() async {
    return;
  }

  Future<void> refresh() async {
    loadingType.value = ChatUIKitListViewType.refresh;
    loadingType.value = ChatUIKitListViewType.normal;
  }

  Future<void> reload() async {}

  void dispose() {
    loadingType.dispose();
  }

  List<ChatUIKitListItemModelBase> list = [];
}
