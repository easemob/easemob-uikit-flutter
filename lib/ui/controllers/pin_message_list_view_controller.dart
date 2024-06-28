import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/foundation.dart';

class PinListItem {
  final Message message;
  final MessagePinInfo pinInfo;
  final VoidCallback? onTap;

  const PinListItem({
    required this.message,
    required this.pinInfo,
    this.onTap,
  });
}

class PinMessageListViewController extends ChangeNotifier
    with ChatObserver, ChatUIKitProviderObserver {
  PinMessageListViewController(this.profile) {
    ChatUIKit.instance.addObserver(this);
    ChatUIKitProvider.instance.addObserver(this);
  }

  final ChatUIKitProfile profile;

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  bool isShow = false;

  ValueNotifier<List<PinListItem>> list = ValueNotifier([]);

  void show() {
    if (list.value.isEmpty) return;
    isShow = true;
    if (hasListeners) notifyListeners();
  }

  void hide() {
    isShow = false;
    notifyListeners();
  }

  Future<void> pinMsg(String msgId) async {
    try {
      await ChatUIKit.instance.pinMessage(messageId: msgId);
    } catch (e) {
      debugPrint('Error pinning message: $e');
    }
  }

  Future<void> unPinMsg(String msgId) async {
    try {
      await ChatUIKit.instance.unpinMessage(messageId: msgId);
    } catch (e) {
      debugPrint('Error unpinning message: $e');
    }
  }

  bool isFetching = false;
  Future<void> fetchPinMessages() async {
    if (isFetching) return;
    isFetching = true;
    try {
      final messages = await ChatUIKit.instance.fetchPinnedMessages(
        conversationId: profile.id,
      );
      List<PinListItem> items = [];
      for (var msg in messages) {
        MessagePinInfo? pinInfo = await msg.pinInfo();
        if (pinInfo == null) continue;
        items.add(PinListItem(message: msg, pinInfo: pinInfo));
      }

      if (items.isNotEmpty) {
        list.value = items;
        show();
      }
    } catch (e) {
      debugPrint('Error fetching pinned messages: $e');
    }
    isFetching = false;
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {}

  @override
  void onMessagePinChanged(
    String messageId,
    String conversationId,
    MessagePinOperation pinOperation,
    MessagePinInfo pinInfo,
  ) {}

  void addItem(PinListItem item) {
    list.value = [item] + list.value.toList();
    if (hasListeners) notifyListeners();
  }

  void removeItem(PinListItem item) {
    if (list.value.toList().isEmpty) return;
    // list.value = list.value.toList()..remove(item);
    list.value = list.value.toList()..removeLast();
    if (hasListeners) notifyListeners();
  }
}
