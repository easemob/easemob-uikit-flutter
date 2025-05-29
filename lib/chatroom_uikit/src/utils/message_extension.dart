import 'dart:convert';

import 'package:em_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:em_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';
import 'package:em_chat_uikit/chatroom_uikit/chatroom_uikit.dart';

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
    );

    msg.chatroomMessagePriority = priority;
    msg.addUserInfo(roomId);
    return msg;
  }
}
