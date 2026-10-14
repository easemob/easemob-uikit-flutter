import 'package:em_chat_uikit/chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class _BuildSafeValueNotifier<T> extends ValueNotifier<T> {
  _BuildSafeValueNotifier(super.value);

  bool _notificationScheduled = false;
  bool _disposed = false;

  @override
  void notifyListeners() {
    if (_disposed) return;

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      if (_notificationScheduled) return;
      _notificationScheduled = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_notificationScheduled) return;
        _notificationScheduled = false;
        if (!_disposed) super.notifyListeners();
      });
      return;
    }

    _notificationScheduled = false;
    super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _notificationScheduled = false;
    super.dispose();
  }
}

abstract mixin class ChatUIKitListViewControllerBase {
  ValueNotifier<ChatUIKitListViewType> loadingType =
      _BuildSafeValueNotifier(ChatUIKitListViewType.normal);

  bool hasMore = true;
  bool hasDisposed = false;

  Future<void> fetchItemList({bool force = false}) async {
    return;
  }

  Future<void> fetchMoreItemList() async {
    return;
  }

  Future<void> refresh() async {
    if (hasDisposed) return;
    loadingType.value = ChatUIKitListViewType.refresh;
    if (list.isEmpty) {
      loadingType.value = ChatUIKitListViewType.empty;
    } else {
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  Future<void> reload() async {}

  void dispose() {
    if (hasDisposed) return;
    hasDisposed = true;
    loadingType.dispose();
  }

  List<ChatUIKitListItemModelBase> list = [];
}
