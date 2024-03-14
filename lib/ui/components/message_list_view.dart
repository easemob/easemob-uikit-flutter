import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class MessageListView extends StatefulWidget {
  const MessageListView({
    required this.profile,
    this.controller,
    this.onItemLongPress,
    this.onDoubleTap,
    this.onItemTap,
    this.onAvatarTap,
    this.onAvatarLongPressed,
    this.onNicknameTap,
    this.showAvatar = true,
    this.showNickname = true,
    this.itemBuilder,
    this.alertItemBuilder,
    this.bubbleStyle = ChatUIKitMessageListViewBubbleStyle.arrow,
    this.quoteBuilder,
    this.onErrorBtnTap,
    this.bubbleBuilder,
    this.bubbleContentBuilder,
    this.forceLeft,
    this.onReactionTap,
    this.onReactionInfoTap,
    super.key,
  });
  final ChatUIKitProfile profile;
  final MessageListViewController? controller;
  final MessageItemTapHandler? onItemTap;
  final MessageItemTapHandler? onItemLongPress;
  final MessageItemTapHandler? onDoubleTap;
  final MessageItemTapHandler? onAvatarTap;
  final MessageItemTapHandler? onAvatarLongPressed;
  final MessageItemTapHandler? onNicknameTap;
  final ChatUIKitMessageListViewBubbleStyle bubbleStyle;
  final MessageItemBuilder? itemBuilder;
  final MessageItemBuilder? alertItemBuilder;
  final bool showAvatar;
  final bool showNickname;
  final Widget Function(BuildContext context, QuoteModel model)? quoteBuilder;
  final void Function(MessageModel model)? onErrorBtnTap;
  final MessageItemBubbleBuilder? bubbleBuilder;
  final MessageItemBuilder? bubbleContentBuilder;
  final bool? forceLeft;
  final void Function(MessageModel model, MessageReaction reaction)?
      onReactionTap;
  final void Function(MessageModel model)? onReactionInfoTap;

  @override
  State<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  late final MessageListViewController controller;
  late final AutoScrollController _scrollController;
  ChatUIKitTheme? theme;
  Size? size;

  @override
  void initState() {
    super.initState();
    _scrollController = AutoScrollController();
    controller =
        widget.controller ?? MessageListViewController(profile: widget.profile);
    controller.addListener(() {
      if (controller.lastActionType == MessageLastActionType.load) {
        setState(() {});
      }

      if ((controller.lastActionType == MessageLastActionType.receive &&
              _scrollController.offset == 0) ||
          controller.lastActionType == MessageLastActionType.send) {
        setState(() {});
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (_scrollController.positions.isNotEmpty) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
            );
          }
        });
      }
    });
    fetchMessages();
    controller.sendConversationsReadAck();
    controller.clearMentionIfNeed();
  }

  @override
  void dispose() {
    controller.isDisposed = true;
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void fetchMessages() {
    controller.fetchItemList();
  }

  @override
  Widget build(BuildContext context) {
    theme ??= ChatUIKitTheme.of(context);
    size ??= MediaQuery.of(context).size;
    Widget content = CustomScrollView(
      physics: controller.msgModelList.length > 15
          ? const AlwaysScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      controller: _scrollController,
      reverse: true,
      shrinkWrap: controller.msgModelList.length > 15 ? false : true,
      cacheExtent: 1500,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              findChildIndexCallback: (key) {
                if (key is ValueKey<String?> && key.value != null) {
                  final ValueKey<String?> valueKey = key;
                  int index = controller.msgModelList.indexWhere(
                    (model) => model.id == valueKey.value,
                  );
                  return index > -1 ? index : null;
                } else {
                  return null;
                }
              },
              (context, index) {
                return SizedBox(
                  key: ValueKey(controller.msgModelList[index].id),
                  child: _item(controller.msgModelList[index], index),
                );
              },
              childCount: controller.msgModelList.length,
            ),
          ),
        ),
      ],
    );
    content = Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: content,
    );

    content = MessageListShareUserData(
      data: controller.userMap,
      child: content,
    );

    content = NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (controller.hasNew && _scrollController.offset < 20) {
            controller.hasNew = false;
            setState(() {});
          }
          if (_scrollController.position.maxScrollExtent -
                  _scrollController.offset <
              1500) {
            fetchMessages();
          }
        }

        return false;
      },
      child: content,
    );

    content = ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: content,
    );

    content = PopScope(
      child: content,
      onPopInvoked: (canPop) async {
        await controller.markAllMessageAsRead();
      },
    );

    content = Scaffold(
      key: ValueKey(controller.profile.id),
      body: content,
      backgroundColor: theme!.color.isDark
          ? theme!.color.neutralColor1
          : theme!.color.neutralColor98,
    );

    return content;
  }

  Widget _item(MessageModel model, int index) {
    controller.sendMessageReadAck(model.message);
    if (model.message.isTimeMessageAlert) {
      Widget? content = widget.alertItemBuilder?.call(
        context,
        model,
      );
      content ??= ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: ChatUIKitTimeFormatter.instance.formatterHandler?.call(
                    context,
                    ChatUIKitTimeType.message,
                    model.message.serverTime) ??
                ChatUIKitTimeTool.getChatTimeStr(
                  model.message.serverTime,
                  needTime: true,
                ),
          )
        ],
      );
      return content;
    }

    if (model.message.isRecallAlert ||
        model.message.isCreateGroupAlert ||
        model.message.isDestroyGroupAlert ||
        model.message.isKickedGroupAlert ||
        model.message.isLeaveGroupAlert) {
      if (widget.alertItemBuilder != null) {
        return widget.alertItemBuilder!.call(context, model)!;
      }
    }

    Widget? content = widget.itemBuilder?.call(context, model);
    content ??= ChatUIKitMessageListViewMessageItem(
      enableSelected: controller.isMultiSelectMode
          ? () {
              if (controller.selectedMessages
                  .map((e) => e.msgId)
                  .toList()
                  .contains(model.message.msgId)) {
                controller.selectedMessages
                    .removeWhere((e) => model.message.msgId == e.msgId);
              } else {
                controller.selectedMessages.add(model.message);
              }
              setState(() {});
            }
          : null,
      forceLeft: widget.forceLeft,
      bubbleContentBuilder: widget.bubbleContentBuilder,
      bubbleBuilder: widget.bubbleBuilder,
      onErrorBtnTap: () {
        widget.onErrorBtnTap?.call(model);
      },
      bubbleStyle: widget.bubbleStyle,
      showAvatar: widget.showAvatar,
      quoteBuilder: (context, model) {
        Widget? content = widget.quoteBuilder?.call(context, model);
        content ??= quoteWidget(model);
        return content;
      },
      showNickname: widget.showNickname,
      onAvatarTap: () {
        if (widget.onAvatarTap != null) {
          widget.onAvatarTap?.call(context, model);
        }
      },
      onAvatarLongPressed: () {
        widget.onAvatarLongPressed?.call(context, model);
      },
      onBubbleDoubleTap: () {
        widget.onDoubleTap?.call(context, model);
      },
      onBubbleLongPressed: () {
        widget.onItemLongPress?.call(context, model);
      },
      onBubbleTap: () {
        widget.onItemTap?.call(context, model);
      },
      onNicknameTap: () {
        widget.onNicknameTap?.call(context, model);
      },
      model: model,
      reactions: model.reactions,
      onReactionTap: (reaction) {
        widget.onReactionTap?.call(model, reaction);
      },
      onReactionInfoTap: () {
        widget.onReactionInfoTap?.call(model);
      },
    );

    double zoom = 0.8;
    if (size!.width > size!.height) {
      zoom = 0.5;
    }

    content = SizedBox(
      width: size!.width * zoom,
      child: content,
    );

    content = Align(
      alignment: widget.forceLeft == true
          ? Alignment.centerLeft
          : model.message.direction == MessageDirection.SEND
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: content,
    );

    if (controller.isMultiSelectMode) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              if (controller.selectedMessages
                  .map((e) => e.msgId)
                  .toList()
                  .contains(model.message.msgId)) {
                controller.selectedMessages
                    .removeWhere((e) => e.msgId == model.message.msgId);
              } else {
                controller.selectedMessages.add(model.message);
              }
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 10, bottom: 20),
              child: controller.selectedMessages
                      .map((e) => e.msgId)
                      .toList()
                      .contains(model.message.msgId)
                  ? Icon(
                      Icons.check_box,
                      size: 28,
                      color: theme!.color.isDark
                          ? theme!.color.primaryColor6
                          : theme!.color.primaryColor5,
                    )
                  : Icon(
                      Icons.check_box_outline_blank,
                      size: 28,
                      color: theme!.color.isDark
                          ? theme!.color.neutralColor4
                          : theme!.color.neutralColor7,
                    ),
            ),
          ),
          Expanded(child: content)
        ],
      );
    }

    content = AutoScrollTag(
      key: ValueKey(model.id),
      controller: _scrollController,
      index: index,
      highlightColor: theme!.color.isDark
          ? theme!.color.neutralColor2
          : theme!.color.neutralColor95,
      child: content,
    );

    return content;
  }

  Widget quoteWidget(QuoteModel model) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        jumpToQuoteModel(model);
      },
      child: ChatUIKitQuoteWidget(
        model: model,
        bubbleStyle: widget.bubbleStyle,
      ),
    );
  }

  void jumpToQuoteModel(QuoteModel model) async {
    int index = controller.msgModelList
        .indexWhere((element) => element.message.msgId == model.msgId);

    if (index != -1) {
      _scrollController.scrollToIndex(
        index,
        preferPosition: AutoScrollPosition.end,
        duration: const Duration(milliseconds: 10),
      );
      await _scrollController.scrollToIndex(
        index,
        preferPosition: AutoScrollPosition.end,
        duration: const Duration(milliseconds: 100),
      );

      await _scrollController.highlight(
        index,
        highlightDuration: const Duration(milliseconds: 500),
      );
    }
  }
}
