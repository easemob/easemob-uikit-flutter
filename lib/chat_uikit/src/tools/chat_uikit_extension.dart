import 'dart:convert';

import 'package:em_chat_uikit/chat_sdk_context/src/context.dart';
import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';



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


const String userGenderKey = 'gender';
const String userIdentifyKey = 'identify';
const String userExtKey = 'ext';

extension ConversationHelp on Conversation {
  Future<void> addMention() async {
    Map<String, String> conversationExt = ext ?? {};
    conversationExt[hasMentionKey] = hasMentionValue;
    await setExt(conversationExt);
  }

  Future<void> removeMention() async {
    if (ext != null && ext?[hasMentionKey] != null) {
      ext?.remove(hasMentionKey);
      await setExt(ext);
    }
  }
}

extension StringLocal on String {
  String localString(BuildContext context) => getString(context);

  bool hasURL() {
    final urlRegex = ChatUIKitSettings.defaultUrlRegExp;
    return urlRegex.hasMatch(this);
  }
}

extension PutWithoutNull on Map<String, dynamic> {
  void putIfNotNull(String key, dynamic value) {
    if (value != null) {
      this[key] = value;
    }
  }
}

extension ChatRoomUserInfo on ChatUIKitProfile {
  static ChatUIKitProfile createUserProfile({
    required String userId,
    String? nickname,
    String? avatarUrl,
    int? gender,
    String? identify,
    Map<String, String>? ext,
  }) {
    final profile = ChatUIKitProfile(
      id: userId,
      type: ChatUIKitProfileType.contact,
      showName: nickname,
      avatarUrl: avatarUrl,
    );
    if (gender != null) {
      profile.extension[userGenderKey] = gender;
    }
    if (identify != null) {
      profile.extension[userIdentifyKey] = identify;
    }
    if (ext != null) {
      profile.extension[userExtKey] = ext;
    }
    return profile;
  }

  static ChatUIKitProfile userInfoFromJson(Map<String, dynamic> json) {
    final profile = ChatUIKitProfile(
      id: json['userId']!,
      type: ChatUIKitProfileType.contact,
      showName: json['nickname'],
      avatarUrl: json['avatarURL'],
    );
    if (json[userGenderKey] != null) {
      profile.extension[userGenderKey] = json[userGenderKey];
    }
    if (json[userIdentifyKey] != null) {
      profile.extension[userIdentifyKey] = json[userIdentifyKey];
    }
    if (json[userExtKey] != null) {
      profile.extension[userExtKey] = json[userExtKey];
    }
    return profile;
  }

  Map<String, Object> toJson() {
    Map<String, Object> map = {};
    map.putIfNotNull('userId', id);
    map.putIfNotNull('nickname', nickname);
    map.putIfNotNull('avatarURL', avatarUrl);
    map.putIfNotNull('gender', extension[userGenderKey]);
    map.putIfNotNull('identify', extension[userIdentifyKey]);
    map.putIfNotNull('ext', extension[userExtKey]);
    return map;
  }

  String? get identify {
    return extension[userIdentifyKey] as String?;
  }

  int? get gender {
    return extension[userGenderKey] as int?;
  }

  Map<String, String>? get ext {
    return extension[userExtKey] as Map<String, String>?;
  }
}

class ChatRoomUIKitKey {
  static String userInfo = 'chatroom_uikit_userInfo';
  static String userJoinEvent = 'CHATROOMUIKITUSERJOIN';
  static String customEvent = 'CHATROOMUIKITCUSTOM';
  static String giftEvent = 'CHATROOMUIKITGIFT';
  static String gift = 'chatroom_uikit_gift';
}

extension ChatRoomMessage on Message {
  bool get isChatRoomJoinNotify {
    bool ret = false;
    if (body.type == MessageType.CUSTOM) {
      String event = (body as CustomMessageBody).event;
      if (ChatRoomUIKitKey.userJoinEvent == event) {
        ret = true;
      }
    }
    return ret;
  }

  bool get isChatRoomGiftNotify {
    return isBroadcast;
  }

  bool get isChatRoomGift {
    bool ret = false;
    if (body.type == MessageType.CUSTOM) {
      String event = (body as CustomMessageBody).event;
      if (ChatRoomUIKitKey.giftEvent == event) {
        ret = true;
      }
    }
    return ret;
  }

  ChatRoomGift? getGift() {
    ChatRoomGift? gift;
    if (body.type == MessageType.CUSTOM) {
      String event = (body as CustomMessageBody).event;
      if (ChatRoomUIKitKey.giftEvent != event) {
        return null;
      }
      Map<String, String>? params = (body as CustomMessageBody).params;
      String? giftJs = params?[ChatRoomUIKitKey.gift];
      if (giftJs != null) {
        gift = ChatRoomGift.fromJson(json.decode(giftJs));
      }
    }
    return gift;
  }

  void addUserInfo([String? belongId]) {
    ChatUIKitProfile? profile =
        ChatUIKitProvider.instance.getProfileById(from, belongId);
    profile ??= ChatUIKitProfile.contact(
      id: ChatRoomUIKit.instance.currentUserId!,
    );
    attributes ??= {};
    attributes![ChatRoomUIKitKey.userInfo] = profile.toJson();
  }

  ChatUIKitProfile? getUserInfo() {
    Map<String, dynamic>? map = attributes?[ChatRoomUIKitKey.userInfo];
    if (map == null) return null;
    return ChatRoomUserInfo.userInfoFromJson(map);
  }

  /// 创建礼物消息
  static Message giftMessage(String roomId, ChatRoomGift gift) {
    Message giftMsg = Message.createCustomSendMessage(
      targetId: roomId,
      event: ChatRoomUIKitKey.giftEvent,
      params: {ChatRoomUIKitKey.gift: json.encode(gift.toJson())},
      chatType: ChatType.ChatRoom,
    );

    giftMsg.addUserInfo(roomId);

    return giftMsg;
  }

  /// 创建聊天室消息
  static Message roomMessage(String roomId, String text) {
    Message msg = Message.createTxtSendMessage(
      targetId: roomId,
      content: text,
      chatType: ChatType.ChatRoom,
    );
    msg.addUserInfo(roomId);
    return msg;
  }

  static Message joinedMessage(String roomId) {
    Message msg = Message.createCustomSendMessage(
      targetId: roomId,
      event: ChatRoomUIKitKey.userJoinEvent,
      chatType: ChatType.ChatRoom,
    );
    msg.addUserInfo(roomId);
    return msg;
  }

  /// 创建自定义聊天室消息
  static Message customMessage(
    String roomId,
    String event, {
    Map<String, String>? params,
    ChatRoomMessagePriority priority = ChatRoomMessagePriority.Normal,
  }) {
    Message msg = Message.createCustomSendMessage(
      targetId: roomId,
      event: event,
      params: params,
      chatType: ChatType.ChatRoom,
    );

    msg.chatroomMessagePriority = priority;
    msg.addUserInfo(roomId);
    return msg;
  }
}
