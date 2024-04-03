import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../universal/inner_headers.dart';

/// 消息页面
class MessagesView extends StatefulWidget {
  /// 构造函数, 通过 [MessagesViewArguments] 传入参数。详细参考 [MessagesViewArguments]。
  MessagesView.arguments(MessagesViewArguments arguments, {super.key})
      : profile = arguments.profile,
        controller = arguments.controller,
        inputBar = arguments.inputBar,
        appBar = arguments.appBar,
        title = arguments.title,
        showMessageItemAvatar = arguments.showMessageItemAvatar,
        showMessageItemNickname = arguments.showMessageItemNickname,
        onItemTap = arguments.onItemTap,
        onItemLongPress = arguments.onItemLongPress,
        onDoubleTap = arguments.onDoubleTap,
        onAvatarTap = arguments.onAvatarTap,
        onNicknameTap = arguments.onNicknameTap,
        bubbleStyle = arguments.bubbleStyle,
        emojiWidget = arguments.emojiWidget,
        itemBuilder = arguments.itemBuilder,
        alertItemBuilder = arguments.alertItemBuilder,
        onAvatarLongPress = arguments.onAvatarLongPress,
        morePressActions = arguments.morePressActions,
        longPressActions = arguments.longPressActions,
        replyBarBuilder = arguments.replyBarBuilder,
        quoteBuilder = arguments.quoteBuilder,
        onErrorBtnTapHandler = arguments.onErrorBtnTapHandler,
        bubbleBuilder = arguments.bubbleBuilder,
        enableAppBar = arguments.enableAppBar,
        onMoreActionsItemsHandler = arguments.onMoreActionsItemsHandler,
        onItemLongPressHandler = arguments.onItemLongPressHandler,
        bubbleContentBuilder = arguments.bubbleContentBuilder,
        inputBarTextEditingController = arguments.inputBarTextEditingController,
        forceLeft = arguments.forceLeft,
        multiSelectBottomBar = arguments.multiSelectBottomBar,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes,
        onReactionItemTap = arguments.onReactionItemTap,
        onReactionInfoTap = arguments.onReactionInfoTap,
        reactionItemsBuilder = arguments.reactionItemsBuilder,
        onThreadItemTap = arguments.onThreadItemTap,
        threadItemBuilder = arguments.threadItemBuilder;

