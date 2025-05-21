import 'package:em_chat_uikit/chat_uikit_universal/chat_uikit_universal.dart';

class ChatRoomUIKitSettings {
  /// Default display avatar
  static String? userDefaultAvatar;

  /// Whether to display time in the message list
  static bool enableMsgListTime = true;

  /// Whether to display identity in the message list
  static bool enableMsgListIdentify = true;

  /// Whether to display avatar in the message list
  static bool enableMsgListAvatar = true;

  /// Whether to display nickname in the message list
  static bool enableMsgListNickname = true;

  /// Default identity icon
  static String? defaultIdentify;

// Whether identities are displayed on the participant list.
  static bool enableMessageViewIdentify = true;

  /// Default gift icon
  static String? defaultGiftIcon;

  /// Default gift price icon
  static String? defaultGiftPriceIcon;

  /// Avatar corner radius
  static CornerRadius avatarRadius = CornerRadius.large;

  /// Input component corner radius
  static CornerRadius inputBarRadius = CornerRadius.large;
}
