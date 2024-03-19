import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

// message
typedef MessageItemBuilder = Widget? Function(
    BuildContext context, MessageModel model);

typedef MessageItemTapHandler = bool? Function(
    BuildContext context, MessageModel model);

typedef MessageReactionItemTapHandler = bool? Function(
    BuildContext context, MessageModel model, MessageReaction reaction);

typedef MessagesViewItemLongPressHandler = List<ChatUIKitBottomSheetItem>?
    Function(
  BuildContext context,
  MessageModel model,
  List<ChatUIKitBottomSheetItem> defaultActions,
);

typedef MessagesViewMorePressHandler = List<ChatUIKitBottomSheetItem>? Function(
  BuildContext context,
  List<ChatUIKitBottomSheetItem> defaultActions,
);

typedef MessageItemBubbleBuilder = Widget? Function(
  BuildContext context,
  Widget child,
  MessageModel model,
);

// report
typedef ChatUIKitReportReasonHandler = Map<String, String> Function(
  BuildContext context,
);

// contact
typedef ChatUIKitContactItemBuilder = Widget? Function(
    BuildContext context, ContactItemModel model);

// group
typedef ChatUIKitGroupItemBuilder = Widget Function(
    BuildContext context, GroupItemModel model);

typedef WillCreateHandler = Future<CreateGroupInfo?> Function(
  BuildContext context,
  CreateGroupInfo? createGroupInfo,
  List<ChatUIKitProfile> selectedProfiles,
);

// conversation
typedef ConversationItemBuilder = Widget? Function(
    BuildContext context, ConversationModel model);

typedef ConversationListViewShowHandler = List<ConversationModel> Function(
    List<ConversationModel> conversations);

typedef ConversationsViewItemLongPressHandler = List<ChatUIKitBottomSheetItem>?
    Function(
  BuildContext context,
  ConversationModel info,
  List<ChatUIKitBottomSheetItem> defaultActions,
);

// new request
typedef ChatUIKitNewRequestItemBuilder = Widget Function(
    BuildContext context, NewRequestItemModel model);

// app bar
typedef AppBarMoreActionsBuilder = List<ChatUIKitBottomSheetItem> Function(
    BuildContext context, List<ChatUIKitBottomSheetItem> items);

// time
typedef TimeFormatterHandler = String? Function(
  BuildContext context,
  ChatUIKitTimeType type,
  int time,
);