  /// 构造函数。
  const MessagesView({
    required this.profile,
    this.appBar,
    this.enableAppBar = true,
    this.title,
    this.inputBar,
    this.controller,
    this.showMessageItemAvatar = true,
    this.showMessageItemNickname = true,
    this.onItemTap,
    this.onItemLongPress,
    this.onDoubleTap,
    this.onAvatarTap,
    this.onAvatarLongPress,
    this.onNicknameTap,
    this.emojiWidget,
    this.itemBuilder,
    this.alertItemBuilder,
    this.bubbleStyle = ChatUIKitMessageListViewBubbleStyle.arrow,
    this.longPressActions,
    this.morePressActions,
    this.replyBarBuilder,
    this.quoteBuilder,
    this.onErrorBtnTapHandler,
    this.bubbleBuilder,
    this.bubbleContentBuilder,
    this.onMoreActionsItemsHandler,
    this.onItemLongPressHandler,
    this.forceLeft,
    this.inputBarTextEditingController,
    this.multiSelectBottomBar,
    this.viewObserver,
    this.attributes,
    this.onReactionItemTap,
    this.onReactionInfoTap,
    this.reactionItemsBuilder,
    this.onThreadItemTap,
    this.threadItemBuilder,
    super.key,
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
  final MessageItemTapHandler? onErrorBtnTapHandler;

  /// 气泡构建器，如果设置后将会替换默认的气泡构建器。详细参考 [MessageItemBubbleBuilder]。
  final MessageItemBubbleBuilder? bubbleBuilder;

  /// 气泡内容构建器，如果设置后将会替换默认的气泡内容构建器。详细参考 [MessageItemBuilder]。
  final MessageItemBuilder? bubbleContentBuilder;

  /// 输入框控制器，如果设置后将会替换默认的输入框控制器。详细参考 [CustomTextEditingController]。
  final ChatUIKitInputBarController? inputBarTextEditingController;

  /// View 附加属性，设置后的内容将会带入到下一个页面。
  final String? attributes;

  /// 多选时显示的 bottom bar
  final Widget? multiSelectBottomBar;

  final MessageReactionItemTapHandler? onReactionItemTap;

  final MessageItemTapHandler? onReactionInfoTap;

  final MessageItemBuilder? reactionItemsBuilder;

  final MessageItemTapHandler? onThreadItemTap;

  final MessageItemBuilder? threadItemBuilder;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> with ChatObserver {
  late final MessageListViewController controller;
  late final ChatUIKitInputBarController inputBarController;
  late final ImagePicker _picker;
  late final AudioPlayer _player;
  late final AutoScrollController _scrollController;
  String? title;
  bool showEmoji = false;
  bool showMoreBtn = true;

  bool messageEditCanSend = false;
  ChatUIKitInputBarController? editBarTextEditingController;
  Message? editMessage;
  MessageModel? replyMessage;
  ChatUIKitProfile? profile;
  Message? _playingMessage;
  final ValueNotifier<bool> _remoteTyping = ValueNotifier(false);
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();

    profile = widget.profile;

    ChatUIKit.instance.addObserver(this);
    _scrollController = AutoScrollController();
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
    inputBarController = widget.inputBarTextEditingController ?? ChatUIKitInputBarController();
    inputBarController.addListener(() {
      attemptSendInputType();
      if (showMoreBtn != !inputBarController.text.trim().isNotEmpty) {
        showMoreBtn = !inputBarController.text.trim().isNotEmpty;
        setState(() {});
      }
      if (inputBarController.needMention) {
        if (profile?.type == ChatUIKitProfileType.group) {
          needMention();
        }
      }
    });
    inputBarController.focusNode.addListener(() {
      if (editMessage != null) return;
      if (inputBarController.hasFocus) {
        showEmoji = false;
        setState(() {});
      }
    });

    controller = widget.controller ?? MessageListViewController(profile: profile!);
    controller.addListener(() {
      setState(() {});
      if (controller.lastActionType == MessageLastActionType.topPosition) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          int index =
              controller.msgModelList.indexWhere((element) => element.message.msgId == controller.searchedMsg?.msgId);
          if (index != -1) {
            await _scrollController.scrollToIndex(
              index,
              duration: Durations.short1,
            );
            await _scrollController.highlight(
              index,
              highlightDuration: Durations.long4,
            );
          }
        });
      }

      if (controller.lastActionType == MessageLastActionType.bottomPosition) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (_scrollController.positions.isNotEmpty) {
            _scrollController.jumpTo(0);
          }
        });
      }
    });

    _picker = ImagePicker();
    _player = AudioPlayer();

    controller.fetchItemList();
    controller.sendConversationsReadAck();
    controller.clearMentionIfNeed();
  }

  void needMention() {
    if (controller.conversationType == ConversationType.GroupChat) {
      ChatUIKitRoute.pushOrPushNamed(
        context,
        ChatUIKitRouteNames.groupMentionView,
        GroupMentionViewArguments(
          groupId: controller.profile.id,
          attributes: widget.attributes,
        ),
      ).then((value) {
        if (value != null) {
          if (value == true) {
            inputBarController.atAll();
          } else if (value is ChatUIKitProfile) {
            inputBarController.at(value);
          }
        }
      });
    }
  }

  @override
  void onTyping(List<String> fromUsers) {
    if (fromUsers.contains(controller.profile.id)) {
      updateInputType();
    }
  }

  void updateInputType() {
    if (_typingTimer != null) {
      _typingTimer?.cancel();
      _typingTimer = null;
    }

    _remoteTyping.value = true;
    _typingTimer = Timer(const Duration(seconds: 6), () {
      if (mounted) {
        _remoteTyping.value = false;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _typingTimer?.cancel();
    _typingTimer = null;
    widget.viewObserver?.dispose();
    ChatUIKit.instance.removeObserver(this);
    editBarTextEditingController?.dispose();
    inputBarController.dispose();
    _player.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = MessageListView(
      scrollController: _scrollController,
      forceLeft: widget.forceLeft,
      bubbleContentBuilder: widget.bubbleContentBuilder,
      bubbleBuilder: widget.bubbleBuilder,
      quoteBuilder: widget.quoteBuilder,
      controller: controller,
      showAvatar: widget.showMessageItemAvatar,
      showNickname: widget.showMessageItemNickname,
      onItemTap: (ctx, msg) {
        stopVoice();
        bool? ret = widget.onItemTap?.call(context, msg);
        if (ret != true) {
          bubbleTab(msg);
        }
        return ret;
      },
      onItemLongPress: (context, model) {
        bool? ret = widget.onItemLongPress?.call(context, model);
        stopVoice();
        if (ret != true) {
          onItemLongPress(model);
        }
        return ret;
      },
      onItemDoubleTap: (context, model) {
        bool? ret = widget.onDoubleTap?.call(context, model);
        stopVoice();
        return ret;
      },
      onAvatarTap: (context, model) {
        bool? ret = widget.onAvatarTap?.call(context, model);
        stopVoice();
        if (ret != true) {
          avatarTap(model);
        }
        return ret;
      },
      onAvatarLongPressed: (context, model) {
        bool? ret = widget.onAvatarLongPress?.call(context, model);
        stopVoice();
        if (ret != true) {}
        return ret;
      },
      onNicknameTap: (context, msg) {
        bool? ret = widget.onNicknameTap?.call(context, msg);
        stopVoice();
        if (ret != true) {}
        return ret;
      },
      bubbleStyle: widget.bubbleStyle,
      itemBuilder: widget.itemBuilder ?? itemBuilder,
      alertItemBuilder: widget.alertItemBuilder ?? alertItem,
      onErrorBtnTap: (model) {
        bool ret = widget.onErrorBtnTapHandler?.call(context, model) ?? false;
        if (ret == false) {
          onErrorBtnTap(model);
        }
      },
      onReactionItemTap: (model, reaction) {
        bool? ret = widget.onReactionItemTap?.call(context, model, reaction) ?? false;
        if (ret == false) {
          controller.updateReaction(
            model.message.msgId,
            reaction.reaction,
            !reaction.isAddedBySelf,
          );
        }
      },
      onReactionInfoTap: (context, model) {
        bool ret = widget.onReactionInfoTap?.call(context, model) ?? false;
        if (ret == false) {
          showReactionsInfo(context, model);
        }

        return ret;
      },
      reactionItemsBuilder: widget.reactionItemsBuilder,
      onThreadItemTap: (context, model) {
        bool ret = widget.onThreadItemTap?.call(context, model) ?? false;
        if (ret == false) {
          showThread(context, model);
        }
        return ret;
      },
      threadItemBuilder: widget.threadItemBuilder,
    );

    content = GestureDetector(
      onTap: clearAllType,
      child: content,
    );

    content = Stack(
      children: [
        content,
        Positioned.fill(child: floatingUnreadWidget(theme)),
      ],
    );

    List<Widget> list = [
      Expanded(child: content),
    ];
    if (controller.isMultiSelectMode) {
      list.add(multiSelectBar(theme));
    } else {
      list.add(replyMessageBar(theme));
      widget.inputBar ?? list.add(inputBar(theme));
      list.add(
        AnimatedContainer(
          curve: Curves.linearToEaseOut,
          duration: const Duration(milliseconds: 250),
          height: showEmoji ? 230 : 0,
          child: showEmoji
              ? widget.emojiWidget ??
                  ChatUIKitInputEmojiBar(
                    deleteOnTap: () {
                      inputBarController.deleteTextOnCursor();
                    },
                    emojiClicked: (emoji) {
                      inputBarController.addText(
                        ChatUIKitEmojiData.emojiMap[emoji] ?? emoji,
                      );
                    },
                  )
              : const SizedBox(),
        ),
      );
    }

    content = Column(children: list);
    title = widget.title ??
        (controller.conversationType == ConversationType.GroupChat
            ? controller.profile.showName
            : controller.userMap[controller.profile.id]?.showName);

    content = Scaffold(
      backgroundColor: theme.color.isDark ? theme.color.neutralColor1 : theme.color.neutralColor98,
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                title: title,
                centerTitle: false,
                leading: ChatUIKitAvatar(
                  onTap: () {
                    pushNextPage(widget.profile);
                  },
                  avatarUrl: controller.profile.avatarUrl,
                ),
                trailing: controller.isMultiSelectMode
                    ? InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          controller.disableMultiSelectMode();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 5, 24, 5),
                          child: Text(
                            ChatUIKitLocal.bottomSheetCancel.localString(context),
                            style: TextStyle(
                              color: theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
                              fontWeight: theme.font.labelMedium.fontWeight,
                              fontSize: theme.font.labelMedium.fontSize,
                            ),
                          ),
                        ),
                      )
                    : (controller.conversationType == ConversationType.GroupChat
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: InkWell(
                              onTap: onThreadsViewTap,
                              child: ChatUIKitImageLoader.messageLongPressThread(),
                            ),
                          )
                        : null),
              ),
      body: SafeArea(child: content),
    );

    content = Stack(
      children: [
        content,
        if (editMessage != null)
          // 背景色
          Positioned.fill(
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                editMessage = null;
                messageEditCanSend = false;
                setState(() {});
              },
              child: Opacity(
                opacity: 0.5,
                child: Container(color: Colors.black),
              ),
            ),
          ),
        if (editMessage != null)
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                editMessageBar(theme),
              ],
            ),
          )
      ],
    );

    content = ShareUserData(
      data: controller.userMap,
      child: content,
    );

    content = NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (_scrollController.offset < 20) {
            if (controller.onBottom == false) {
              controller.onBottom = true;
              controller.addAllCacheToList();
            }
          } else {
            if (controller.onBottom == true) {
              controller.onBottom = false;
              controller.lastActionType = MessageLastActionType.originalPosition;
            }
          }
          if (_scrollController.position.maxScrollExtent - _scrollController.offset < 1500) {
            controller.fetchItemList();
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
    return content;
  }

  Widget? itemBuilder(BuildContext context, MessageModel model) {
    controller.sendMessageReadAck(model.message);
    if (model.message.bodyType != MessageType.VOICE) return null;

    Widget content = ChatUIKitMessageListViewMessageItem(
      isPlaying: _playingMessage?.msgId == model.message.msgId,
      onErrorBtnTap: () {
        if (widget.onErrorBtnTapHandler == null) {
          onErrorBtnTap(model);
        } else {
          widget.onErrorBtnTapHandler!.call(context, model);
        }
      },
      enableSelected: controller.isMultiSelectMode
          ? () {
              if (controller.selectedMessages.map((e) => e.msgId).toList().contains(model.message.msgId)) {
                controller.selectedMessages.removeWhere((e) => model.message.msgId == e.msgId);
              } else {
                controller.selectedMessages.add(model.message);
              }
              setState(() {});
            }
          : null,
      bubbleStyle: widget.bubbleStyle,
      key: ValueKey(model.message.localTime),
      showAvatar: widget.showMessageItemAvatar,
      quoteBuilder: widget.quoteBuilder,
      showNickname: widget.showMessageItemNickname,
      onAvatarTap: () {
        if (widget.onAvatarTap == null) {
          avatarTap(model);
        } else {
          widget.onAvatarTap!.call(context, model);
        }
      },
      onAvatarLongPressed: () {
        widget.onAvatarLongPress?.call(context, model);
      },
      onBubbleDoubleTap: () {
        widget.onDoubleTap?.call(context, model);
      },
      onBubbleLongPressed: () {
        bool? ret = widget.onItemLongPress?.call(context, model);
        if (ret != true) {
          onItemLongPress(model);
        }
      },
      onBubbleTap: () {
        bool? ret = widget.onItemTap?.call(context, model);
        if (ret != true) {
          bubbleTab(model);
        }
      },
      onNicknameTap: () {
        widget.onNicknameTap?.call(context, model);
      },
      model: model,
    );

    double zoom = 0.8;
    if (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height) {
      zoom = 0.5;
    }

    content = SizedBox(
      width: MediaQuery.of(context).size.width * zoom,
      child: content,
    );

    content = Align(
      alignment: model.message.direction == MessageDirection.SEND ? Alignment.centerRight : Alignment.centerLeft,
      child: content,
    );

    return content;
  }

  Widget alertItem(
    BuildContext context,
    MessageModel model,
  ) {
    if (model.message.isTimeMessageAlert) {
      Widget? content = widget.alertItemBuilder?.call(
        context,
        model,
      );
      content ??= ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: ChatUIKitTimeFormatter.instance.formatterHandler
                    ?.call(context, ChatUIKitTimeType.message, model.message.serverTime) ??
                ChatUIKitTimeTool.getChatTimeStr(model.message.serverTime, needTime: true),
          )
        ],
      );
      return content;
    }

    if (model.message.isRecallAlert) {
      Map<String, String>? map = (model.message.body as CustomMessageBody).params;
      Widget? content = widget.alertItemBuilder?.call(
        context,
        model,
      );
      String? from = map?[alertRecallMessageFromKey];
      String? showName;
      if (ChatUIKit.instance.currentUserId == from) {
        showName = ChatUIKitLocal.alertYou.localString(context);
      } else {
        if (from?.isNotEmpty == true) {
          ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(ChatUIKitProfile.contact(id: from!));
          showName = profile.showName;
        }
      }

      content ??= ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: '$showName${ChatUIKitLocal.alertRecallInfo.localString(context)}',
          ),
        ],
      );
      return content;
    }

    if (model.message.isCreateGroupAlert) {
      Map<String, String>? map = (model.message.body as CustomMessageBody).params;
      Widget? content = widget.alertItemBuilder?.call(
        context,
        model,
      );
      String? operator = map![alertOperatorKey]!;
      String showName;
      if (ChatUIKit.instance.currentUserId == operator) {
        showName = ChatUIKitLocal.alertYou.localString(context);
      } else {
        ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
          ChatUIKitProfile.contact(id: operator),
        );
        showName = profile.showName;
      }
      content ??= ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: showName,
            onTap: () {
              ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
                ChatUIKitProfile.contact(
                  id: map[alertOperatorKey]!,
                ),
              );
              pushNextPage(profile);
            },
          ),
          MessageAlertAction(text: ChatUIKitLocal.messagesViewAlertGroupInfoTitle.localString(context)),
          MessageAlertAction(
            text: () {
              String? groupId = map[alertOperatorInfoKey];
              if (groupId?.isNotEmpty == true) {
                ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
                  ChatUIKitProfile.group(id: groupId!),
                );
                return profile.showName;
              }
              return '';
            }(),
            onTap: () {
              pushNextPage(profile!);
            },
          ),
        ],
      );
      return content;
    }

    if (model.message.isCreateThreadAlert) {
      Map<String, String>? map = (model.message.body as CustomMessageBody).params;
      Widget? content = widget.alertItemBuilder?.call(
        context,
        model,
      );

      String? operator = map![alertOperatorKey]!;
      String showName;
      if (ChatUIKit.instance.currentUserId == operator) {
        showName = ChatUIKitLocal.alertYou.localString(context);
      } else {
        ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
          ChatUIKitProfile.contact(id: operator),
        );
        showName = profile.showName;
      }
      content ??= ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: showName,
            onTap: () {
              ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
                ChatUIKitProfile.contact(
                  id: map[alertOperatorKey]!,
                ),
              );
              pushNextPage(profile);
            },
          ),
          MessageAlertAction(text: ChatUIKitLocal.messagesViewAlertThreadInfoTitle.localString(context)),
          MessageAlertAction(
            text: map[alertOperatorInfoKey] ?? '',
            onTap: () async {
              String msgId = map[alertThreadInMsgId]!;

              ChatUIKit.instance.loadMessage(messageId: msgId).then((value) {
                if (value != null) {
                  value.chatThread().then((thread) {
                    MessageModel model = MessageModel(message: value, thread: thread);
                    ChatUIKitRoute.pushOrPushNamed(
                      context,
                      ChatUIKitRouteNames.threadMessagesView,
                      ThreadMessagesViewArguments(
                        subtitle: controller.profile.showName,
                        controller: ThreadMessagesViewController(
                          model: model,
                        ),
                        attributes: widget.attributes,
                      ),
                    );
                  });
                }
              });
            },
          ),
        ],
      );
      return content;
    }

    if (model.message.isDestroyGroupAlert) {
      return ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: ChatUIKitLocal.alertDestroy.localString(context),
          ),
        ],
      );
    }

    if (model.message.isLeaveGroupAlert) {
      return ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: ChatUIKitLocal.alertLeave.localString(context),
          ),
        ],
      );
    }

    if (model.message.isKickedGroupAlert) {
      return ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: ChatUIKitLocal.alertKickedInfo.localString(context),
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget replyMessageBar(ChatUIKitTheme theme) {
    if (replyMessage == null) return const SizedBox();
    Widget content = widget.replyBarBuilder?.call(context, replyMessage!) ??
        ChatUIKitReplyBar(
          messageModel: replyMessage!,
          onCancelTap: () {
            replyMessage = null;
            setState(() {});
          },
        );

    content = Stack(
      children: [
        content,
        Transform.translate(
          offset: const Offset(0, -25),
          child: typingWidget(theme),
        ),
      ],
    );

    return content;
  }

  Widget editMessageBar(ChatUIKitTheme theme) {
    Widget content = ChatUIKitInputBar(
      key: const ValueKey('editKey'),
      autofocus: true,
      onChanged: (input) {
        final canSend = input.trim() != editMessage?.textContent && input.isNotEmpty;
        if (messageEditCanSend != canSend) {
          messageEditCanSend = canSend;
          setState(() {});
        }
      },
      inputBarController: editBarTextEditingController!,
      trailing: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          if (!messageEditCanSend) return;
          String text = editBarTextEditingController?.text.trim() ?? '';
          if (text.isNotEmpty) {
            controller.editMessage(editMessage!, text);
            editBarTextEditingController?.clear();
            editMessage = null;
            messageEditCanSend = false;
            setState(() {});
          }
        },
        child: Icon(
          Icons.check_circle,
          size: 30,
          color: theme.color.isDark
              ? messageEditCanSend
                  ? theme.color.primaryColor6
                  : theme.color.neutralColor5
              : messageEditCanSend
                  ? theme.color.primaryColor5
                  : theme.color.neutralColor7,
        ),
      ),
    );

    Widget header = Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: ChatUIKitImageLoader.messageEdit(),
        ),
        const SizedBox(width: 2),
        Text(
          ChatUIKitLocal.messagesViewEditMessageTitle.localString(context),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: theme.font.labelSmall.fontWeight,
              fontSize: theme.font.labelSmall.fontSize,
              color: theme.color.isDark ? theme.color.neutralSpecialColor6 : theme.color.neutralSpecialColor5),
        ),
      ],
    );
    header = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: theme.color.isDark ? theme.color.neutralColor2 : theme.color.neutralColor9),
      child: header,
    );
    content = Column(
      children: [
        typingWidget(theme),
        header,
        content,
      ],
    );

    return content;
  }

  Widget inputBar(ChatUIKitTheme theme) {
    Widget content = ChatUIKitInputBar(
      key: const ValueKey('inputKey'),
      inputBarController: inputBarController,
      leading: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () async {
          showEmoji = false;
          inputBarController.unfocus();
          setState(() {});
          ChatUIKitRecordModel? model = await showChatUIKitRecordBar(
            context: context,
            statusChangeCallback: (type, duration, path) {
              if (type == ChatUIKitVoiceBarStatusType.recording) {
                stopVoice();
              } else if (type == ChatUIKitVoiceBarStatusType.playing) {
                // 播放录音
                previewVoice(true, path: path);
              } else if (type == ChatUIKitVoiceBarStatusType.ready) {
                // 停止播放
                previewVoice(false);
              }
            },
          );
          if (model != null) {
            controller.sendVoiceMessage(model);
          }
        },
        child: ChatUIKitImageLoader.voiceKeyboard(),
      ),
      trailing: SizedBox(
        child: Row(
          children: [
            if (!showEmoji)
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  inputBarController.unfocus();
                  showEmoji = !showEmoji;
                  setState(() {});
                },
                child: ChatUIKitImageLoader.faceKeyboard(),
              ),
            if (showEmoji)
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  showEmoji = !showEmoji;
                  inputBarController.requestFocus();
                  setState(() {});
                },
                child: ChatUIKitImageLoader.textKeyboard(),
              ),
            const SizedBox(width: 8),
            if (showMoreBtn)
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  clearAllType();
                  List<ChatUIKitBottomSheetItem>? items = widget.morePressActions;
                  if (items == null) {
                    items = [];
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: ChatUIKitLocal.messagesViewMoreActionsTitleAlbum.localString(context),
                      icon: ChatUIKitImageLoader.messageViewMoreAlbum(
                        color: theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectImage();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: ChatUIKitLocal.messagesViewMoreActionsTitleVideo.localString(context),
                      icon: ChatUIKitImageLoader.messageViewMoreVideo(
                        color: theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectVideo();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: ChatUIKitLocal.messagesViewMoreActionsTitleCamera.localString(context),
                      icon: ChatUIKitImageLoader.messageViewMoreCamera(
                        color: theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectCamera();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: ChatUIKitLocal.messagesViewMoreActionsTitleFile.localString(context),
                      icon: ChatUIKitImageLoader.messageViewMoreFile(
                        color: theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectFile();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: ChatUIKitLocal.messagesViewMoreActionsTitleContact.localString(context),
                      icon: ChatUIKitImageLoader.messageViewMoreCard(
                        color: theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectCard();
                      },
                    ));
                  }

                  if (widget.onMoreActionsItemsHandler != null) {
                    items = widget.onMoreActionsItemsHandler!.call(
                      context,
                      items,
                    );
                  }
                  if (items != null) {
                    showChatUIKitBottomSheet(context: context, items: items);
                  }
                },
                child: ChatUIKitImageLoader.moreKeyboard(),
              ),
            if (!showMoreBtn)
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  String text = inputBarController.text.trim();
                  if (text.isNotEmpty) {
                    dynamic mention;
                    if (inputBarController.isAtAll && text.contains("@All")) {
                      mention = true;
                    }

                    if (inputBarController.mentionList.isNotEmpty) {
                      List<String> mentionList = [];
                      List<ChatUIKitProfile> list = inputBarController.mentionList;
                      for (var element in list) {
                        if (text.contains('@${element.showName}')) {
                          mentionList.add(element.id);
                        }
                      }
                      mention = mentionList;
                    }

                    controller.sendTextMessage(
                      text,
                      replay: replyMessage?.message,
                      mention: mention,
                    );
                    inputBarController.clearMentions();
                    inputBarController.clear();
                    if (replyMessage != null) {
                      replyMessage = null;
                    }
                    showMoreBtn = true;
                    setState(() {});
                  }
                },
                child: ChatUIKitImageLoader.sendKeyboard(),
              ),
          ],
        ),
      ),
    );

    if (editMessage == null && replyMessage == null) {
      content = Stack(
        children: [
          content,
          Transform.translate(
            offset: const Offset(0, -20),
            child: typingWidget(theme),
          ),
        ],
      );
    }

    return content;
  }

  Widget typingWidget(ChatUIKitTheme theme) {
    return ValueListenableBuilder(
      valueListenable: _remoteTyping,
      builder: (BuildContext context, bool value, Widget? child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          curve: Curves.linearToEaseOut,
          opacity: value ? 1 : 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            color: theme.color.isDark ? theme.color.neutralColor1 : theme.color.neutralColor98,
            child: Row(children: [
              SizedBox(
                width: 16,
                height: 16,
                child: ChatUIKitAvatar(avatarUrl: profile?.avatarUrl),
              ),
              const SizedBox(width: 5),
              Text(
                ChatUIKitLocal.messagesViewTyping.localString(context),
                style: TextStyle(
                    fontWeight: theme.font.bodyExtraSmall.fontWeight,
                    fontSize: theme.font.bodyExtraSmall.fontSize,
                    color: theme.color.isDark ? theme.color.neutralColor6 : theme.color.neutralColor5),
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget multiSelectBar(ChatUIKitTheme theme) {
    Widget content = widget.multiSelectBottomBar ??
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () async {
                if (controller.selectedMessages.isEmpty) {
                  return;
                }
                bool? ret = await showChatUIKitDialog(
                    context: context,
                    items: [
                      ChatUIKitDialogItem.cancel(label: '取消'),
                      ChatUIKitDialogItem.confirm(
                        label: '确认',
                        onTap: () async {
                          Navigator.of(context).pop(true);
                        },
                      )
                    ],
                    title: '删除${controller.selectedMessages.length}条消息?');
                if (ret == true) {
                  controller.deleteSelectedMessages();
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                child: ChatUIKitImageLoader.messageTrash(
                  color: theme.color.isDark ? theme.color.errorColor6 : theme.color.errorColor5,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                forwardMessage(
                  controller.selectedMessages,
                  isMultiSelect: true,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                child: ChatUIKitImageLoader.messageLongPressForward(
                  color: theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
                ),
              ),
            ),
          ],
        );
    return content;
  }

  void clearAllType() {
    bool needUpdate = false;
    if (_player.state == PlayerState.playing) {
      stopVoice();
      needUpdate = true;
    }

    if (inputBarController.hasFocus) {
      inputBarController.unfocus();
      needUpdate = true;
    }

    if (showEmoji) {
      showEmoji = false;
      needUpdate = true;
    }

    if (editMessage != null) {
      editMessage = null;
      messageEditCanSend = false;
      needUpdate = true;
    }

    if (replyMessage != null) {
      replyMessage = null;
      needUpdate = true;
    }
    if (needUpdate) {
      setState(() {});
    }
  }

  void onItemLongPress(MessageModel model) async {
    final theme = ChatUIKitTheme.of(context);
    clearAllType();
    List<ChatUIKitBottomSheetItem>? items = widget.longPressActions;
    items ??= defaultItemLongPressed(model, theme);
    if (items.isEmpty) return;
    if (widget.onItemLongPressHandler != null) {
      items = widget.onItemLongPressHandler!.call(
        context,
        model,
        items,
      );
    }
    if (items != null) {
      showChatUIKitBottomSheet(
        titleWidget: bottomSheetTitle(model, theme),
        context: context,
        items: items,
        showCancel: false,
      );
    }
  }

  void avatarTap(MessageModel model) async {
    ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
      ChatUIKitProfile.contact(id: model.message.from!),
    );

    pushNextPage(profile);
  }

  void bubbleTab(MessageModel model) async {
    if (model.message.bodyType == MessageType.IMAGE) {
      ChatUIKitRoute.pushOrPushNamed(
        context,
        ChatUIKitRouteNames.showImageView,
        ShowImageViewArguments(
          message: model.message,
          attributes: widget.attributes,
        ),
      );
    } else if (model.message.bodyType == MessageType.VIDEO) {
      ChatUIKitRoute.pushOrPushNamed(
        context,
        ChatUIKitRouteNames.showVideoView,
        ShowVideoViewArguments(
          message: model.message,
          attributes: widget.attributes,
        ),
      );
    }

    if (model.message.bodyType == MessageType.VOICE) {
      playVoiceMessage(model.message);
    }

    if (model.message.bodyType == MessageType.COMBINE) {
      ChatUIKitRoute.pushOrPushNamed(
        context,
        ChatUIKitRouteNames.forwardMessagesView,
        ForwardMessagesViewArguments(
          message: model.message,
          attributes: widget.attributes,
        ),
      );
    }

    if (model.message.bodyType == MessageType.CUSTOM && model.message.isCardMessage) {
      String? userId = (model.message.body as CustomMessageBody).params?[cardUserIdKey];
      String avatar = (model.message.body as CustomMessageBody).params?[cardAvatarKey] ?? '';
      String name = (model.message.body as CustomMessageBody).params?[cardNicknameKey] ?? '';
      if (userId?.isNotEmpty == true) {
        ChatUIKitProfile profile = ChatUIKitProfile.contact(id: userId!, avatarUrl: avatar, nickname: name);
        pushNextPage(profile);
      }
    }
  }

  void onErrorBtnTap(MessageModel model) {
    controller.resendMessage(model.message);
  }

  void textMessageEdit(Message message) {
    clearAllType();
    if (message.bodyType != MessageType.TXT) return;
    editMessage = message;
    editBarTextEditingController = ChatUIKitInputBarController(text: editMessage?.textContent ?? "");
    setState(() {});
  }

  void replyMessaged(MessageModel model) {
    // clearAllType();
    // inputBarController.requestFocus();
    replyMessage = model;
    setState(() {});
  }

  void deleteMessage(MessageModel model) async {
    final delete = await showChatUIKitDialog(
      title: ChatUIKitLocal.messagesViewDeleteMessageAlertTitle.localString(context),
      content: ChatUIKitLocal.messagesViewDeleteMessageAlertSubTitle.localString(context),
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal.messagesViewDeleteMessageAlertButtonCancel.localString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: ChatUIKitLocal.messagesViewDeleteMessageAlertButtonConfirm.localString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (delete == true) {
      controller.deleteMessage(model.message.msgId);
    }
  }

  void recallMessage(MessageModel model) async {
    final recall = await showChatUIKitDialog(
      title: ChatUIKitLocal.messagesViewRecallMessageAlertTitle.localString(context),
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal.messagesViewRecallMessageAlertButtonCancel.localString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: ChatUIKitLocal.messagesViewRecallMessageAlertButtonConfirm.localString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (recall == true) {
      try {
        controller.recallMessage(model.message);
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  void selectImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        controller.sendImageMessage(image.path, name: image.name);
      }
    } catch (e) {
      ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.noStoragePermission);
    }
  }

  void selectVideo() async {
    try {
      XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        controller.sendVideoMessage(video.path, name: video.name);
      }
    } catch (e) {
      ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.noStoragePermission);
    }
  }

  void selectCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        controller.sendImageMessage(photo.path, name: photo.name);
      }
    } catch (e) {
      ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.noStoragePermission);
    }
  }

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.single;
      if (file.path?.isNotEmpty == true) {
        controller.sendFileMessage(
          file.path!,
          name: file.name,
          fileSize: file.size,
        );
      }
    }
  }

  void selectCard() async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.95,
          child: SelectContactView(
            backText: ChatUIKitLocal.messagesViewSelectContactCancel.localString(context),
            title: ChatUIKitLocal.messagesViewSelectContactTitle.localString(context),
            onTap: (context, model) {
              showChatUIKitDialog(
                title: ChatUIKitLocal.messagesViewShareContactAlertTitle.localString(context),
                content: ChatUIKitLocal.messagesViewShareContactAlertSubTitle.localString(context),
                context: context,
                items: [
                  ChatUIKitDialogItem.cancel(
                    label: ChatUIKitLocal.messagesViewShareContactAlertButtonCancel.localString(context),
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  ChatUIKitDialogItem.confirm(
                    label: ChatUIKitLocal.messagesViewShareContactAlertButtonConfirm.localString(context),
                    onTap: () async {
                      Navigator.of(context).pop(model);
                    },
                  )
                ],
              ).then((value) {
                if (value != null) {
                  Navigator.of(context).pop();
                  if (value is ContactItemModel) {
                    controller.sendCardMessage(value.profile);
                  }
                }
              });
            },
          ),
        );
      },
    );
  }

  Future<void> playVoiceMessage(Message message) async {
    if (_playingMessage?.msgId == message.msgId) {
      _playingMessage = null;
      await stopVoice();
    } else {
      await stopVoice();
      File file = File(message.localPath!);
      if (!file.existsSync()) {
        await controller.downloadMessage(message);
        ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.messageDownloading);
      } else {
        try {
          controller.playMessage(message);
          await playVoice(message.localPath!);
          _playingMessage = message;
          // ignore: empty_catches
        } catch (e) {
          debugPrint('playVoice: $e');
        }
      }
    }
    setState(() {});
  }

  Future<void> previewVoice(bool play, {String? path}) async {
    if (play) {
      await playVoice(path!);
    } else {
      await stopVoice();
    }
  }

  Future<void> playVoice(String path) async {
    if (_player.state == PlayerState.playing) {
      await _player.stop();
    }

    await _player.play(DeviceFileSource(path));
    _player.onPlayerComplete.first.whenComplete(() async {
      _playingMessage = null;
      setState(() {});
    }).onError((error, stackTrace) {});
  }

  Future<void> stopVoice() async {
    if (_player.state == PlayerState.playing) {
      await _player.stop();
      _playingMessage = null;
      setState(() {});
    }
  }

  void reportMessage(MessageModel model) async {
    Map<String, String> reasons = ChatUIKitSettings.reportMessageReason;
    List<String> reasonKeys = reasons.keys.toList();

    final reportReason = await ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.reportMessageView,
      ReportMessageViewArguments(
        messageId: model.message.msgId,
        reportReasons: reasonKeys.map((e) => reasons[e]!).toList(),
        attributes: widget.attributes,
      ),
    );

    if (reportReason != null && reportReason is String) {
      String? tag;
      for (var entry in reasons.entries) {
        if (entry.value == reportReason) {
          tag = entry.key;
          break;
        }
      }
      if (tag == null) return;
      controller.reportMessage(
        message: model.message,
        tag: tag,
        reason: reportReason,
      );
    }
  }

  void pushNextPage(ChatUIKitProfile profile) async {
    clearAllType();

    // 如果是自己
    if (profile.id == ChatUIKit.instance.currentUserId) {
      pushToCurrentUser(profile);
    }
    // 如果是当前聊天对象
    else if (controller.profile.id == profile.id) {
      // 当前聊天对象是群聊
      if (controller.conversationType == ConversationType.GroupChat) {
        // 跳转下一页，此时需要先从缓存中取得最新的，之后再push
        ChatUIKitProfile? tmpProfile = ChatUIKitProvider.instance.profilesCache[profile.id];
        pushToGroupInfo(tmpProfile ?? profile);
      }
      // 当前聊天对象，是单聊
      else {
        pushCurrentChatter(profile);
      }
    }
    // 以上都不是时，检查通讯录
    else {
      List<String> contacts = await ChatUIKit.instance.getAllContactIds();
      // 是好友，不是当前聊天对象，跳转到好友页面，并可以发消息
      if (contacts.contains(profile.id)) {
        ChatUIKitProfile? tmpProfile = ChatUIKitProvider.instance.profilesCache[profile.id];
        pushNewContactDetail(tmpProfile ?? profile);
      }
      // 不是好友，跳转到添加好友页面
      else {
        pushRequestDetail(profile);
      }
    }
  }

