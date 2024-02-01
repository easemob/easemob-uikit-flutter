// 单例模式
import 'dart:convert';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/home_page.dart';

class UserDataStore {
  static UserDataStore? _instance;
  SharedPreferences? _sharedPreferences;

  List<String> unNotifyGroupIds = [];

  factory UserDataStore() {
    _instance ??= UserDataStore._();
    return _instance!;
  }

  UserDataStore._();

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    String? currentUser = ChatUIKit.instance.currentUserId;
    if (currentUser?.isNotEmpty == true) {
      String? info = _sharedPreferences?.getString(currentUser!);
      if (info != null) {
        Map<String, dynamic>? map = json.decode(info);
        if (map?.isEmpty == true) return;
        ChatUIKitProvider.instance.currentUserData = UserData(
          nickname: map?[nicknameKey],
          avatarUrl: map?[avatarUrlKey],
        );
      }
    }
  }

  Future<void> saveUserData(UserData userData) async {
    String? currentUser = ChatUIKit.instance.currentUserId;
    if (currentUser?.isNotEmpty == true) {
      _sharedPreferences ??= await SharedPreferences.getInstance();
      _sharedPreferences?.setString(
        currentUser!,
        json.encode({
          nicknameKey: userData.nickname,
          avatarUrlKey: userData.avatarUrl,
        }),
      );
    }
  }
}
