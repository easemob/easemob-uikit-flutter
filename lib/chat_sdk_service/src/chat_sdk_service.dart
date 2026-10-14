import 'chat_sdk_define.dart';

import 'package:flutter/material.dart';

import 'chat_sdk_service_defines.dart';
import 'observers/action_event_observer.dart';

import 'actions/chat_actions.dart';
import 'actions/group_actions.dart';
import 'actions/room_actions.dart';
import 'actions/notification_actions.dart';
import 'actions/contact_actions.dart';
import 'actions/presence_actions.dart';
import 'actions/thread_actions.dart';
import 'actions/user_info_actions.dart';

import 'wrappers/chat_wrapper.dart';
import 'wrappers/room_wrapper.dart';
import 'wrappers/contact_wrapper.dart';
import 'wrappers/group_wrapper.dart';
import 'wrappers/message_wrapper.dart';
import 'wrappers/multi_wrapper.dart';
import 'wrappers/presence_wrapper.dart';
import 'wrappers/notification_wrapper.dart';
import 'wrappers/thread_wrapper.dart';
import 'wrappers/user_info_wrapper.dart';
import 'wrappers/connect_wrapper.dart';

const String sdkEventKey = 'chat_uikit';

abstract mixin class ChatUIKitObserverBase {}

final List<ChatUIKitObserverBase> observers = [];

abstract class ChatUIKitServiceBase {
  @protected
  @protected
  @mustCallSuper
  void addListeners() {}

  @protected
  @mustCallSuper
  void removeListeners() {}

  ChatUIKitServiceBase() {
    addListeners();
  }

  void addObserver(ChatUIKitObserverBase observer) {
    observers.add(observer);
  }

  void removeObserver(ChatUIKitObserverBase observer) {
    observers.remove(observer);
  }

  @protected
  Future<T> checkResult<T>(
    ChatSDKEvent actionEvent,
    Future<T> Function() method,
  ) async {
    T result;
    ChatError? error;
    try {
      _onEventBegin(actionEvent);
      result = await method.call();
      return result;
    } on ChatError catch (e) {
      error = e;
      rethrow;
    } finally {
      _onEventEnd(actionEvent, error);
    }
  }

  void _onEventBegin(ChatSDKEvent event) {
    for (var observer in observers) {
      if (observer is ChatSDKEventsObserver) {
        observer.onChatSDKEventBegin(event);
      }
    }
  }

  void _onEventEnd(ChatSDKEvent event, ChatError? error) {
    for (var observer in observers) {
      if (observer is ChatSDKEventsObserver) {
        observer.onChatSDKEventEnd(event, error);
      }
    }
  }
}

class ChatSDKService extends ChatUIKitServiceBase
    with
        ChatWrapper,
        GroupWrapper,
        RoomWrapper,
        ContactWrapper,
        MultiWrapper,
        NotificationWrapper,
        ThreadWrapper,
        PresenceWrapper,
        ConnectWrapper,
        UserInfoWrapper,
        ChatActions,
        ContactActions,
        GroupActions,
        RoomActions,
        MessageWrapper,
        NotificationActions,
        ThreadActions,
        PresenceActions,
        UserInfoActions,
        ChatSDKEventsObserver {
  static ChatSDKService? _instance;
  static ChatSDKService get instance {
    return _instance ??= ChatSDKService();
  }

  ChatSDKService() {
    _instance = this;
  }

  Future<void> init({
    required Options options,
  }) async {
    await Client.getInstance.init(options);
    Client.getInstance.startCallback();
  }

  /// Login with token
  ///
  /// Param [userId] : userId
  ///
  /// Param [token] : user token
  Future<void> loginWithToken({
    required String userId,
    required String token,
  }) {
    return checkResult(ChatSDKEvent.loginWithToken, () async {
      await Client.getInstance.loginWithToken(userId, token);
      await Client.getInstance.startCallback();
    });
  }

  /// Logout
  Future<void> logout() {
    return checkResult(ChatSDKEvent.logout, () async {
      await Client.getInstance.logout();
      observers.clear();
      Client.getInstance.removeConnectionEventHandler('chat_sdk_wrapper');
    });
  }

  Future<bool> isConnect() => Client.getInstance.isConnected();

  /// Get current user id
  ///
  /// Return: current user id
  String? get currentUserId {
    return Client.getInstance.currentUserId;
  }

  Future<String> getAccessToken() async {
    return await Client.getInstance.getAccessToken();
  }

  void connectHandler({
    VoidCallback? onConnected,
    void Function(int? errorCode, LoginExtensionInfo? info)? onDisconnected,
    VoidCallback? onTokenWillExpire,
    VoidCallback? onTokenDidExpire,
    void Function(int type)? onDataSyncStart,
    void Function(int type, ChatError? error)? onDataSyncFinish,
  }) {
    Client.getInstance.addConnectionEventHandler(
      'chat_sdk_wrapper',
      ConnectionEventHandler(
        onConnected: onConnected,
        onDisconnected: onDisconnected,
        onTokenWillExpire: onTokenWillExpire,
        onTokenDidExpire: onTokenDidExpire,
        onDataSyncStart: onDataSyncStart,
        onDataSyncFinish: onDataSyncFinish,
      ),
    );
  }
}
