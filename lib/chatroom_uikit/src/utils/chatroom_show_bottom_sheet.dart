import 'package:em_chat_uikit/chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

Future<ChatRoomGift?> chatroomShowGiftsView(
  BuildContext context, {
  required List<ChatroomGiftPageController> giftControllers,
}) {
  return showModalBottomSheet<ChatRoomGift?>(
    context: context,
    clipBehavior: Clip.hardEdge,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
    ),
    builder: (ctx) {
      return ChatRoomGiftsView(
        giftControllers: giftControllers,
        onSendTap: (gift) {
          Navigator.of(ctx).pop(gift);
        },
      );
    },
  );
}

Future<void> chatroomShowMembersView(
  BuildContext context, {
  required String roomId,
  required List<ChatRoomUIKitMembersInterface> membersControllers,
  String? ownerId,
}) {
  return showModalBottomSheet<ChatRoomGift?>(
    context: context,
    clipBehavior: Clip.hardEdge,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
    ),
    builder: (context) {
      return ChatRoomUIKitMembersView(
        roomId: roomId,
        ownerId: ownerId ?? '',
        controllers: membersControllers,
      );
    },
  );
}
