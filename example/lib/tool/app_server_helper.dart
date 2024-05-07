import 'package:dio/dio.dart';
import 'package:em_chat_uikit_example/welcome_page.dart';
import 'package:flutter/foundation.dart';

class AppServerHelper {
  static String? serverUrl = 'https://a1-appserver.easemob.com';

  static Future<void> sendSmsCodeRequest(String phone) async {
    String url = '$serverUrl/inside/app/sms/send/$phone';
    Response response = await Dio().post(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to send sms code: ${response.statusCode}');
    }
  }

  static Future<LoginUserData> login(String phone, String smsCode) async {
    String url = '$serverUrl/inside/app/user/login/V2';

    Response response = await Dio().post(url, data: {
      'phoneNumber': phone,
      'smsCode': smsCode,
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to login: ${response.statusCode}');
    }
    return LoginUserData.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  static Future<String> uploadAvatar(
      String currentUserId, String avatarPath) async {
    debugPrint('uploadAvatar: $currentUserId, $avatarPath');
    String url = '$serverUrl/inside/app/user/$currentUserId/avatar/upload';
    Map<String, dynamic> entry = {
      'file': await MultipartFile.fromFile(avatarPath)
    };
    Response response = await Dio().post(url, data: FormData.fromMap(entry));
    if (response.statusCode != 200) {
      throw Exception('Failed to uploadAvatar: ${response.statusCode}');
    } else {
      return response.data['avatarUrl'];
    }
  }

  static Future<String> fetchGroupAvatar(String groupId) async {
    String url = '$serverUrl/inside/app/group/$groupId/avatarurl';
    Response response = await Dio().get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetchGroupAvatar: ${response.statusCode}');
    } else {
      return response.data['avatarUrl'];
    }
  }

  static Future<void> autoDestroyGroup(String groupId) async {
    String url = '$serverUrl/inside/app/group/$groupId';
    Response response =
        await Dio().post(url, queryParameters: {'appkey': appKey});
    if (response.statusCode != 200) {
      throw Exception('Failed to auto destroy: ${response.statusCode}');
    }
  }
}

class LoginUserData {
  LoginUserData.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        userId = json['chatUserName'],
        avatarUrl = json['avatarUrl'];

  LoginUserData({
    required this.token,
    required this.userId,
    this.avatarUrl,
  });
  final String token;
  final String userId;
  final String? avatarUrl;
}
