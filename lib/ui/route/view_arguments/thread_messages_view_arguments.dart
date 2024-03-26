import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ThreadMessagesViewArguments implements ChatUIKitViewArguments {
  ThreadMessagesViewArguments({
    required this.controller,
    this.attributes,
    this.viewObserver,
    this.appBar,
    this.enableAppBar = true,
    this.title,
    this.subtitle,
    this.inputBarController,
    this.inputBarFocusNode,
    this.morePressActions,
    this.onMoreActionsItemsHandler,
    this.longPressActions,
    this.onItemLongPressHandler,
    this.forceLeft,
    this.emojiWidget,
    this.replyBarBuilder,
    this.quoteBuilder,
  });

  @override
  String? attributes;

  @override
  ChatUIKitViewObserver? viewObserver;

  final String? title;
  final String? subtitle;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final ThreadMessagesViewController controller;

  final ChatUIKitInputBarController? inputBarController;
  final FocusNode? inputBarFocusNode;

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
}
