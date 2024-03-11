import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class MessagesViewArguments implements ChatUIKitViewArguments {
  MessagesViewArguments({
    required this.profile,
    this.controller,
    this.appBar,
    this.title,
    this.inputBar,
    this.showMessageItemAvatar = true,
    this.showMessageItemNickname = true,
    this.onItemTap,
    this.onItemLongPress,
    this.onDoubleTap,
    this.onAvatarTap,
    this.onAvatarLongPress,
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
    this.multiSelectBottomBar,
    this.viewObserver,
    this.attributes,
  });

  /// 用户信息对象，用于设置对方信息。详细参考 [ChatUIKitProfile]。
  final ChatUIKitProfile profile;

  /// 消息列表控制器，用于控制消息列表和收发消息等，如果不设置将会自动创建。详细参考 [MessageListViewController]。
  final MessageListViewController? controller;

  /// 自定义AppBar, 如果设置后将会替换默认的AppBar。详细参考 [ChatUIKitAppBar]。
  final ChatUIKitAppBar? appBar;

  /// 是否显示AppBar, 默认为 `true`。 当为 `false` 时将不会显示AppBar。同时也会影响到是否显示标题。
  final bool enableAppBar;

  /// 自定义标题，如果不设置将会显示 [profile] 的 [ChatUIKitProfile.showName], 详细参考 [ChatUIKitProfile.showName]。
  final String? title;

  /// 自定义输入框, 如果设置后将会替换默认的输入框。详细参考 [ChatUIKitInputBar]。
  final Widget? inputBar;

  /// 是否显示头像, 默认为 `true`。 如果设置为 `false` 将不会显示头像。
  final bool showMessageItemAvatar;

  /// 是否显示昵称, 默认为 `true`。如果设置为 `false` 将不会显示昵称。
  final bool showMessageItemNickname;

  /// 消息点击事件, 如果设置后消息点击事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemTapHandler? onItemTap;

  /// 消息长按事件, 如果设置后消息长按事件将直接回调，返回 `true` 表示处理你需要处理，返回 `false` 则会执行默认的长按事件。
  final MessageItemTapHandler? onItemLongPress;

  /// 消息双击事件,如果设置后消息双击事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemTapHandler? onDoubleTap;

  /// 头像点击事件，如果设置后头像点击事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemTapHandler? onAvatarTap;

  /// 头像长按事件，如果设置后头像长按事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemTapHandler? onAvatarLongPress;

  /// 昵称点击事件， 如果设置后昵称点击事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemTapHandler? onNicknameTap;

  /// 气泡样式，默认为 [ChatUIKitMessageListViewBubbleStyle.arrow]。
  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;

  /// 消息 `item` 构建器, 如果设置后需要显示消息时会直接回调，如果不处理可以返回 `null`。
  final MessageItemBuilder? itemBuilder;

  /// 提示消息构建器， 如果设置后需要显示提示消息时会直接回调，如果不处理可以返回 `null`。
  final MessageItemBuilder? alertItemBuilder;

  /// 键盘焦点 focusNode，如果设置后将会替换默认的 focusNode。详细参考 [FocusNode]。
  final FocusNode? focusNode;

  /// 更多按钮点击事件列表，如果设置后将会替换默认的更多按钮点击事件列表。详细参考 [ChatUIKitBottomSheetItem]。
  final List<ChatUIKitBottomSheetItem>? morePressActions;

  /// 更多按钮点击事件， 如果设置后将会替换默认的更多按钮点击事件。详细参考 [ChatUIKitBottomSheetItem]。
  final MessagesViewMorePressHandler? onMoreActionsItemsHandler;

  /// 消息长按事件列表，如果设置后将会替换默认的消息长按事件列表。详细参考 [ChatUIKitBottomSheetItem]。
  final List<ChatUIKitBottomSheetItem>? longPressActions;

  /// 消息长按事件回调， 如果设置后将会替换默认的消息长按事件回调。当长按时会回调 [longPressActions] 中设置的事件，需要返回一个列表用于替换，如果不返回则不会显示长按。
  final MessagesViewItemLongPressHandler? onItemLongPressHandler;

  /// 强制消息靠左，默认为 `false`， 设置后自己发的消息也会在左侧显示。
  final bool? forceLeft;

  /// 表情控件，如果设置后将会替换默认的表情控件。详细参考 [ChatUIKitInputEmojiBar]。
  final Widget? emojiWidget;

  /// 回复消息输入控件构建器，如果设置后将会替换默认的回复消息输入控件构建器。详细参考 [ChatUIKitReplyBar]。
  final MessageItemBuilder? replyBarBuilder;

  /// 引用消息构建器，如果设置后将会替换默认的引用消息样式。
  final Widget Function(BuildContext context, QuoteModel model)? quoteBuilder;

  /// 错误消息点击事件，如果设置后将会替换默认的错误消息点击事件。如果不处理可以返回 `false`。默认行为为重新发送消息。
  final MessageItemTapHandler? onErrorTapHandler;

  /// 气泡构建器，如果设置后将会替换默认的气泡构建器。详细参考 [MessageItemBubbleBuilder]。
  final MessageItemBubbleBuilder? bubbleBuilder;

  /// 气泡内容构建器，如果设置后将会替换默认的气泡内容构建器。详细参考 [MessageBubbleContentBuilder]。
  final MessageBubbleContentBuilder? bubbleContentBuilder;

  /// 输入框控制器，如果设置后将会替换默认的输入框控制器。详细参考 [CustomTextEditingController]。
  final CustomTextEditingController? inputBarTextEditingController;

  /// 多选消息时显示的bottom bar.
  final Widget? multiSelectBottomBar;

  /// View 附加属性，设置后的内容将会带入到下一个页面。
  @override
  String? attributes;

  @override
  ChatUIKitViewObserver? viewObserver;

  MessagesViewArguments copyWith({
    ChatUIKitProfile? profile,
    MessageListViewController? controller,
    ChatUIKitAppBar? appBar,
    Widget? inputBar,
    String? title,
    bool? showMessageItemAvatar,
    bool? showMessageItemNickname,
    MessageItemTapHandler? onItemTap,
    MessageItemTapHandler? onItemLongPress,
    MessageItemTapHandler? onDoubleTap,
    MessageItemTapHandler? onAvatarTap,
    MessageItemTapHandler? onAvatarLongPress,
    MessageItemTapHandler? onNicknameTap,
    ChatUIKitMessageListViewBubbleStyle? bubbleStyle,
    List<ChatUIKitBottomSheetItem>? morePressActions,
    List<ChatUIKitBottomSheetItem>? longPressActions,
    MessageItemBuilder? itemBuilder,
    MessageItemBuilder? alertItemBuilder,
    FocusNode? focusNode,
    Widget? emojiWidget,
    Widget? Function(BuildContext context, MessageModel model)? replyBarBuilder,
    Widget Function(BuildContext context, QuoteModel model)? quoteBuilder,
    bool Function(BuildContext context, MessageModel message)? onErrorTapHandler,
    MessageItemBubbleBuilder? bubbleBuilder,
    MessageBubbleContentBuilder? bubbleContentBuilder,
    MessagesViewMorePressHandler? onMoreActionsItemsHandler,
    MessagesViewItemLongPressHandler? onItemLongPressHandler,
    CustomTextEditingController? inputBarTextEditingController,
    bool? enableAppBar,
    bool? forceLeft,
    Widget? multiSelectBottomBar,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return MessagesViewArguments(
      profile: profile ?? this.profile,
      controller: controller ?? this.controller,
      appBar: appBar ?? this.appBar,
      title: title ?? this.title,
      inputBar: inputBar ?? this.inputBar,
      showMessageItemAvatar:
          showMessageItemAvatar ?? this.showMessageItemAvatar,
      showMessageItemNickname:
          showMessageItemNickname ?? this.showMessageItemNickname,
      onItemTap: onItemTap ?? this.onItemTap,
      onItemLongPress: onItemLongPress ?? this.onItemLongPress,
      onDoubleTap: onDoubleTap ?? this.onDoubleTap,
      onAvatarTap: onAvatarTap ?? this.onAvatarTap,
      onAvatarLongPress: onAvatarLongPress ?? this.onAvatarLongPress,
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
      multiSelectBottomBar: multiSelectBottomBar ?? this.multiSelectBottomBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
