import 'package:em_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';
import 'package:em_chat_uikit/chatroom_uikit/chatroom_uikit.dart';

const String userGenderKey = 'gender';
const String userIdentifyKey = 'identify';
const String userExtKey = 'ext';

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
