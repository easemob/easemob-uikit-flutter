import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';
import '../universal/defines.dart';

extension MessageHelper on Message {
  MessageType get bodyType => body.type;

  ChatUIKitProfile get fromProfile {
    return ChatUIKitProvider.instance.getProfile(
      ChatUIKitProfile.contact(
        id: from!,
        avatarUrl: avatarUrl,
        name: nickname,
      ),
    );
  }

  String? get avatarUrl {
    Map? userInfo = attributes?[msgUserInfoKey];
    return userInfo?[userAvatarKey];
  }

  bool get voiceHasPlay {
    return attributes?[voiceHasReadKey] == true;
  }

  void setVoiceHasPlay(bool hasPlay) {
    attributes ??= {};
    attributes![voiceHasReadKey] = hasPlay;
    ChatUIKit.instance.updateMessage(message: this);
  }

  String? get nickname {
    Map? userInfo = attributes?[msgUserInfoKey];
    return userInfo?[userNicknameKey];
  }

  void addNickname(String? nickname) {
    if (nickname?.isNotEmpty == true) {
      attributes ??= {};
      attributes![msgUserInfoKey] ??= {};
      attributes![msgUserInfoKey][userNicknameKey] = nickname;
    }
  }

  void addAvatarURL(String? avatarUrl) {
    if (avatarUrl?.isNotEmpty == true) {
      attributes ??= {};
      attributes![msgUserInfoKey] ??= {};
      attributes![msgUserInfoKey][userAvatarKey] = avatarUrl;
    }
  }

  String get textContent {
    if (bodyType == MessageType.TXT) {
      return (body as TextMessageBody).content;
    }
    return '';
  }

  bool get isEdit {
    if (bodyType == MessageType.TXT) {
      if ((body as TextMessageBody).modifyCount == null) return false;
      return (body as TextMessageBody).modifyCount! > 0;
    }
    return false;
  }