// 处理点击自己头像和点击自己名片
  void pushToCurrentUser(ChatUIKitProfile profile) async {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.currentUserInfoView,
      CurrentUserInfoViewArguments(
        profile: profile,
        attributes: widget.attributes,
      ),
    );
  }

  // 处理当前聊天对象，点击appBar头像，点击对方消息头像，点击名片
  void pushCurrentChatter(ChatUIKitProfile profile) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.contactDetailsView,
      ContactDetailsViewArguments(
        attributes: widget.attributes,
        onMessageDidClear: () {
          replyMessage = null;
          controller.clearMessages();
        },
        profile: profile,
        actions: [
          ChatUIKitModelAction(
            title: ChatUIKitLocal.contactDetailViewSend.localString(context),
            icon: 'assets/images/chat.png',
            iconSize: const Size(32, 32),
            packageName: ChatUIKitImageLoader.packageName,
            onTap: (context) {
              Navigator.of(context).pop();
            },
          ),
          ChatUIKitModelAction(
            title: ChatUIKitLocal.contactDetailViewSearch.localString(context),
            icon: 'assets/images/search_history.png',
            packageName: ChatUIKitImageLoader.packageName,
            iconSize: const Size(32, 32),
            onTap: (context) {
              ChatUIKitRoute.pushOrPushNamed(
                context,
                ChatUIKitRouteNames.searchHistoryView,
                SearchHistoryViewArguments(
                  profile: profile,
                  attributes: widget.attributes,
                ),
              ).then((value) {
                if (value != null && value is Message) {
                  int count = 0;
                  Navigator.of(context).popUntil((route) {
                    count++;
                    if (count == 2) return true;
                    return route.settings.name == ChatUIKitRouteNames.messagesView || route.isFirst;
                  });
                  controller.jumpToSearchedMessage(value);
                }
              });
            },
          ),
        ],
      ),
    ).then((value) {
      controller.updateView();
    });
  }

  // 处理当前聊天对象是群时
  void pushToGroupInfo(ChatUIKitProfile profile) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.groupDetailsView,
      GroupDetailsViewArguments(
        profile: profile,
        attributes: widget.attributes,
        onMessageDidClear: () {
          replyMessage = null;
          controller.clearMessages();
        },
        actions: [
          ChatUIKitModelAction(
            title: ChatUIKitLocal.groupDetailViewSend.localString(context),
            icon: 'assets/images/chat.png',
            iconSize: const Size(32, 32),
            packageName: ChatUIKitImageLoader.packageName,
            onTap: (context) {
              Navigator.of(context).pop();
            },
          ),
          ChatUIKitModelAction(
            title: ChatUIKitLocal.contactDetailViewSearch.localString(context),
            icon: 'assets/images/search_history.png',
            packageName: ChatUIKitImageLoader.packageName,
            iconSize: const Size(32, 32),
            onTap: (context) {
              ChatUIKitRoute.pushOrPushNamed(
                context,
                ChatUIKitRouteNames.searchHistoryView,
                SearchHistoryViewArguments(
                  profile: profile,
                  attributes: widget.attributes,
                ),
              ).then((value) {
                if (value != null && value is Message) {
                  ChatUIKitRoute.pushOrPushNamed(
                    context,
                    ChatUIKitRouteNames.messagesView,
                    MessagesViewArguments(
                      profile: profile,
                      attributes: widget.attributes,
                      controller: MessageListViewController(
                        profile: profile,
                        searchedMsg: value,
                      ),
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
    ).then((value) {
      controller.updateView();
    });
  }

  // 处理不是当前聊天对象的好友
  void pushNewContactDetail(ChatUIKitProfile profile) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.contactDetailsView,
      ContactDetailsViewArguments(
        profile: profile,
        attributes: widget.attributes,
        actions: [
          ChatUIKitModelAction(
            title: ChatUIKitLocal.contactDetailViewSend.localString(context),
            icon: 'assets/images/chat.png',
            packageName: ChatUIKitImageLoader.packageName,
            onTap: (ctx) {
              Navigator.of(context).pushNamed(
                ChatUIKitRouteNames.messagesView,
                arguments: MessagesViewArguments(
                  profile: profile,
                  attributes: widget.attributes,
                ),
              );
            },
          ),
          ChatUIKitModelAction(
            title: ChatUIKitLocal.contactDetailViewSearch.localString(context),
            icon: 'assets/images/search_history.png',
            packageName: ChatUIKitImageLoader.packageName,
            iconSize: const Size(32, 32),
            onTap: (context) {
              ChatUIKitRoute.pushOrPushNamed(
                context,
                ChatUIKitRouteNames.searchHistoryView,
                SearchHistoryViewArguments(
                  profile: profile,
                  attributes: widget.attributes,
                ),
              ).then((value) {
                if (value != null && value is Message) {
                  ChatUIKitRoute.pushOrPushNamed(
                    context,
                    ChatUIKitRouteNames.messagesView,
                    MessagesViewArguments(
                      profile: profile,
                      attributes: widget.attributes,
                      controller: MessageListViewController(
                        profile: profile,
                        searchedMsg: value,
                      ),
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
    ).then((value) {
      controller.updateView();
    });
  }

  // 处理名片信息非好友
  void pushRequestDetail(ChatUIKitProfile profile) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.newRequestDetailsView,
      NewRequestDetailsViewArguments(
        profile: profile,
        attributes: widget.attributes,
      ),
    );
  }

  List<ChatUIKitBottomSheetItem> defaultItemLongPressed(MessageModel model, ChatUIKitTheme theme) {
    List<ChatUIKitBottomSheetItem> items = [];
    for (var element in ChatUIKitSettings.msgItemLongPressActions) {
      // 复制
      if (model.message.bodyType == MessageType.TXT && element == MessageLongPressActionType.copy) {
        items.add(ChatUIKitBottomSheetItem.normal(
          label: ChatUIKitLocal.messagesViewLongPressActionsTitleCopy.localString(context),
          style: TextStyle(
            color: theme.color.isDark ? theme.color.neutralColor98 : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          icon: ChatUIKitImageLoader.messageLongPressCopy(
            color: theme.color.isDark ? theme.color.neutralColor7 : theme.color.neutralColor3,
          ),
          onTap: () async {
            Clipboard.setData(ClipboardData(text: model.message.textContent));
            ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.messageCopied);
            Navigator.of(context).pop();
          },
        ));
      }

      // 回复
      if (model.message.status == MessageStatus.SUCCESS && element == MessageLongPressActionType.reply) {
        items.add(ChatUIKitBottomSheetItem.normal(
          icon: ChatUIKitImageLoader.messageLongPressReply(
            color: theme.color.isDark ? theme.color.neutralColor7 : theme.color.neutralColor3,
          ),
          style: TextStyle(
            color: theme.color.isDark ? theme.color.neutralColor98 : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          label: ChatUIKitLocal.messagesViewLongPressActionsTitleReply.localString(context),
          onTap: () async {
            Navigator.of(context).pop();
            replyMessaged(model);
          },
        ));
      }
      // 转发
      if (model.message.status == MessageStatus.SUCCESS && element == MessageLongPressActionType.forward) {
        items.add(ChatUIKitBottomSheetItem.normal(
          icon: ChatUIKitImageLoader.messageLongPressForward(
            color: theme.color.isDark ? theme.color.neutralColor7 : theme.color.neutralColor3,
          ),
          style: TextStyle(
            color: theme.color.isDark ? theme.color.neutralColor98 : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          label: ChatUIKitLocal.forwardMessage.localString(context),
          onTap: () async {
            Navigator.of(context).pop();
            forwardMessage(
              [model.message],
              isMultiSelect: false,
            );
          },
        ));
      }

      // 多选
      if (model.message.status == MessageStatus.SUCCESS && element == MessageLongPressActionType.multiSelect) {
        items.add(ChatUIKitBottomSheetItem.normal(
          icon: ChatUIKitImageLoader.messageLongPressMultiSelected(
            color: theme.color.isDark ? theme.color.neutralColor7 : theme.color.neutralColor3,
          ),
          style: TextStyle(
            color: theme.color.isDark ? theme.color.neutralColor98 : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          label: ChatUIKitLocal.messageListLongPressMenuMulti.localString(context),
          onTap: () async {
            Navigator.of(context).pop();
            controller.enableMultiSelectMode();
          },
        ));
      }

      // 翻译
      if (model.message.status == MessageStatus.SUCCESS &&
          model.message.bodyType == MessageType.TXT &&
          element == MessageLongPressActionType.translate &&
          ChatUIKitSettings.enableTranslation) {
        items.add(ChatUIKitBottomSheetItem.normal(
          icon: ChatUIKitImageLoader.messageLongPressTranslate(
            color: theme.color.isDark ? theme.color.neutralColor7 : theme.color.neutralColor3,
          ),
          style: TextStyle(
            color: theme.color.isDark ? theme.color.neutralColor98 : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          label: model.message.hasTranslate
              ? ChatUIKitLocal.messageListLongPressMenuTranslateOrigin.localString(context)
              : ChatUIKitLocal.messageListLongPressMenuTranslate.localString(context),
          onTap: () async {
            Navigator.of(context).pop();
            controller.translateMessage(
              model.message,
              showTranslate: !model.message.hasTranslate,
            );
          },
        ));
      }

      // 创建话题
      if (model.message.status == MessageStatus.SUCCESS &&
          model.message.chatType == ChatType.GroupChat &&
          element == MessageLongPressActionType.thread &&
          model.thread == null &&
          ChatUIKitSettings.enableThread) {
        items.add(ChatUIKitBottomSheetItem.normal(
          label: ChatUIKitLocal.messageListLongPressMenuCreateThread.localString(context),
          icon: ChatUIKitImageLoader.messageLongPressThread(
            color: theme.color.isDark ? theme.color.neutralColor7 : theme.color.neutralColor3,
          ),
          style: TextStyle(
            color: theme.color.isDark ? theme.color.neutralColor98 : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          onTap: () async {
            Navigator.of(context).pop();
            ChatUIKitRoute.pushOrPushNamed(
              context,
              ChatUIKitRouteNames.threadMessagesView,
              ThreadMessagesViewArguments(
                controller: ThreadMessagesViewController(model: model),
                title: model.message.showInfoTranslate(
                  context,
                  needShowName: false,
                ),
                subtitle: widget.title,
                attributes: widget.attributes,
              ),
            );
          },
        ));
      }

      // 编辑
      if (model.message.bodyType == MessageType.TXT &&
          model.message.direction == MessageDirection.SEND &&
          element == MessageLongPressActionType.edit) {
        items.add(ChatUIKitBottomSheetItem.normal(
          label: ChatUIKitLocal.messagesViewLongPressActionsTitleEdit.localString(context),
          style: TextStyle(
            color: theme.color.isDark ? theme.color.neutralColor98 : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          icon: ChatUIKitImageLoader.messageLongPressEdit(
            color: theme.color.isDark ? theme.color.neutralColor7 : theme.color.neutralColor3,
          ),
          onTap: () async {
            Navigator.of(context).pop();
            textMessageEdit(model.message);
          },
        ));
      }

      if (element == MessageLongPressActionType.report) {
        // 举报
        items.add(ChatUIKitBottomSheetItem.normal(
          label: ChatUIKitLocal.messagesViewLongPressActionsTitleReport.localString(context),
          style: TextStyle(
            color: theme.color.isDark ? theme.color.neutralColor98 : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          icon: ChatUIKitImageLoader.messageLongPressReport(
            color: theme.color.isDark ? theme.color.neutralColor7 : theme.color.neutralColor3,
          ),
          onTap: () async {
            Navigator.of(context).pop();
            reportMessage(model);
          },
        ));
      }
      if (element == MessageLongPressActionType.delete) {
        // 删除
        items.add(ChatUIKitBottomSheetItem.normal(
          label: ChatUIKitLocal.messagesViewLongPressActionsTitleDelete.localString(context),
          style: TextStyle(
            color: theme.color.isDark ? theme.color.neutralColor98 : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          icon: ChatUIKitImageLoader.messageLongPressDelete(
            color: theme.color.isDark ? theme.color.neutralColor7 : theme.color.neutralColor3,
          ),
          onTap: () async {
            Navigator.of(context).pop();
            deleteMessage(model);
          },
        ));
      }

      // 撤回
      if (model.message.direction == MessageDirection.SEND &&
          model.message.serverTime >=
              DateTime.now().millisecondsSinceEpoch - ChatUIKitSettings.recallExpandTime * 1000 &&
          element == MessageLongPressActionType.recall) {
        items.add(ChatUIKitBottomSheetItem.normal(
          label: ChatUIKitLocal.messagesViewLongPressActionsTitleRecall.localString(context),
          style: TextStyle(
            color: theme.color.isDark ? theme.color.neutralColor98 : theme.color.neutralColor1,
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
          ),
          icon: ChatUIKitImageLoader.messageLongPressRecall(
            color: theme.color.isDark ? theme.color.neutralColor7 : theme.color.neutralColor3,
          ),
          onTap: () async {
            Navigator.of(context).pop();
            recallMessage(model);
          },
        ));
      }
    }

    return items;
  }

  void attemptSendInputType() {
    controller.attemptSendInputType();
  }

  void forwardMessage(List<Message> message, {bool isMultiSelect = false}) {
    clearAllType();
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.forwardMessageSelectView,
      ForwardMessageSelectViewArguments(
        messages: message,
        isMulti: isMultiSelect,
        attributes: widget.attributes,
      ),
    ).then((value) {
      if (value == true) {
        controller.disableMultiSelectMode();
      }
    });
  }

  Widget? bottomSheetTitle(MessageModel model, ChatUIKitTheme theme) {
    if (ChatUIKitSettings.msgItemLongPressActions.contains(MessageLongPressActionType.reaction) == false ||
        ChatUIKitSettings.enableReaction == false) return null;
    List<MessageReaction>? reactions = model.reactions;
    return Padding(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          int maxCount = width ~/ (36 + 12) - 1;
          List<Widget> items = [];
          for (var i = 0; i < min(ChatUIKitSettings.favoriteReaction.length, maxCount); i++) {
            String emoji = ChatUIKitSettings.favoriteReaction[i];
            bool highlight = reactions?.any((element) {
                  return element.reaction == emoji && element.isAddedBySelf;
                }) ??
                false;

            items.add(
              InkWell(
                onTap: () {
                  onReactionTap(model, emoji, !highlight);
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: highlight
                        ? (theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(3.6),
                  width: 36,
                  height: 36,
                  child: Image.asset(
                    ChatUIKitEmojiData.getEmojiImagePath(emoji)!,
                    package: ChatUIKitEmojiData.packageName,
                  ),
                ),
              ),
            );
          }

          items.add(
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                showAllReactionEmojis(model, theme);
              },
              child: ChatUIKitImageLoader.moreReactions(width: 36, height: 36),
            ),
          );
          bool full = ChatUIKitSettings.favoriteReaction.length + 1 < maxCount;
          return Row(
            mainAxisAlignment: full ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
            children: full
                ? items
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: e,
                        ))
                    .toList()
                : items.toList(),
          );
        },
      ),
    );
  }

  Future onReactionTap(MessageModel model, String emoji, bool isAdd) async {
    await controller.updateReaction(model.message.msgId, emoji, isAdd);
  }

  void onThreadsViewTap() {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.threadsView,
      ThreadsViewArguments(
        profile: controller.profile,
        attributes: widget.attributes,
      ),
    );
  }

  void showAllReactionEmojis(MessageModel model, ChatUIKitTheme theme) {
    showChatUIKitBottomSheet(
      context: context,
      showCancel: false,
      body: ChatUIKitInputEmojiBar(
        selectedEmojis: model.reactions?.where((e) => e.isAddedBySelf == true).map((e) => e.reaction).toList(),
        selectedColor: theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
        emojiClicked: (emojiPath) async {
          var emoji = ChatUIKitEmojiData.getEmoji(emojiPath);
          bool needAdd = false;
          if (model.reactions == null) {
            needAdd = true;
          } else {
            needAdd =
                model.reactions?.indexWhere((element) => element.reaction == emoji && element.isAddedBySelf) == -1;
          }

          Navigator.of(context).pop();
          await controller.updateReaction(model.message.msgId, ChatUIKitEmojiData.emojiMap[emojiPath]!, needAdd);
        },
      ),
    );
  }

  void showReactionsInfo(BuildContext context, MessageModel model) {
    showChatUIKitBottomSheet(
      context: context,
      showCancel: false,
      body: ChatUIKitMessageReactionInfo(model),
    );
  }

  void showThread(BuildContext context, MessageModel model) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.threadMessagesView,
      ThreadMessagesViewArguments(
        controller: ThreadMessagesViewController(model: model),
        subtitle: title,
        title: model.thread?.threadName ??
            model.message.showInfoTranslate(
              context,
              needShowName: true,
            ),
        attributes: widget.attributes,
      ),
    );
  }

  Widget floatingUnreadWidget(ChatUIKitTheme theme) {
    if (controller.cacheMessages.isEmpty) return const SizedBox();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton.icon(
          onPressed: () {
            controller.addAllCacheToList();
          },
          icon: const Icon(Icons.arrow_downward),
          label: Text(
            "${controller.cacheMessages.length} 条未读消息",
            style: TextStyle(
              color: theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
              fontWeight: theme.font.labelMedium.fontWeight,
              fontSize: theme.font.labelMedium.fontSize,
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            backgroundColor: MaterialStateProperty.all(
              theme.color.isDark ? theme.color.neutralColor2 : theme.color.neutralColor98,
            ),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            elevation: MaterialStateProperty.all(0),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(
              theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
            ),
            side: MaterialStatePropertyAll<BorderSide>(
              BorderSide(
                color: theme.color.isDark ? theme.color.neutralColor3 : theme.color.neutralColor9,
              ),
            ),
            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
