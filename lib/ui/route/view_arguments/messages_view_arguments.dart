import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class MessagesViewArguments implements ChatUIKitViewArguments {
  MessagesViewArguments({
    required this.profile,
    this.controller,
    this.appBar,
    this.title,
    this.inputBar,
    this.showAvatar = true,
    this.showNickname = true,
    this.onItemTap,
    this.onItemLongPress,
    this.onDoubleTap,
    this.onAvatarTap,
    this.onAvatarLongPressed,
    this.onNicknameTap,
    this.focusNode,
    this.emojiWidget,
    this.itemBuilder,
    this.alertItemBuilder,
    this.morePressActions,
    this.longPressActions,
    this.bubbleStyle = ChatUIKitMessageListViewBubbleStyle.arrow,
    this.replyBarBuilder,
    this.quoteBuilder,
    this.onErrorTapHandler,
    this.bubbleBuilder,
    this.enableAppBar = true,
    this.bubbleContentBuilder,
    this.onMoreActionsItemsHandler,
    this.onItemLongPressHandler,
    this.inputBarTextEditingController,
    this.forceLeft,
    this.attributes,
  });

  final ChatUIKitProfile profile;
  final MessageListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final String? title;
  final Widget? inputBar;
  final bool showAvatar;
  final bool showNickname;
  final MessageItemTapHandler? onItemTap;
  final MessageItemTapHandler? onItemLongPress;
  final MessageItemTapHandler? onDoubleTap;
  final MessageItemTapHandler? onAvatarTap;
  final MessageItemTapHandler? onAvatarLongPressed;
  final MessageItemTapHandler? onNicknameTap;
  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;
  final List<ChatUIKitBottomSheetItem>? morePressActions;
  final List<ChatUIKitBottomSheetItem>? longPressActions;
  final MessageItemBuilder? itemBuilder;
  final MessageItemBuilder? alertItemBuilder;
  final FocusNode? focusNode;
  final Widget? emojiWidget;
  final MessageItemBuilder? replyBarBuilder;
  final Widget Function(BuildContext context, QuoteModel model)? quoteBuilder;
  final bool Function(BuildContext context, Message message)? onErrorTapHandler;
  final MessageItemBubbleBuilder? bubbleBuilder;
  final MessageBubbleContentBuilder? bubbleContentBuilder;
  final MessagesViewMorePressHandler? onMoreActionsItemsHandler;
  final MessagesViewItemLongPressHandler? onItemLongPressHandler;
  final bool enableAppBar;
  final CustomTextEditingController? inputBarTextEditingController;
  bool? forceLeft;
  @override
  String? attributes;

  MessagesViewArguments copyWith({
    ChatUIKitProfile? profile,
    MessageListViewController? controller,
    ChatUIKitAppBar? appBar,
    Widget? inputBar,
    String? title,
    bool? showAvatar,
    bool? showNickname,
    MessageItemTapHandler? onItemTap,
    MessageItemTapHandler? onItemLongPress,
    MessageItemTapHandler? onDoubleTap,
    MessageItemTapHandler? onAvatarTap,
    MessageItemTapHandler? onAvatarLongPressed,
    MessageItemTapHandler? onNicknameTap,
    ChatUIKitMessageListViewBubbleStyle? bubbleStyle,
    List<ChatUIKitBottomSheetItem>? morePressActions,
    List<ChatUIKitBottomSheetItem>? longPressActions,
    MessageItemBuilder? itemBuilder,
    MessageItemBuilder? alertItemBuilder,
    FocusNode? focusNode,
    Widget? emojiWidget,
    Widget? Function(BuildContext context, Message message)? replyBarBuilder,
    Widget Function(BuildContext context, QuoteModel model)? quoteBuilder,
    bool Function(BuildContext context, Message message)? onErrorTapHandler,
    MessageItemBubbleBuilder? bubbleBuilder,
    MessageBubbleContentBuilder? bubbleContentBuilder,
    MessagesViewMorePressHandler? onMoreActionsItemsHandler,
    MessagesViewItemLongPressHandler? onItemLongPressHandler,
    CustomTextEditingController? inputBarTextEditingController,
    bool? enableAppBar,
    bool? forceLeft,
    String? attributes,
  }) {
    return MessagesViewArguments(
      profile: profile ?? this.profile,
      controller: controller ?? this.controller,
      appBar: appBar ?? this.appBar,
      title: title ?? this.title,
      inputBar: inputBar ?? this.inputBar,
      showAvatar: showAvatar ?? this.showAvatar,
      showNickname: showNickname ?? this.showNickname,
      onItemTap: onItemTap ?? this.onItemTap,
      onItemLongPress: onItemLongPress ?? this.onItemLongPress,
      onDoubleTap: onDoubleTap ?? this.onDoubleTap,
      onAvatarTap: onAvatarTap ?? this.onAvatarTap,
      onAvatarLongPressed: onAvatarLongPressed ?? this.onAvatarLongPressed,
      onNicknameTap: onNicknameTap ?? this.onNicknameTap,
      bubbleStyle: bubbleStyle ?? this.bubbleStyle,
      morePressActions: morePressActions ?? this.morePressActions,
      longPressActions: longPressActions ?? this.longPressActions,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      alertItemBuilder: alertItemBuilder ?? this.alertItemBuilder,
      focusNode: focusNode ?? this.focusNode,
      emojiWidget: emojiWidget ?? this.emojiWidget,
      replyBarBuilder: replyBarBuilder ?? this.replyBarBuilder,
      quoteBuilder: quoteBuilder ?? this.quoteBuilder,
      onErrorTapHandler: onErrorTapHandler ?? this.onErrorTapHandler,
      bubbleBuilder: bubbleBuilder ?? this.bubbleBuilder,
      bubbleContentBuilder: bubbleContentBuilder ?? this.bubbleContentBuilder,
      onMoreActionsItemsHandler:
          onMoreActionsItemsHandler ?? this.onMoreActionsItemsHandler,
      onItemLongPressHandler:
          onItemLongPressHandler ?? this.onItemLongPressHandler,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      inputBarTextEditingController:
          inputBarTextEditingController ?? this.inputBarTextEditingController,
      forceLeft: forceLeft ?? this.forceLeft,
      attributes: attributes ?? this.attributes,
    );
  }
}