  String? get displayName {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).displayName;
    } else if (bodyType == MessageType.VOICE) {
      return (body as VoiceMessageBody).displayName;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).displayName;
    } else if (bodyType == MessageType.FILE) {
      return (body as FileMessageBody).displayName;
    }
    return null;
  }

  int get duration {
    if (bodyType == MessageType.VOICE) {
      return (body as VoiceMessageBody).duration;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).duration ?? 0;
    }
    return 0;
  }

  int get fileSize {
    int? length;
    if (bodyType == MessageType.IMAGE) {
      length = (body as ImageMessageBody).fileSize;
    } else if (bodyType == MessageType.VOICE) {
      length = (body as VoiceMessageBody).fileSize;
    } else if (bodyType == MessageType.VIDEO) {
      length = (body as VideoMessageBody).fileSize;
    } else if (bodyType == MessageType.FILE) {
      length = (body as FileMessageBody).fileSize;
    } else {
      length = 0;
    }
    return length!;
  }

  String get fileSizeStr {
    int? length;
    if (bodyType == MessageType.IMAGE) {
      length = (body as ImageMessageBody).fileSize;
    } else if (bodyType == MessageType.VOICE) {
      length = (body as VoiceMessageBody).fileSize;
    } else if (bodyType == MessageType.VIDEO) {
      length = (body as VideoMessageBody).fileSize;
    } else if (bodyType == MessageType.FILE) {
      length = (body as FileMessageBody).fileSize;
    } else {
      length = 0;
    }
    return ChatUIKitFileSizeTool.fileSize(length!);
  }

  String? get thumbnailLocalPath {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).thumbnailLocalPath;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).thumbnailLocalPath;
    }
    return null;
  }

  String? get thumbnailRemotePath {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).thumbnailRemotePath;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).thumbnailRemotePath;
    }
    return null;
  }

  String? get localPath {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).localPath;
    } else if (bodyType == MessageType.VOICE) {
      return (body as VoiceMessageBody).localPath;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).localPath;
    } else if (bodyType == MessageType.FILE) {
      return (body as FileMessageBody).localPath;
    }
    return null;
  }

  String? get remotePath {
    if (bodyType == MessageType.IMAGE) {
      return (body as ImageMessageBody).remotePath;
    } else if (bodyType == MessageType.VOICE) {
      return (body as VoiceMessageBody).remotePath;
    } else if (bodyType == MessageType.VIDEO) {
      return (body as VideoMessageBody).remotePath;
    } else if (bodyType == MessageType.FILE) {
      return (body as FileMessageBody).remotePath;
    }
    return null;
  }

  double get width {
    double ret = 0.0;
    if (bodyType == MessageType.IMAGE) {
      ret = (body as ImageMessageBody).width ?? 0;
    } else if (bodyType == MessageType.VIDEO) {
      ret = (body as VideoMessageBody).width ?? 0;
    }
    return ret;
  }

  double get height {
    double ret = 0.0;
    if (bodyType == MessageType.IMAGE) {
      ret = (body as ImageMessageBody).height ?? 0;
    } else if (bodyType == MessageType.VIDEO) {
      ret = (body as VideoMessageBody).height ?? 0;
    }
    return ret;
  }

  bool get isCardMessage {
    if (bodyType == MessageType.CUSTOM) {
      final customBody = body as CustomMessageBody;
      if (customBody.event == cardMessageKey) {
        return true;
      }
    }
    return false;
  }

  String? get cardUserNickname {
    if (bodyType == MessageType.CUSTOM) {
      final customBody = body as CustomMessageBody;
      if (customBody.event == cardMessageKey) {
        return customBody.params?[cardNicknameKey];
      }
    }
    return null;
  }

  String? get cardUserAvatar {
    if (bodyType == MessageType.CUSTOM) {
      final customBody = body as CustomMessageBody;
      if (customBody.event == cardMessageKey) {
        return customBody.params?[cardAvatarKey];
      }
    }
    return null;
  }

  String? get cardUserId {
    if (bodyType == MessageType.CUSTOM) {
      final customBody = body as CustomMessageBody;
      if (customBody.event == cardMessageKey) {
        return customBody.params?[cardUserIdKey];
      }
    }
    return null;
  }

  String showInfo({BuildContext? context}) {
    String? title;
    if (chatType == ChatType.GroupChat) {
      title = "${nickname ?? from ?? ""}: ";
    }

    String? str;

    switch (body.type) {
      case MessageType.TXT:
        str = (body as TextMessageBody).content;
        break;
      case MessageType.IMAGE:
        str = '[Image]';
        break;
      case MessageType.VIDEO:
        str = '[Video]';
        break;
      case MessageType.VOICE:
        str = '[Voice]';
        break;
      case MessageType.LOCATION:
        str = '[Location]';
        break;
      case MessageType.COMBINE:
        str = '[Combine]';
        break;
      case MessageType.FILE:
        str = '[File]';
        break;
      case MessageType.CUSTOM:
        if (isCardMessage) {
          str = '[Card]';
        } else {
          if (isRecallAlert) {
            Map<String, String>? map = (body as CustomMessageBody).params;

            String? from = map?[alertRecallMessageFromKey];
            String? showName;
            if (ChatUIKit.instance.currentUserId == from) {
              showName =
                  ChatUIKitLocal.messagesViewRecallInfoYou.getString(context!);
            } else {
              ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
                ChatUIKitProfile.contact(id: from!),
              );
              showName = profile.showName;
            }
            return '$showName${ChatUIKitLocal.messagesViewRecallInfo.getString(context!)}';
          }
          if (isCreateGroupAlert) {
            Map<String, String>? map = (body as CustomMessageBody).params;
            String? operator = map![alertCreateGroupMessageOwnerKey]!;
            String? showName;
            if (ChatUIKit.instance.currentUserId == operator) {
              showName =
                  ChatUIKitLocal.messagesViewRecallInfoYou.getString(context!);
            } else {
              ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
                ChatUIKitProfile.contact(id: from!),
              );
              showName = profile.showName;
            }
            return '$showName ${ChatUIKitLocal.messagesViewAlertGroupInfoTitle.getString(context!)}';
          }
          if (isDestroyGroupAlert) {
            return ChatUIKitLocal.messagesViewGroupDestroyInfo
                .getString(context!);
          }

          if (isLeaveGroupAlert) {
            return ChatUIKitLocal.messagesViewGroupLeaveInfo
                .getString(context!);
          }

          if (isKickedGroupAlert) {
            return ChatUIKitLocal.messagesViewGroupKickedInfo
                .getString(context!);
          }

          str = '[Custom]';
        }

        break;
      default:
    }

    if (title?.isNotEmpty == true) {
      str = '$title$str';
    }

    return str ?? '';
  }

  bool get hasMention {
    bool ret = false;
    if (attributes == null) {
      ret = false;
    }
    if (attributes?[mentionKey] == null) {
      ret = false;
    }
    if (attributes?[mentionKey] is List) {
      List mentionList = attributes?[mentionKey];
      if (mentionList.isNotEmpty) {
        ret = mentionList.contains(ChatUIKit.instance.currentUserId);
      }
    } else if (attributes?[mentionKey] is String) {
      if (attributes?[mentionKey] == mentionAllValue) {
        ret = true;
      }
    }

    return ret;
  }

  bool get isTimeMessageAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertTimeMessageEventKey) {
        return true;
      }
    }
    return false;
  }

  bool get isCreateGroupAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event ==
          alertCreateGroupMessageEventKey) {
        return true;
      }
    }
    return false;
  }

  bool get isRecallAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertRecalledKey) {
        return true;
      }
    }
    return false;
  }

  bool get isDestroyGroupAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertGroupDestroyKey) {
        return true;
      }
    }
    return false;
  }

  bool get isLeaveGroupAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertGroupLeaveKey) {
        return true;
      }
    }
    return false;
  }

  bool get hasTranslate {
    return attributes?[hasTranslatedKey] == true;
  }

  String get translateText {
    if (hasTranslate) {
      Map<String, String>? map = (body as TextMessageBody).translations;
      if (map != null) {
        return map[ChatUIKitSettings.translateLanguage] ??
            map[(body as TextMessageBody).targetLanguages?.first] ??
            '';
      }
    }
    return '';
  }

  bool get isKickedGroupAlert {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertGroupKickedKey) {
        return true;
      }
    }
    return false;
  }

  MessageType? get recalledMessageType {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertRecalledKey) {
        String? type =
            (body as CustomMessageBody).params?[alertRecallMessageTypeKey];
        if (type == null) return null;
        return MessageType.values[int.parse(type)];
      }
    }
    return null;
  }

  String? get recallMessageInfo {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertRecalledKey) {
        return (body as CustomMessageBody).params?[alertRecallInfoKey];
      }
    }
    return null;
  }

  String? get recallMessageFrom {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertRecalledKey) {
        return (body as CustomMessageBody).params?[alertRecallMessageFromKey];
      }
    }
    return null;
  }

  MessageDirection? get recallMessageDirection {
    if (bodyType == MessageType.CUSTOM) {
      if ((body as CustomMessageBody).event == alertRecalledKey) {
        String? directionStr =
            (body as CustomMessageBody).params?[alertRecallMessageDirectionKey];
        if (directionStr == null) return null;
        return MessageDirection.values[int.parse(directionStr)];
      }
    }
    return null;
  }

  void addQuote(Message message) {
    attributes ??= {};
    attributes![quoteKey] = message.toQuote().toJson();
  }

  QuoteModel toQuote() {
    return QuoteModel.fromMessage(this);
  }

  bool get hasQuote {
    return attributes?[quoteKey] != null;
  }

  QuoteModel? get getQuote {
    Map? quoteMap = attributes?[quoteKey];
    if (quoteMap != null) {
      return QuoteModel(
        quoteMap[quoteMsgIdKey],
        quoteMap[quoteMsgTypeKey],
        quoteMap[quoteMsgPreviewKey],
        quoteMap[quoteMsgSenderKey],
      );
    }
    return null;
  }
}
