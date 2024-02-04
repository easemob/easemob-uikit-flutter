import 'package:em_chat_uikit/chat_uikit.dart';
import '../universal/defines.dart';

class SDKWrapperTools {
  static Message insertRecallMessage({
    required Message recalledMessage,
    int? timestamp,
  }) {
    int time = timestamp ?? recalledMessage.serverTime;
    Message alertMsg = Message.createCustomSendMessage(
      targetId: recalledMessage.conversationId!,
      event: alertRecalledKey,
      chatType: recalledMessage.chatType,
      params: {
        if (recalledMessage.bodyType == MessageType.TXT)
          alertRecallInfoKey: recalledMessage.textContent,
        alertRecallMessageTypeKey: recalledMessage.bodyType.index.toString(),
        alertRecallMessageDirectionKey:
            recalledMessage.direction.index.toString(),
        alertRecallMessageFromKey: recalledMessage.from!,
      },
    );
    alertMsg.conversationId = recalledMessage.conversationId;
    alertMsg.serverTime = time;
    alertMsg.localTime = time;
    alertMsg.status = MessageStatus.SUCCESS;

    ChatUIKit.instance.insertMessage(message: alertMsg);
    return alertMsg;
  }

  static void insertGroupDestroyMessage(String groupId) {
    if (ChatUIKit.instance.options?.deleteMessagesAsExitGroup == true) {
      return;
    }
    Message alertMsg = Message.createCustomSendMessage(
      targetId: groupId,
      event: alertGroupDestroyKey,
      chatType: ChatType.GroupChat,
    );
    alertMsg.conversationId = groupId;
    alertMsg.serverTime = DateTime.now().millisecondsSinceEpoch;
    alertMsg.localTime = alertMsg.serverTime;
    alertMsg.status = MessageStatus.SUCCESS;

    ChatUIKit.instance.insertMessage(message: alertMsg);
    // ignore: invalid_use_of_protected_member
    ChatUIKit.instance.onMessagesReceived([alertMsg]);
  }

  static void insertGroupLeaveMessage(String groupId) {
    if (ChatUIKit.instance.options?.deleteMessagesAsExitGroup == true) {
      return;
    }
    Message alertMsg = Message.createCustomSendMessage(
      targetId: groupId,
      event: alertGroupLeaveKey,
      chatType: ChatType.GroupChat,
    );
    alertMsg.conversationId = groupId;
    alertMsg.serverTime = DateTime.now().millisecondsSinceEpoch;
    alertMsg.localTime = alertMsg.serverTime;
    alertMsg.status = MessageStatus.SUCCESS;

    ChatUIKit.instance.insertMessage(message: alertMsg);
    // ignore: invalid_use_of_protected_member
    ChatUIKit.instance.onMessagesReceived([alertMsg]);
  }

  static void insertGroupKickedMessage(String groupId) {
    if (ChatUIKit.instance.options?.deleteMessagesAsExitGroup == true) {
      return;
    }
    Message alertMsg = Message.createCustomSendMessage(
      targetId: groupId,
      event: alertGroupKickedKey,
      chatType: ChatType.GroupChat,
    );
    alertMsg.conversationId = groupId;
    alertMsg.serverTime = DateTime.now().millisecondsSinceEpoch;
    alertMsg.localTime = alertMsg.serverTime;
    alertMsg.status = MessageStatus.SUCCESS;

    ChatUIKit.instance.insertMessage(message: alertMsg);
    // ignore: invalid_use_of_protected_member
    ChatUIKit.instance.onMessagesReceived([alertMsg]);
  }

  static insertCreateGroupMessage({
    required Group group,
    ChatUIKitProfile? creator,
    int? timestamp,
  }) async {
    int time = timestamp ?? DateTime.now().millisecondsSinceEpoch - 1;
    Message timeMsg = Message.createCustomSendMessage(
      targetId: group.groupId,
      event: alertTimeMessageEventKey,
      chatType: ChatType.GroupChat,
    );
    timeMsg.serverTime = time;
    timeMsg.localTime = time;
    timeMsg.status = MessageStatus.SUCCESS;

    await ChatUIKit.instance.insertMessage(
      message: timeMsg,
    );
    Message alertMsg = Message.createCustomSendMessage(
      targetId: group.groupId,
      event: alertCreateGroupMessageEventKey,
      chatType: ChatType.GroupChat,
      params: {
        alertCreateGroupMessageOwnerKey: creator?.showName ?? group.owner ?? '',
        alertCreateGroupMessageGroupNameKey: group.groupId,
      },
    );
    alertMsg.conversationId = group.groupId;
    alertMsg.serverTime = time + 1;
    alertMsg.localTime = time + 1;
    alertMsg.status = MessageStatus.SUCCESS;

    await ChatUIKit.instance.insertMessage(message: alertMsg);
  }
}
