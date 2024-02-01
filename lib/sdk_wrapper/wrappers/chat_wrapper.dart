import 'dart:async';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/sdk_wrapper/sdk_wrapper_tools.dart';
import 'package:flutter/foundation.dart';

mixin ChatWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.chatManager.addEventHandler(
      sdkEventKey,
      ChatEventHandle(
        onMessagesReceived: onMessagesReceived,
        onCmdMessagesReceived: onCmdMessagesReceived,
        onMessagesRead: onMessagesRead,
        onGroupMessageRead: onGroupMessageRead,
        onReadAckForGroupMessageUpdated: onReadAckForGroupMessageUpdated,
        onMessagesDelivered: onMessagesDelivered,
        onMessagesRecalled: onMessagesRecalled,
        onConversationsUpdate: onConversationsUpdate,
        onConversationRead: onConversationRead,
        onMessageReactionDidChange: onMessageReactionDidChange,
        onMessageContentChanged: onMessageContentChanged,
      ),
    );
  }

  @override
  void removeListeners() {
    super.removeListeners();
    Client.getInstance.chatManager.removeEventHandler(sdkEventKey);
  }

  @protected
  void onCmdMessagesReceived(List<Message> messages) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onCmdMessagesReceived(messages);
      }
    }
  }

  @protected
  void onMessagesRead(List<Message> messages) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onMessagesRead(messages);
      }
    }
  }

  @protected
  void onGroupMessageRead(List<GroupMessageAck> groupMessageAcks) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onGroupMessageRead(groupMessageAcks);
      }
    }
  }

  @protected
  void onReadAckForGroupMessageUpdated() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onReadAckForGroupMessageUpdated();
      }
    }
  }

  @protected
  void onMessagesDelivered(List<Message> messages) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onMessagesDelivered(messages);
      }
    }
  }

  @protected
  void onMessagesRecalled(List<Message> messages) {
    List<Message> replaces = [];
    for (var msg in messages) {
      final replace = SDKWrapperTools.insertRecallMessage(recalledMessage: msg);
      replaces.add(replace);
    }
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onMessagesRecalled(messages, replaces);
      }
    }
  }

  void onConversationsUpdate() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onConversationsUpdate();
      }
    }
  }

  @protected
  void onConversationRead(String from, String to) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onConversationRead(from, to);
      }
    }
  }

  @protected
  void onMessageReactionDidChange(List<MessageReactionEvent> events) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onMessageReactionDidChange(events);
      }
    }
  }

  @protected
  void onMessageContentChanged(
      Message message, String operatorId, int operationTime) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onMessageContentChanged(message, operatorId, operationTime);
      }
    }
  }

  @protected
  void onMessagesReceived(List<Message> messages) async {
    List<Conversation>? needMentionConversations;
    for (var msg in messages) {
      if (msg.hasMention) {
        needMentionConversations ??= [];
        Conversation? conversation = await ChatUIKit.instance.getConversation(
          conversationId: msg.conversationId!,
          type: ConversationType.values[msg.chatType.index],
        );
        needMentionConversations.add(conversation!);
      }
    }
    if (needMentionConversations?.isNotEmpty == true) {
      List<Future> futures = [];
      for (var conversation in needMentionConversations!) {
        futures.add(conversation.addMention());
      }
      Future.wait(futures);
    }

    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        observer.onMessagesReceived(messages);
      }
    }
  }
}
