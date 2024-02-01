import 'package:flutter/material.dart';

enum ChatUIKitProfileType {
  /// Profile type for contact
  contact,

  /// Profile type for group
  group,
}

class ChatUIKitProfile {
  final String id;
  final String? name;
  final String? avatarUrl;
  final ImageProvider? avatarProvider;
  final ChatUIKitProfileType? type;
  final Map<String, String>? extension;
  final int timestamp;

  String get showName => name?.isNotEmpty == true ? name! : id;

  ChatUIKitProfile({
    required this.id,
    required this.type,
    this.name,
    this.avatarUrl,
    this.avatarProvider,
    this.extension,
    this.timestamp = 0,
  });

  ChatUIKitProfile.contact({
    required String id,
    String? name,
    String? avatarUrl,
    ImageProvider? avatarProvider,
    Map<String, String>? extension,
    int timestamp = 0,
  }) : this(
          id: id,
          name: name,
          avatarUrl: avatarUrl,
          avatarProvider: avatarProvider,
          type: ChatUIKitProfileType.contact,
          extension: extension,
          timestamp: timestamp,
        );

  ChatUIKitProfile.group({
    required String id,
    String? name,
    String? avatarUrl,
    ImageProvider? avatarProvider,
    Map<String, String>? extension,
    int timestamp = 0,
  }) : this(
          id: id,
          name: name,
          avatarUrl: avatarUrl,
          avatarProvider: avatarProvider,
          type: ChatUIKitProfileType.group,
          extension: extension,
          timestamp: timestamp,
        );

  ChatUIKitProfile copy({
    String? name,
    String? avatarUrl,
    ImageProvider? avatarProvider,
    Map<String, String>? extension,
    int? timestamp,
  }) {
    return ChatUIKitProfile(
      id: id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarProvider: avatarProvider,
      type: type,
      extension: extension ?? this.extension,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
