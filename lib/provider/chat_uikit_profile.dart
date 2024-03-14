import 'package:flutter/material.dart';

/// Profile 类型，用于区分是联系人还是群组。
enum ChatUIKitProfileType {
  /// 联系人类型。
  contact,

  /// 群类型。
  group,
}

/// ChatUIKitProfile 类，用于存储联系人或群组的信息。
class ChatUIKitProfile {
  /// id ,如果是联系人，则为用户 id，如果是群组，则为群组 id。
  final String id;

  /// 名称,如果是联系人，则为用户名称，如果是群组，则为群组名称。
  final String? nickname;

  /// 头像地址, 如果是联系人，则为用户头像地址，如果是群组，则为群组头像地址。
  final String? avatarUrl;

  /// profile 类型，用于区分是联系人还是群组，详见 [ChatUIKitProfileType]。
  final ChatUIKitProfileType? type;

  /// 扩展字段，用于存储一些额外的信息。
  final Map<String, String>? extension;

  /// 时间戳，uikit 内部不使用。开发者可以使用该字段存储一些时间戳信息。
  final int timestamp;

  /// 用于展示的名称，如果 name 为空，则展示 id
  String get showName => nickname?.isNotEmpty == true ? nickname! : id;

  ChatUIKitProfile({
    required this.id,
    required this.type,
    this.nickname,
    this.avatarUrl,
    this.extension,
    this.timestamp = 0,
  });

  ChatUIKitProfile.contact({
    required String id,
    String? nickname,
    String? avatarUrl,
    ImageProvider? avatarProvider,
    Map<String, String>? extension,
    int timestamp = 0,
  }) : this(
          id: id,
          nickname: nickname,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.contact,
          extension: extension,
          timestamp: timestamp,
        );

  ChatUIKitProfile.group({
    required String id,
    String? groupName,
    String? avatarUrl,
    ImageProvider? avatarProvider,
    Map<String, String>? extension,
    int timestamp = 0,
  }) : this(
          id: id,
          nickname: groupName,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.group,
          extension: extension,
          timestamp: timestamp,
        );

  /// 用于复制一个新的 profile 对象，如果传入的参数不为空，则使用传入的参数，否则使用当前 profile 的参数。
  ChatUIKitProfile copyWith({
    String? nickname,
    String? avatarUrl,
    ImageProvider? avatarProvider,
    Map<String, String>? extension,
    int? timestamp,
  }) {
    return ChatUIKitProfile(
      id: id,
      nickname: nickname ?? this.nickname,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      type: type,
      extension: extension ?? this.extension,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
