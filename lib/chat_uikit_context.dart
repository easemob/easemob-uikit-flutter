import 'dart:convert';

import 'package:em_chat_uikit/universal/inner_headers.dart';

const String convLoadFinishedKey =
    'EaseChatUIKit_conversation_load_more_finished';
const String contactLoadFinishedKey =
    'EaseChatUIKit_contact_load_more_finished';
const String muteMapKey = 'EaseChatUIKit_conversation_mute_map';
const String requestsKey = 'EaseChatUIKit_friend_requests';

class ChatUIKitContext {
  late SharedPreferences sharedPreferences;
  String? _currentUserId;

  Map<String, dynamic> cachedMap = {};
  // 缓存，不存db；
  bool _hasFetchedContacts = false;

  static ChatUIKitContext? _instance;
  static ChatUIKitContext get instance {
    _instance ??= ChatUIKitContext._internal();
    return _instance!;
  }

  set currentUserId(String? userId) {
    if (_currentUserId != userId) {
      cachedMap.clear();
    }
    _currentUserId = userId;
    if (_currentUserId?.isNotEmpty == true) {
      String? cache = sharedPreferences.getString(_currentUserId!);
      if (cache != null) {
        cachedMap = json.decode(cache);
      }
    }
  }

  ChatUIKitContext._internal() {
    init();
  }

  void init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void _updateStore() {
    sharedPreferences.setString(_currentUserId!, json.encode(cachedMap));
  }
}

extension Request on ChatUIKitContext {
  List requestList() {
    return cachedMap[requestsKey] ?? [];
  }

  bool addRequest(String userId, String? reason, [bool isGroup = false]) {
    List requestList = cachedMap[requestsKey] ?? [];
    if (requestList.any((element) =>
        element['id'] == userId && element['isGroup'] == isGroup)) {
      return false;
    }
    requestList.add({
      'id': userId,
      'reason': reason,
      'isGroup': isGroup,
    });
    cachedMap[requestsKey] = requestList;
    _updateStore();
    return true;
  }

  void removeRequest(String userId, [bool isGroup = false]) {
    List requestList = cachedMap[requestsKey] ?? [];
    int index = requestList.indexWhere(
        (element) => element['id'] == userId && element['isGroup'] == isGroup);
    if (index != -1) {
      requestList.removeAt(index);
      cachedMap[requestsKey] = requestList;
      _updateStore();
    }
  }

  void removeRequests(List<String> userIds, [isGroup = false]) {
    List requestList = cachedMap[requestsKey] ?? [];
    bool needUpdate = false;
    for (var userId in userIds) {
      int index = requestList.indexWhere((element) =>
          element['id'] == userId && element['isGroup'] == isGroup);
      if (index != -1) {
        needUpdate = true;
        requestList.removeAt(index);
      }
    }
    if (needUpdate) {
      cachedMap[requestsKey] = requestList;
      _updateStore();
    }
  }
}

extension ContactLoad on ChatUIKitContext {
  bool isContactLoadFinished() {
    return _hasFetchedContacts;
  }

  void setContactLoadFinished() {
    _hasFetchedContacts = true;
  }
}

extension ConversationFirstLoad on ChatUIKitContext {
  bool isConversationLoadFinished() {
    return cachedMap[convLoadFinishedKey] ??= false;
  }

  void setConversationLoadFinished() {
    cachedMap[convLoadFinishedKey] = true;
    _updateStore();
  }
}

extension ConversationMute on ChatUIKitContext {
  void addConversationMute(Map<String, int> map) {
    dynamic tmpMap = cachedMap[muteMapKey] ?? {};
    tmpMap.addAll(map);
    cachedMap[muteMapKey] = tmpMap;
    _updateStore();
  }

  bool conversationIsMute(String conversationId) {
    dynamic tmpMap = cachedMap[muteMapKey] ?? {};
    return tmpMap?.containsKey(conversationId) ?? false;
  }

  void deleteConversationMute(List<String> list) {
    dynamic tmpMap = cachedMap[muteMapKey] ?? {};
    for (var element in list) {
      tmpMap.remove(element);
    }
    cachedMap[muteMapKey] = tmpMap;
    _updateStore();
  }
}
