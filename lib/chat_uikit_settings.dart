import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

enum CornerRadius { extraSmall, small, medium, large }

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
  static String translateTargetLanguage = 'zh-Hans';

  static bool enableInputStatus = false;

  static List<String> favoriteReaction = [
    '\u{1F44D}',
    '\u{2764}',
    '\u{1F609}',
    '\u{1F928}',
    '\u{1F62D}',
    '\u{1F389}',
  ];

  static List<MessageLongPressActionType> msgItemLongPressActions = [
    MessageLongPressActionType.reaction,
    MessageLongPressActionType.copy, // only text message
    MessageLongPressActionType.reply,
    MessageLongPressActionType.forward,
    MessageLongPressActionType.multiSelect,
    MessageLongPressActionType.translate, // only text message
    MessageLongPressActionType.thread, // only group message
    MessageLongPressActionType.edit, // only text message
    MessageLongPressActionType.report,
    MessageLongPressActionType.recall,
    MessageLongPressActionType.delete,
  ];

  static bool enableThread = true;
  static bool enableTranslation = true;
  static bool enableReaction = true;
}
