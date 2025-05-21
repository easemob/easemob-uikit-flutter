import 'package:em_chat_uikit/chat_sdk_context/chat_sdk_context.dart';
import 'package:em_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:flutter/material.dart';
import 'actions/chatroom_uikit_room_actions.dart';

class ChatRoomUIKit extends ChatSDKService with ChatRoomUIKitRoomActions {
  static ChatRoomUIKit get instance {
    WidgetsFlutterBinding.ensureInitialized();
    return _instance ??= ChatRoomUIKit();
  }

  static ChatRoomUIKit? _instance;

  Options? _options;
  Options? get options => _options;

  ChatRoomUIKit() : super() {
    ChatSDKContext.instance;
  }

  @override
  Future<void> init({required Options options}) async {
    _options = options;
    await super.init(options: options);
    ChatSDKContext.instance.setUserId(currentUserId);
  }

  /// Login
  ///
  /// Param [userId] : userId
  ///
  /// Param [password] : user password
  @override
  Future<void> loginWithPassword({
    required String userId,
    required String password,
  }) async {
    try {
      await super.loginWithPassword(userId: userId, password: password);
      ChatSDKContext.instance.setUserId(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> loginWithToken({
    required String userId,
    required String token,
  }) async {
    try {
      await super.loginWithToken(userId: userId, token: token);
      ChatSDKContext.instance.setUserId(userId);
    } catch (e) {
      rethrow;
    }
  }

  /// Logout
  @override
  Future<void> logout() async {
    try {
      await super.logout();
      ChatSDKContext.instance.setUserId(null);
    } catch (e) {
      rethrow;
    }
  }
}
