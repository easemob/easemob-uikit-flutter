const String userGroupName = 'chatUIKit_group_member_nick_name';
const String msgUserInfoKey = "ease_chat_uikit_user_info";
const String userAvatarKey = "avatarURL";
const String userNicknameKey = "nickname";
const String cardMessageKey = "userCard";
const String cardNicknameKey = "nickname";
const String cardUserIdKey = "uid";
const String cardAvatarKey = "avatar";

const String quoteKey = 'msgQuote';
const String quoteMsgIdKey = 'msgID';
const String quoteMsgTypeKey = 'msgType';
const String quoteMsgPreviewKey = 'msgPreview';
const String quoteMsgSenderKey = 'msgSender';

const String alertTimeKey = 'timeMessageKey';

const String alertRecalledKey = 'alertRecalledKey';
const String alertCreateThreadKey = 'createThreadKey';
const String alertUpdateThreadKey = 'updateThreadKey';
const String alertDeleteThreadKey = 'deleteThreadKey';

const String alertOperatorKey = 'alertOperatorKey';
const String alertOperatorInfoKey = 'alertOperatorInfoKey';
const String alertThreadId = 'alertThreadId';
const String alertThreadInMsgId = 'alertThreadInMsgId';

const String alertRecallInfoKey = 'alertRecallInfoKey';
const String alertRecallMessageTypeKey = 'alertRecallMessageTypeKey';
const String alertRecallMessageFromKey = 'alertRecallMessageFromKey';
const String alertRecallMessageDirectionKey = 'alertRecallMessageDirectionKey';

const String alertGroupCreateKey = 'createGroupKey';
const String alertGroupDestroyKey = 'alertGroupDestroyKey';
const String alertGroupLeaveKey = 'alertGroupLeaveKey';
const String alertGroupKickedKey = 'alertGroupKickedKey';

const String mentionKey = 'em_at_list';
const String mentionAllValue = 'ALL';
const String hasMentionKey = 'mention';
const String hasMentionValue = 'mention';

const String voiceHasReadKey = 'voiceHasRead';
const String hasTranslatedKey = 'hasTranslatedKey';

enum MessageLongPressActionType {
  reaction,
  copy, // only text message
  reply,
  forward,
  multiSelect,
  translate, // only text message
  thread,
  edit, // only text message
  report,
  delete,
  recall,
}
