import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

enum CornerRadius { extraSmall, small, medium, large }

typedef ChatUIKitReportReasonHandler = Map<String, String> Function(
  BuildContext context,
);

class ChatUIKitSettings {
  // 头像圆角
  static CornerRadius avatarRadius = CornerRadius.medium;

  // 搜索框圆角
  static CornerRadius searchBarRadius = CornerRadius.small;

  // 头像默认占位图
  static ImageProvider? avatarPlaceholder;

  // Dialog 圆角
  static ChatUIKitDialogRectangleType dialogRectangleType =
      ChatUIKitDialogRectangleType.filletCorner;

  // 会话列表是否显示头像
  static bool showConversationListAvatar = true;

  // 会话列表是否显示未读消息数
  static bool showConversationListUnreadCount = true;

  // 会话列表显示的静音图标
  static ImageProvider? conversationListMuteImage;

  /// 撤回消息的时间限制，单位秒
  static int recallExpandTime = 120;

  static Map<String, String> reportMessageReason = {
    'tag1': '不受欢迎的商业内容或垃圾内容',
    'tag2': '色情或露骨内容',
    'tag3': '虐待儿童',
    'tag4': '仇恨言论或过于写实的暴力内容',
    'tag5': '宣扬恐怖主义',
    'tag6': '骚扰或欺凌',
    'tag7': '自杀或自残',
    'tag8': '虚假信息',
    'tag9': '其他',
  };

  // v2
  static String translateLanguage = 'zh-Hans';

  static bool enableInputStatus = false;

  static bool enableReaction = true;

  static List<String> favoriteReaction = [
    'like',
    'love',
    'haha',
    'wow',
    'sad',
    'angry',
  ];
}
