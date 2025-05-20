import 'package:chat_sdk_context/chat_sdk_context.dart';

import '../chat_uikit.dart';

const String convLoadFinishedKey =
    'EaseChatUIKit_conversation_load_more_finished';
const String contactLoadFinishedKey =
    'EaseChatUIKit_contact_load_more_finished';
const String muteMapKey = 'EaseChatUIKit_conversation_mute_map';
const String requestsKey = 'EaseChatUIKit_friend_requests';

extension Request on ChatSDKContext {
  List requestList() {
    return cachedMap[requestsKey] ?? [];
  }

  int newRequestCount() {
    int count = 0;
    cachedMap[requestsKey]?.forEach((element) {
      if (!element['isRead']) {
        count++;
      }
    });
    return count;
  }

  void markAllRequestsAsRead() {
    List requestList = cachedMap[requestsKey] ?? [];
    bool hasUnread = false;
    for (var element in requestList) {
      if (element['isRead'] == false) {
        hasUnread = true;
      }
      element['isRead'] = true;
    }
    cachedMap[requestsKey] = requestList;
    if (hasUnread) {
      ChatUIKit.instance.onFriendRequestCountChanged(newRequestCount());
    }

    save();
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
      'isRead': false,
    });
    cachedMap[requestsKey] = requestList;
    ChatUIKit.instance.onFriendRequestCountChanged(newRequestCount());
    save();
    return true;
  }

  void removeRequest(String userId, [bool isGroup = false]) {
    List requestList = cachedMap[requestsKey] ?? [];
    int index = requestList.indexWhere(
        (element) => element['id'] == userId && element['isGroup'] == isGroup);
    if (index != -1) {
      Map ret = requestList.removeAt(index);
      if (ret.containsKey('isRead') && !ret['isRead']) {
        ChatUIKit.instance.onFriendRequestCountChanged(newRequestCount());
      }
      cachedMap[requestsKey] = requestList;
      save();
    }
  }

  // 删除指定id的请求
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
      save();
      ChatUIKit.instance.onFriendRequestCountChanged(newRequestCount());
    }
  }
}

extension ContactLoad on ChatSDKContext {
  bool isContactLoadFinished() {
    return cachedMap[contactLoadFinishedKey] ??= false;
  }

  void setContactLoadFinished() {
    cachedMap[contactLoadFinishedKey] = true;
    save();
  }
}

extension ConversationFirstLoad on ChatSDKContext {
  bool isConversationLoadFinished() {
    return cachedMap[convLoadFinishedKey] ??= false;
  }

  void setConversationLoadFinished() {
    cachedMap[convLoadFinishedKey] = true;
    save();
  }
}

extension ConversationMute on ChatSDKContext {
  void addConversationMute(Map<String, int> map) {
    dynamic tmpMap = cachedMap[muteMapKey] ?? {};
    tmpMap.addAll(map);
    cachedMap[muteMapKey] = tmpMap;
    save();
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
    save();
  }
}
