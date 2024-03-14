import 'dart:io';
import 'dart:math';

import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

import '../../universal/defines.dart';

enum MessageLastActionType {
  send,
  receive,
  load,
  none,
}

/// 消息列表控制器
class MessageListViewController extends ChangeNotifier
    with ChatObserver, MessageObserver {
  /// 用户信息对象，用于设置对方信息, 详细参考 [ChatUIKitProfile]。如果你自己设置了 `MessageListViewController` 需要确保 `profile` 与 [MessagesView] 传入的 `profile` 一致。
  ChatUIKitProfile profile;

  /// 一次获取的消息数量，默认为 30
  final int pageSize;

  final Message? Function(Message)? willSendHandler;

  /// 消息列表
  final List<MessageModel> msgModelList = [];

  /// 用户信息缓存，用于显示头像昵称, 不建议修改， 详细参考 [UserData]
  final Map<String, UserData> userMap = {};

  /// 会话类型, 不可修改，会根据 `profile` 自动设置。 详细参考 [ConversationType]
  late final ConversationType conversationType;

  /// 不可修改
  MessageLastActionType lastActionType = MessageLastActionType.none;

  /// 不可修改
  bool _isEmpty = false;

  /// 不可修改
  String? _lastMessageId;

  /// 不可修改
  bool hasNew = false;

  /// 不可修改
  bool _isFetching = false;

  /// 不可修改
  bool isDisposed = false;

  /// 不可修改
  bool _typing = false;

  List<Message> selectedMessages = [];

  bool isMultiSelectMode = false;

  void clearMessages() {
    msgModelList.clear();
    lastActionType = MessageLastActionType.none;
    hasNew = false;
    _lastMessageId = null;
  }

  MessageListViewController({
    required this.profile,
    this.pageSize = 30,
    this.willSendHandler,
  }) {
    ChatUIKit.instance.addObserver(this);
    conversationType = () {
      if (profile.type == ChatUIKitProfileType.group) {
        return ConversationType.GroupChat;
      } else {
        return ConversationType.Chat;
      }
    }();
    if (ChatUIKit.instance.currentUserId != null) {
      userMap[ChatUIKit.instance.currentUserId!] = UserData(
        nickname: ChatUIKitProvider.instance.currentUserProfile?.showName,
        avatarUrl: ChatUIKitProvider.instance.currentUserProfile?.avatarUrl,
        time: DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  void fetchItemList() async {
    if (_isEmpty) {
      return;
    }
    if (_isFetching) return;
    _isFetching = true;
    List<Message> list = await ChatUIKit.instance.getMessages(
      conversationId: profile.id,
      type: conversationType,
      count: pageSize,
      startId: _lastMessageId,
    );
    if (list.length < pageSize) {
      _isEmpty = true;
    }
    if (list.isNotEmpty) {
      List<MessageModel> modelLists = [];
      _lastMessageId = list.first.msgId;

      for (var msg in list) {
        List<MessageReaction> reactions = await msg.reactionList();
        modelLists.add(
          MessageModel(
            message: msg,
            reactions: reactions,
          ),
        );
        UserData? userData = userMap[msg.from!];
        if ((userData?.time ?? 0) < msg.serverTime) {
          userData = UserData(
            nickname: msg.nickname,
            avatarUrl: msg.avatarUrl,
            time: msg.serverTime,
          );
          userMap[msg.from!] = userData;
        }
      }
      msgModelList.addAll(modelLists.reversed);

      lastActionType = MessageLastActionType.load;

      updateView();
    }
    _isFetching = false;
  }

  @override
  void onMessageContentChanged(
    Message message,
    String operatorId,
    int operationTime,
  ) {
    final index = msgModelList
        .indexWhere((element) => element.message.msgId == message.msgId);
    if (index != -1) {
      msgModelList[index] = msgModelList[index].copyWith(message: message);

      updateView();
    }
  }

  @override
  void onMessagesReceived(List<Message> messages) {
    List<MessageModel> list = [];
    for (var element in messages) {
      if (element.conversationId == profile.id) {
        list.add(MessageModel(message: element));
        userMap[element.from!] = UserData(
          nickname: element.nickname,
          avatarUrl: element.avatarUrl,
        );
      }
    }
    if (list.isNotEmpty) {
      _clearMention(list);
      msgModelList.insertAll(0, list.reversed);
      hasNew = true;
      lastActionType = MessageLastActionType.receive;

      updateView();
    }
  }

  @override
  void onConversationRead(String from, String to) {
    if (from == profile.id) {
      for (var element in msgModelList) {
        element.message.hasReadAck = true;
      }

      updateView();
    }
  }

  @override
  void onMessagesDelivered(List<Message> messages) {
    List<MessageModel> list = msgModelList
        .where((element1) => messages
            .where((element2) => element1.message.msgId == element2.msgId)
            .isNotEmpty)
        .toList();
    if (list.isNotEmpty) {
      for (var element in list) {
        element.message.hasDeliverAck = true;
      }

      updateView();
    }
  }

  @override
  void onMessagesRead(List<Message> messages) {
    List<MessageModel> list = msgModelList
        .where((element1) => messages
            .where((element2) => element1.message.msgId == element2.msgId)
            .isNotEmpty)
        .toList();
    if (list.isNotEmpty) {
      for (var element in list) {
        element.message.hasReadAck = true;
      }
      updateView();
    }
  }

  @override
  void onMessagesRecalled(List<Message> recalled, List<Message> replaces) {
    bool needReload = false;
    for (var i = 0; i < recalled.length; i++) {
      int index = msgModelList
          .indexWhere((element) => recalled[i].msgId == element.message.msgId);
      if (index != -1) {
        msgModelList[index] =
            msgModelList[index].copyWith(message: replaces[i]);
        needReload = true;
      }
    }
    if (needReload) {
      updateView();
    }
  }

  @override
  void onMessageReactionDidChange(List<MessageReactionEvent> events) async {
    bool needUpdate = false;
    for (var reactionEvent in events) {
      if (reactionEvent.conversationId == profile.id) {
        final index = msgModelList.indexWhere(
            (element) => element.message.msgId == reactionEvent.messageId);
        if (index != -1) {
          Message? msg = await ChatUIKit.instance
              .loadMessage(messageId: msgModelList[index].message.msgId);
          if (msg != null) {
            needUpdate = true;
            List<MessageReaction>? reactions = await msg.reactionList();
            msgModelList[index] = msgModelList[index].copyWith(
              message: msg,
              reactions: reactions,
            );
          }
        }
      }
    }
    if (needUpdate) {
      updateView();
    }
  }

  @override
  void onSuccess(String msgId, Message msg) {
    final index = msgModelList.indexWhere((element) =>
        element.message.msgId == msgId && msg.status != element.message.status);
    if (index != -1) {
      msgModelList[index] = msgModelList[index].copyWith(message: msg);
      updateView();
    }
  }

  @override
  void onError(String msgId, Message msg, ChatError error) {
    final index = msgModelList.indexWhere((element) =>
        element.message.msgId == msgId && msg.status != element.message.status);
    if (index != -1) {
      msgModelList[index] = msgModelList[index].copyWith(message: msg);
      updateView();
    }
  }

  void replaceMessage(Message message) {
    final index = msgModelList
        .indexWhere((element) => element.message.msgId == message.msgId);
    if (index != -1) {
      msgModelList[index] = msgModelList[index].copyWith(message: message);
      updateView();
    }
  }

  void playMessage(Message message) {
    if (message.bodyType == MessageType.VOICE) {
      if (!message.voiceHasPlay) {
        message.setVoiceHasPlay(true);
        replaceMessage(message);
      }
    }
  }

  Future<void> translateMessage(Message message,
      {bool showTranslate = true}) async {
    Message msg = await ChatUIKit.instance.translateMessage(
      msg: message,
      languages: [ChatUIKitSettings.translateLanguage],
    );
    Map<String, dynamic>? map = msg.attributes;
    map ??= {};
    if (showTranslate) {
      map[hasTranslatedKey] = true;
    } else {
      map.remove(hasTranslatedKey);
    }
    msg.attributes = map;
    await ChatUIKit.instance.updateMessage(message: msg);
    replaceMessage(msg);
  }

  Future<void> _clearMention(List<MessageModel> msgs) async {
    if (profile.type == ChatUIKitProfileType.group) {
      return;
    }
    if (msgs.any((element) => element.message.hasMention)) {
      clearMentionIfNeed();
    }
  }

  void updateView() {
    if (isDisposed) return;
    debugPrint('updateView');
    notifyListeners();
  }

  ChatType get chatType {
    if (profile.type == ChatUIKitProfileType.group) {
      return ChatType.GroupChat;
    } else {
      return ChatType.Chat;
    }
  }

  Future<void> sendTextMessage(
    String text, {
    Message? replay,
    dynamic mention,
  }) async {
    Message message = Message.createTxtSendMessage(
      targetId: profile.id,
      chatType: chatType,
      content: text,
    );

    if (mention != null) {
      Map<String, dynamic> mentionExt = {};
      if (mention is bool && mention == true) {
        mentionExt[mentionKey] = mentionAllValue;
      } else if (mention is List<String>) {
        List<String> mentionList = [];
        for (var userId in mention) {
          {
            mentionList.add(userId);
          }
        }
        if (mentionList.isNotEmpty) {
          mentionExt[mentionKey] = mentionList;
        }
      }
      if (mentionExt.isNotEmpty) {
        message.attributes = mentionExt;
      }
    }

    if (replay != null) {
      message.addQuote(replay);
    }

    sendMessage(message);
  }

  Future<void> editMessage(Message message, String content) async {
    TextMessageBody msgBody = TextMessageBody(content: content);
    try {
      Message msg = await ChatUIKit.instance.modifyMessage(
        messageId: message.msgId,
        msgBody: msgBody,
      );
      final index = msgModelList
          .indexWhere((element) => msg.msgId == element.message.msgId);
      if (index != -1) {
        msgModelList[index] = msgModelList[index].copyWith(message: msg);
        updateView();
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await ChatUIKit.instance.deleteLocalMessageById(
        conversationId: profile.id,
        type: conversationType,
        messageId: messageId,
      );
      msgModelList.removeWhere((element) => messageId == element.message.msgId);
      updateView();
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> recallMessage(Message message) async {
    int index = msgModelList
        .indexWhere((element) => message.msgId == element.message.msgId);
    if (index != -1) {
      try {
        await ChatUIKit.instance.recallMessage(message: message);
        updateView();
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  Future<void> reportMessage({
    required Message message,
    required String tag,
    required String reason,
  }) async {
    try {
      ChatUIKit.instance.reportMessage(
        messageId: message.msgId,
        tag: tag,
        reason: reason,
      );
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> sendVoiceMessage(ChatUIKitRecordModel model) async {
    final message = Message.createVoiceSendMessage(
      targetId: profile.id,
      chatType: chatType,
      filePath: model.path,
      duration: model.duration,
      displayName: model.displayName,
    );
    sendMessage(message);
  }

  Future<void> sendImageMessage(String path, {String? name}) async {
    if (path.isEmpty) {
      return;
    }

    File file = File(path);
    Image.file(file)
        .image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((info, synchronousCall) {
      Message message = Message.createImageSendMessage(
        targetId: profile.id,
        chatType: chatType,
        filePath: path,
        width: info.image.width.toDouble(),
        height: info.image.height.toDouble(),
        fileSize: file.lengthSync(),
        displayName: name,
      );
      sendMessage(message);
    }));
  }

  Future<void> sendVideoMessage(
    String path, {
    String? name,
    double? width,
    double? height,
    int? duration,
  }) async {
    if (path.isEmpty) {
      return;
    }
    final imageData = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200,
      quality: 80,
    );
    if (imageData != null) {
      final directory = await getApplicationCacheDirectory();
      String thumbnailPath =
          '${directory.path}/thumbnail_${Random().nextInt(999999999)}.jpeg';
      final file = File(thumbnailPath);
      file.writeAsBytesSync(imageData);

      final videoFile = File(path);

      Image.file(file)
          .image
          .resolve(const ImageConfiguration())
          .addListener(ImageStreamListener((info, synchronousCall) {
        final msg = Message.createVideoSendMessage(
          targetId: profile.id,
          chatType: chatType,
          filePath: path,
          thumbnailLocalPath: file.path,
          width: info.image.width.toDouble(),
          height: info.image.height.toDouble(),
          fileSize: videoFile.lengthSync(),
        );
        sendMessage(msg);
      }));
    }
  }

  Future<void> sendFileMessage(
    String path, {
    String? name,
    int? fileSize,
  }) async {
    final msg = Message.createFileSendMessage(
      targetId: profile.id,
      chatType: chatType,
      filePath: path,
      fileSize: fileSize,
      displayName: name,
    );
    sendMessage(msg);
  }

  Future<void> sendCardMessage(ChatUIKitProfile cardProfile) async {
    Map<String, String> param = {cardUserIdKey: cardProfile.id};
    if (profile.nickname != null) {
      param[cardNicknameKey] = cardProfile.nickname!;
    }
    if (profile.avatarUrl != null) {
      param[cardAvatarKey] = cardProfile.avatarUrl!;
    }

    final message = Message.createCustomSendMessage(
      targetId: profile.id,
      chatType: chatType,
      event: cardMessageKey,
      params: param,
    );
    sendMessage(message);
  }

  Future<void> sendMessage(Message message) async {
    Message? willSendMsg = message;
    if (willSendHandler != null) {
      willSendMsg = willSendHandler!(willSendMsg);
      if (willSendMsg == null) {
        return Future(() => null);
      }
    }

    final msg = await ChatUIKit.instance.sendMessage(message: willSendMsg);

    userMap[ChatUIKit.instance.currentUserId!] = UserData(
      nickname: ChatUIKitProvider.instance.currentUserProfile?.showName,
      avatarUrl: ChatUIKitProvider.instance.currentUserProfile?.avatarUrl,
    );
    msgModelList.insert(0, MessageModel(message: msg));
    hasNew = true;
    lastActionType = MessageLastActionType.send;
    updateView();
  }

  Future<void> resendMessage(Message message) async {
    msgModelList
        .removeWhere((element) => element.message.msgId == message.msgId);
    final msg = await ChatUIKit.instance.sendMessage(message: message);
    msgModelList.insert(0, MessageModel(message: msg));
    hasNew = true;
    lastActionType = MessageLastActionType.send;
    updateView();
  }

  void clearMentionIfNeed() {
    if (profile.type == ChatUIKitProfileType.group) {
      ChatUIKit.instance
          .getConversation(
        conversationId: profile.id,
        type: ConversationType.GroupChat,
      )
          .then((conv) {
        if (conv != null) {
          conv.removeMention();
        }
      });
    }
  }

// support single chat.
  Future<void> sendConversationsReadAck() async {
    await markAllMessageAsRead();
    if (conversationType == ConversationType.Chat) {
      try {
        final conv = await ChatUIKit.instance.getConversation(
          conversationId: profile.id,
          type: conversationType,
        );
        int unreadCount = await conv?.unreadCount() ?? 0;
        if (unreadCount > 0) {
          await ChatUIKit.instance
              .sendConversationReadAck(conversationId: profile.id);
          for (var element in msgModelList) {
            element.message.hasReadAck = true;
          }
        }

        // 因为已读状态是对方看的，所以这个时候不需要刷新ui
        // updateView();
        // ignore: empty_catches
      } catch (e) {
        debugPrint('sendConversationsReadAck: $e');
      }
    }
  }

  void sendMessageReadAck(Message message) {
    if (message.chatType == ChatType.Chat &&
        message.direction == MessageDirection.RECEIVE &&
        message.hasReadAck == false) {
      ChatUIKit.instance.sendMessageReadAck(message: message).then((value) {
        message.hasReadAck = true;
      }).catchError((error) {});
    }
  }

  Future<void> markAllMessageAsRead() async {
    await ChatUIKit.instance.markConversationAsRead(conversationId: profile.id);
  }

  Future<void> downloadMessage(Message message) async {
    ChatUIKit.instance.downloadAttachment(message: message);
  }

  String getModelId(Message message) {
    return Random().nextInt(999999999).toString() +
        message.localTime.toString();
  }

  void attemptSendInputType() {
    if (profile.type == ChatUIKitProfileType.contact) {
      if (_typing || ChatUIKitSettings.enableInputStatus == false) {
        return;
      }
      ChatUIKit.instance.sendTyping(userId: profile.id);
      _typing = true;
      Future.delayed(const Duration(seconds: 4), () {
        _typing = false;
      });
    }
  }

  void enableMultiSelectMode() {
    isMultiSelectMode = true;
    selectedMessages.clear();
    notifyListeners();
  }

  void disableMultiSelectMode() {
    isMultiSelectMode = false;
    selectedMessages.clear();
    notifyListeners();
  }

  void deleteSelectedMessages() async {
    await deleteMessages(
      messageIds: selectedMessages.map((e) => e.msgId).toList(),
    );
    disableMultiSelectMode();
  }

  Future<void> deleteMessages({required List<String> messageIds}) async {
    try {
      await ChatUIKit.instance.deleteLocalMessageByIds(
        conversationId: profile.id,
        type: conversationType,
        messageIds: messageIds,
      );
      msgModelList
          .removeWhere((element) => messageIds.contains(element.message.msgId));

      updateView();
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> updateReaction(
    String messageId,
    String reaction,
    bool isAdd,
  ) async {
    try {
      if (isAdd) {
        await ChatUIKit.instance.addReaction(
          messageId: messageId,
          reaction: reaction,
        );
      } else {
        await ChatUIKit.instance.deleteReaction(
          messageId: messageId,
          reaction: reaction,
        );
      }
    } catch (e) {
      debugPrint('updateReaction: $e');
    }
  }
}
