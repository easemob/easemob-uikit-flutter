import 'dart:async';
import 'dart:io';
import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/ui/custom/chat_uikit_emoji_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../universal/defines.dart';

typedef MessagesViewItemLongPressHandler = List<ChatUIKitBottomSheetItem>?
    Function(
  BuildContext context,
  Message message,
  List<ChatUIKitBottomSheetItem> defaultActions,
);

typedef MessageItemTapHandler = bool? Function(
    BuildContext context, Message message);

typedef MessagesViewMorePressHandler = List<ChatUIKitBottomSheetItem>? Function(
  BuildContext context,
  List<ChatUIKitBottomSheetItem> defaultActions,
);

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
        focusNode = arguments.focusNode,
        bubbleStyle = arguments.bubbleStyle,
        emojiWidget = arguments.emojiWidget,
        itemBuilder = arguments.itemBuilder,
        alertItemBuilder = arguments.alertItemBuilder,
        onAvatarLongPress = arguments.onAvatarLongPress,
        morePressActions = arguments.morePressActions,
        longPressActions = arguments.longPressActions,
        replyBarBuilder = arguments.replyBarBuilder,
        quoteBuilder = arguments.quoteBuilder,
        onErrorTapHandler = arguments.onErrorTapHandler,
        bubbleBuilder = arguments.bubbleBuilder,
        enableAppBar = arguments.enableAppBar,
        onMoreActionsItemsHandler = arguments.onMoreActionsItemsHandler,
        onItemLongPressHandler = arguments.onItemLongPressHandler,
        bubbleContentBuilder = arguments.bubbleContentBuilder,
        inputBarTextEditingController = arguments.inputBarTextEditingController,
        forceLeft = arguments.forceLeft,
        multiSelectBottomBar = arguments.multiSelectBottomBar,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes;

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
    this.focusNode,
    this.emojiWidget,
    this.itemBuilder,
    this.alertItemBuilder,
    this.bubbleStyle = ChatUIKitMessageListViewBubbleStyle.arrow,
    this.longPressActions,
    this.morePressActions,
    this.replyBarBuilder,
    this.quoteBuilder,
    this.onErrorTapHandler,
    this.bubbleBuilder,
    this.bubbleContentBuilder,
    this.onMoreActionsItemsHandler,
    this.onItemLongPressHandler,
    this.forceLeft,
    this.inputBarTextEditingController,
    this.multiSelectBottomBar,
    this.viewObserver,
    this.attributes,
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

  /// View 附加属性，设置后的内容将会带入到下一个页面。
  final String? attributes;

  /// 多选时显示的 bottom bar
  final Widget? multiSelectBottomBar;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView>
    with ChatUIKitProviderObserver, ChatObserver {
  late final MessageListViewController controller;
  late final CustomTextEditingController inputBarTextEditingController;
  late final ImagePicker _picker;
  late final AudioPlayer _player;
  late final FocusNode focusNode;
  bool showEmoji = false;
  bool showMoreBtn = true;

  bool messageEditCanSend = false;
  TextEditingController? editBarTextEditingController;
  Message? editMessage;
  Message? replyMessage;
  ChatUIKitProfile? profile;
  Message? _playingMessage;
  final ValueNotifier<bool> _remoteTyping = ValueNotifier(false);
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    profile = widget.profile;
    ChatUIKitProvider.instance.addObserver(this);
    ChatUIKit.instance.addObserver(this);
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
    inputBarTextEditingController =
        widget.inputBarTextEditingController ?? CustomTextEditingController();
    inputBarTextEditingController.addListener(() {
      attemptSendInputType();
      if (showMoreBtn !=
          !inputBarTextEditingController.text.trim().isNotEmpty) {
        showMoreBtn = !inputBarTextEditingController.text.trim().isNotEmpty;
        setState(() {});
      }
      if (inputBarTextEditingController.needMention) {
        if (profile?.type == ChatUIKitProfileType.group) {
          needMention();
        }
      }
    });

    controller =
        widget.controller ?? MessageListViewController(profile: profile!);
    controller.addListener(() {
      setState(() {});
    });
    focusNode = widget.focusNode ?? FocusNode();
    _picker = ImagePicker();
    _player = AudioPlayer();
    focusNode.addListener(() {
      if (editMessage != null) return;
      if (focusNode.hasFocus) {
        showEmoji = false;
        setState(() {});
      }
    });
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
            inputBarTextEditingController.atAll();
          } else if (value is ChatUIKitProfile) {
            inputBarTextEditingController.addUser(value);
          }
        }
      });
    }
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {
    if (map.keys.contains(controller.profile.id)) {
      controller.profile = map[controller.profile.id]!;
      profile = map[controller.profile.id]!;
      setState(() {});
    }
  }

  @override
  void onCurrentUserDataUpdate(
    UserData? userData,
  ) {}

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
    _typingTimer?.cancel();
    _typingTimer = null;
    widget.viewObserver?.dispose();
    ChatUIKitProvider.instance.removeObserver(this);
    ChatUIKit.instance.removeObserver(this);
    editBarTextEditingController?.dispose();
    inputBarTextEditingController.dispose();
    _player.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = MessageListView(
      forceLeft: widget.forceLeft,
      bubbleContentBuilder: widget.bubbleContentBuilder,
      bubbleBuilder: widget.bubbleBuilder,
      quoteBuilder: widget.quoteBuilder,
      profile: profile!,
      controller: controller,
      showAvatar: widget.showMessageItemAvatar,
      showNickname: widget.showMessageItemNickname,
      onItemTap: (ctx, msg) async {
        bool? ret = widget.onItemTap?.call(context, msg);
        await stopVoice();
        if (ret != true) {
          bubbleTab(msg);
        }
      },
      onItemLongPress: (context, msg) async {
        bool? ret = widget.onItemLongPress?.call(context, msg);
        stopVoice();
        if (ret != true) {
          onItemLongPress(msg);
        }
      },
      onDoubleTap: (context, msg) async {
        bool? ret = widget.onDoubleTap?.call(context, msg);
        stopVoice();
        if (ret != true) {}
      },
      onAvatarTap: (context, msg) async {
        bool? ret = widget.onAvatarTap?.call(context, msg);
        stopVoice();
        if (ret != true) {
          avatarTap(msg);
        }
      },
      onAvatarLongPressed: (context, msg) async {
        bool? ret = widget.onAvatarLongPress?.call(context, msg);
        stopVoice();
        if (ret != true) {}
      },
      onNicknameTap: (context, msg) async {
        bool? ret = widget.onNicknameTap?.call(context, msg);
        stopVoice();
        if (ret != true) {}
      },
      bubbleStyle: widget.bubbleStyle,
      itemBuilder: widget.itemBuilder ?? voiceItemBuilder,
      alertItemBuilder: widget.alertItemBuilder ?? alertItem,
      onErrorTap: (message) {
        bool ret = widget.onErrorTapHandler?.call(context, message) ?? false;
        if (ret == false) {
          onErrorTap(message);
        }
      },
    );

    content = GestureDetector(
      onTap: () {
        clearAllType();
      },
      child: content,
    );

    List<Widget> list = [Expanded(child: content)];
    if (controller.isMultiSelectMode) {
      list.add(multiSelectBar(theme));
    } else {
      if (replyMessage != null) list.add(replyMessageBar(theme));
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
                      inputBarTextEditingController.deleteTextOnCursor();
                    },
                    emojiClicked: (emoji) {
                      final index =
                          ChatUIKitEmojiData.emojiImagePaths.indexWhere(
                        (element) => element == emoji,
                      );
                      if (index != -1) {
                        inputBarTextEditingController.addText(
                          ChatUIKitEmojiData.emojiList[index],
                        );
                      }
                    },
                  )
              : const SizedBox(),
        ),
      );
    }

    content = Column(children: list);

    content = SafeArea(
      child: content,
    );

    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                title: widget.title ?? profile!.showName,
                centerTitle: false,
                leading: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    pushNextPage(widget.profile);
                  },
                  child: ChatUIKitAvatar(
                    avatarUrl: widget.profile.avatarUrl,
                  ),
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
                            '取消',
                            style: TextStyle(
                              color: theme.color.isDark
                                  ? theme.color.primaryColor6
                                  : theme.color.primaryColor5,
                              fontWeight: theme.font.labelMedium.fontWeight,
                              fontSize: theme.font.labelMedium.fontSize,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
      // body: content,
      body: content,
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
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                editMessageBar(theme),
              ],
            ),
          )
      ],
    );

    return content;
  }

  Widget? voiceItemBuilder(BuildContext context, Message message) {
    if (message.bodyType != MessageType.VOICE) return null;

    Widget content = ChatUIKitMessageListViewMessageItem(
      isPlaying: _playingMessage?.msgId == message.msgId,
      onErrorTap: () {
        if (widget.onErrorTapHandler == null) {
          onErrorTap(message);
        } else {
          widget.onErrorTapHandler!.call(context, message);
        }
      },
      bubbleStyle: widget.bubbleStyle,
      key: ValueKey(message.localTime),
      showAvatar: widget.showMessageItemAvatar,
      quoteBuilder: widget.quoteBuilder,
      showNickname: widget.showMessageItemNickname,
      onAvatarTap: () {
        if (widget.onAvatarTap == null) {
          avatarTap(message);
        } else {
          widget.onAvatarTap!.call(context, message);
        }
      },
      onAvatarLongPressed: () {
        widget.onAvatarLongPress?.call(context, message);
      },
      onBubbleDoubleTap: () {
        widget.onDoubleTap?.call(context, message);
      },
      onBubbleLongPressed: () {
        bool? ret = widget.onItemLongPress?.call(context, message);
        if (ret != true) {
          onItemLongPress(message);
        }
      },
      onBubbleTap: () {
        bool? ret = widget.onItemTap?.call(context, message);
        if (ret != true) {
          bubbleTab(message);
        }
      },
      onNicknameTap: () {
        widget.onNicknameTap?.call(context, message);
      },
      message: message,
    );

    double zoom = 0.8;
    if (MediaQuery.of(context).size.width >
        MediaQuery.of(context).size.height) {
      zoom = 0.5;
    }

    content = SizedBox(
      width: MediaQuery.of(context).size.width * zoom,
      child: content,
    );

    content = Align(
      alignment: message.direction == MessageDirection.SEND
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: content,
    );

    return content;
  }

  Widget alertItem(
    BuildContext context,
    Message message,
  ) {
    if (message.isTimeMessageAlert) {
      Widget? content = widget.alertItemBuilder?.call(
        context,
        message,
      );
      content ??= ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: ChatUIKitTimeFormatter.instance.formatterHandler?.call(
                    context, ChatUIKitTimeType.message, message.serverTime) ??
                ChatUIKitTimeTool.getChatTimeStr(message.serverTime,
                    needTime: true),
          )
        ],
      );
      return content;
    }

    if (message.isRecallAlert) {
      Map<String, String>? map = (message.body as CustomMessageBody).params;
      Widget? content = widget.alertItemBuilder?.call(
        context,
        message,
      );
      String? from = map?[alertRecallMessageFromKey];
      String? showName;
      if (ChatUIKit.instance.currentUserId == from) {
        showName = ChatUIKitLocal.messagesViewRecallInfoYou.getString(context);
      } else {
        if (from?.isNotEmpty == true) {
          ChatUIKitProfile profile = ChatUIKitProvider.instance
              .getProfile(ChatUIKitProfile.contact(id: from!));
          showName = profile.showName;
        }
      }

      content ??= ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text:
                '$showName${ChatUIKitLocal.messagesViewRecallInfo.getString(context)}',
          ),
        ],
      );
      return content;
    }

    if (message.isCreateGroupAlert) {
      Map<String, String>? map = (message.body as CustomMessageBody).params;
      Widget? content = widget.alertItemBuilder?.call(
        context,
        message,
      );
      content ??= ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: map?[alertCreateGroupMessageOwnerKey] ?? '',
            onTap: () {
              ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
                ChatUIKitProfile.contact(
                  id: map![alertCreateGroupMessageOwnerKey]!,
                ),
              );
              pushNextPage(profile);
            },
          ),
          MessageAlertAction(
              text:
                  ' ${ChatUIKitLocal.messagesViewAlertGroupInfoTitle.getString(context)} '),
          MessageAlertAction(
            text: () {
              String? groupId = map?[alertCreateGroupMessageGroupNameKey];
              if (groupId?.isNotEmpty == true) {
                ChatUIKitProfile profile =
                    ChatUIKitProvider.instance.getProfile(
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

    if (message.isDestroyGroupAlert) {
      return ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text:
                ChatUIKitLocal.messagesViewGroupDestroyInfo.getString(context),
          ),
        ],
      );
    }

    if (message.isLeaveGroupAlert) {
      return ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: ChatUIKitLocal.messagesViewGroupLeaveInfo.getString(context),
          ),
        ],
      );
    }

    if (message.isKickedGroupAlert) {
      return ChatUIKitMessageListViewAlertItem(
        infos: [
          MessageAlertAction(
            text: ChatUIKitLocal.messagesViewGroupKickedInfo.getString(context),
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget replyMessageBar(ChatUIKitTheme theme) {
    Widget content = widget.replyBarBuilder?.call(context, replyMessage!) ??
        ChatUIKitReplyBar(
          message: replyMessage!,
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
        final canSend =
            input.trim() != editMessage?.textContent && input.isNotEmpty;
        if (messageEditCanSend != canSend) {
          messageEditCanSend = canSend;
          setState(() {});
        }
      },
      textEditingController: editBarTextEditingController!,
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
          ChatUIKitLocal.messagesViewEditMessageTitle.getString(context),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: theme.font.labelSmall.fontWeight,
              fontSize: theme.font.labelSmall.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralSpecialColor6
                  : theme.color.neutralSpecialColor5),
        ),
      ],
    );
    header = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
          color: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor9),
      child: header,
    );
    content = Column(
      children: [
        typingWidget(theme),
        header,
        content,
      ],
    );

    // content = SafeArea(child: content);

    return content;
  }

  Widget inputBar(ChatUIKitTheme theme) {
    Widget content = ChatUIKitInputBar(
      key: const ValueKey('inputKey'),
      focusNode: focusNode,
      textEditingController: inputBarTextEditingController,
      leading: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () async {
          showEmoji = false;
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
                  focusNode.unfocus();
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
                  focusNode.requestFocus();
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
                  List<ChatUIKitBottomSheetItem>? items =
                      widget.morePressActions;
                  if (items == null) {
                    items = [];
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: ChatUIKitLocal.messagesViewMoreActionsTitleAlbum
                          .getString(context),
                      icon: ChatUIKitImageLoader.messageViewMoreAlbum(
                        color: theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectImage();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: ChatUIKitLocal.messagesViewMoreActionsTitleVideo
                          .getString(context),
                      icon: ChatUIKitImageLoader.messageViewMoreVideo(
                        color: theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectVideo();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: ChatUIKitLocal.messagesViewMoreActionsTitleCamera
                          .getString(context),
                      icon: ChatUIKitImageLoader.messageViewMoreCamera(
                        color: theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectCamera();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: ChatUIKitLocal.messagesViewMoreActionsTitleFile
                          .getString(context),
                      icon: ChatUIKitImageLoader.messageViewMoreFile(
                        color: theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        selectFile();
                      },
                    ));
                    items.add(ChatUIKitBottomSheetItem.normal(
                      label: ChatUIKitLocal.messagesViewMoreActionsTitleContact
                          .getString(context),
                      icon: ChatUIKitImageLoader.messageViewMoreCard(
                        color: theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5,
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
                  String text = inputBarTextEditingController.text.trim();
                  if (text.isNotEmpty) {
                    dynamic mention;
                    if (inputBarTextEditingController.isAtAll &&
                        text.contains("@All")) {
                      mention = true;
                    }

                    if (inputBarTextEditingController.mentionList.isNotEmpty) {
                      List<String> mentionList = [];
                      List<ChatUIKitProfile> list =
                          inputBarTextEditingController.getMentionList();
                      for (var element in list) {
                        if (text.contains('@${element.showName}')) {
                          mentionList.add(element.id);
                        }
                      }
                      mention = mentionList;
                    }

                    controller.sendTextMessage(
                      text,
                      replay: replyMessage,
                      mention: mention,
                    );
                    inputBarTextEditingController.clearMentions();
                    inputBarTextEditingController.clear();
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
            color: theme.color.isDark
                ? theme.color.neutralColor1
                : theme.color.neutralColor98,
            child: Row(children: [
              SizedBox(
                width: 16,
                height: 16,
                child: ChatUIKitAvatar(avatarUrl: profile?.avatarUrl),
              ),
              const SizedBox(width: 5),
              Text(
                '对方正在输入...',
                style: TextStyle(
                    fontWeight: theme.font.bodyExtraSmall.fontWeight,
                    fontSize: theme.font.bodyExtraSmall.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralColor6
                        : theme.color.neutralColor5),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                child: ChatUIKitImageLoader.messageTrash(
                  color: theme.color.isDark
                      ? theme.color.errorColor6
                      : theme.color.errorColor5,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                child: ChatUIKitImageLoader.messageLongPressForward(
                  color: theme.color.isDark
                      ? theme.color.primaryColor6
                      : theme.color.primaryColor5,
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

    if (focusNode.hasFocus) {
      focusNode.unfocus();
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

  void onItemLongPress(Message message) {
    final theme = ChatUIKitTheme.of(context);
    clearAllType();
    List<ChatUIKitBottomSheetItem>? items = widget.longPressActions;
    items ??= defaultItemLongPressed(message, theme);

    if (widget.onItemLongPressHandler != null) {
      items = widget.onItemLongPressHandler!.call(
        context,
        message,
        items,
      );
    }
    if (items != null) {
      showChatUIKitBottomSheet(
        context: context,
        items: items,
        showCancel: false,
      );
    }
  }

  void avatarTap(Message message) async {
    ChatUIKitProfile profile = ChatUIKitProvider.instance.getProfile(
      ChatUIKitProfile.contact(id: message.from!),
    );

    pushNextPage(profile);
  }

  void bubbleTab(Message message) async {
    if (message.bodyType == MessageType.IMAGE) {
      ChatUIKitRoute.pushOrPushNamed(
        context,
        ChatUIKitRouteNames.showImageView,
        ShowImageViewArguments(
          message: message,
          attributes: widget.attributes,
        ),
      );
    } else if (message.bodyType == MessageType.VIDEO) {
      ChatUIKitRoute.pushOrPushNamed(
        context,
        ChatUIKitRouteNames.showVideoView,
        ShowVideoViewArguments(
          message: message,
          attributes: widget.attributes,
        ),
      );
    }

    if (message.bodyType == MessageType.VOICE) {
      playVoiceMessage(message);
    }

    if (message.bodyType == MessageType.COMBINE) {
      ChatUIKitRoute.pushOrPushNamed(
        context,
        ChatUIKitRouteNames.forwardMessagesView,
        ForwardMessagesViewArguments(
          message: message,
          attributes: widget.attributes,
        ),
      );
    }

    if (message.bodyType == MessageType.CUSTOM && message.isCardMessage) {
      String? userId =
          (message.body as CustomMessageBody).params?[cardUserIdKey];
      String avatar =
          (message.body as CustomMessageBody).params?[cardAvatarKey] ?? '';
      String name =
          (message.body as CustomMessageBody).params?[cardNicknameKey] ?? '';
      if (userId?.isNotEmpty == true) {
        ChatUIKitProfile profile = ChatUIKitProfile(
          id: userId!,
          avatarUrl: avatar,
          name: name,
          type: ChatUIKitProfileType.contact,
        );
        pushNextPage(profile);
      }
    }
  }

  void onErrorTap(Message message) {
    controller.resendMessage(message);
  }

  void textMessageEdit(Message message) {
    clearAllType();
    if (message.bodyType != MessageType.TXT) return;
    editMessage = message;
    editBarTextEditingController =
        TextEditingController(text: editMessage?.textContent ?? "");
    setState(() {});
  }

  void replyMessaged(Message message) {
    clearAllType();
    focusNode.requestFocus();
    replyMessage = message;
    setState(() {});
  }

  void deleteMessage(Message message) async {
    final delete = await showChatUIKitDialog(
      title:
          ChatUIKitLocal.messagesViewDeleteMessageAlertTitle.getString(context),
      content: ChatUIKitLocal.messagesViewDeleteMessageAlertSubTitle
          .getString(context),
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal.messagesViewDeleteMessageAlertButtonCancel
              .getString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: ChatUIKitLocal.messagesViewDeleteMessageAlertButtonConfirm
              .getString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (delete == true) {
      controller.deleteMessage(message.msgId);
    }
  }

  void recallMessage(Message message) async {
    final recall = await showChatUIKitDialog(
      title:
          ChatUIKitLocal.messagesViewRecallMessageAlertTitle.getString(context),
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal.messagesViewRecallMessageAlertButtonCancel
              .getString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: ChatUIKitLocal.messagesViewRecallMessageAlertButtonConfirm
              .getString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (recall == true) {
      try {
        controller.recallMessage(message);
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
            backText: ChatUIKitLocal.messagesViewSelectContactCancel
                .getString(context),
            title: ChatUIKitLocal.messagesViewSelectContactTitle
                .getString(context),
            onTap: (context, model) {
              showChatUIKitDialog(
                title: ChatUIKitLocal.messagesViewShareContactAlertTitle
                    .getString(context),
                content: ChatUIKitLocal.messagesViewShareContactAlertSubTitle
                    .getString(context),
                context: context,
                items: [
                  ChatUIKitDialogItem.cancel(
                    label: ChatUIKitLocal
                        .messagesViewShareContactAlertButtonCancel
                        .getString(context),
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  ChatUIKitDialogItem.confirm(
                    label: ChatUIKitLocal
                        .messagesViewShareContactAlertButtonConfirm
                        .getString(context),
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
        ChatUIKit.instance
            .sendChatUIKitEvent(ChatUIKitEvent.messageDownloading);
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

  void reportMessage(Message message) async {
    Map<String, String> reasons = ChatUIKitSettings.reportMessageReason;
    List<String> reasonKeys = reasons.keys.toList();

    final reportReason = await ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.reportMessageView,
      ReportMessageViewArguments(
        messageId: message.msgId,
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
        message: message,
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
        pushToGroupInfo(profile);
      }
      // 当前聊天对象，是单聊
      else {
        pushCurrentChatter(profile);
      }
    }
    // 以上都不是时，检查通讯录
    else {
      List<String> contacts = await ChatUIKit.instance.getAllContacts();
      // 是好友，不是当前聊天对象，跳转到好友页面，并可以发消息
      if (contacts.contains(profile.id)) {
        pushNewContactDetail(profile);
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
          controller.clearMessages();
          replyMessage = null;
          setState(() {});
        },
        profile: profile,
        actions: [
          ChatUIKitActionModel(
            title: ChatUIKitLocal.contactDetailViewSend.getString(context),
            icon: 'assets/images/chat.png',
            packageName: ChatUIKitImageLoader.packageName,
            onTap: (context) {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
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
          controller.clearMessages();
          replyMessage = null;
          setState(() {});
        },
        actions: [
          ChatUIKitActionModel(
            title: ChatUIKitLocal.groupDetailViewSend.getString(context),
            icon: 'assets/images/chat.png',
            packageName: ChatUIKitImageLoader.packageName,
            onTap: (context) {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
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
          ChatUIKitActionModel(
            title: ChatUIKitLocal.contactDetailViewSend.getString(context),
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
        ],
      ),
    );
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

  List<ChatUIKitBottomSheetItem> defaultItemLongPressed(
      Message message, ChatUIKitTheme theme) {
    List<ChatUIKitBottomSheetItem> items = [];
    // 复制
    if (message.bodyType == MessageType.TXT) {
      items.add(ChatUIKitBottomSheetItem.normal(
        label: ChatUIKitLocal.messagesViewLongPressActionsTitleCopy
            .getString(context),
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontWeight: theme.font.bodyLarge.fontWeight,
          fontSize: theme.font.bodyLarge.fontSize,
        ),
        icon: ChatUIKitImageLoader.messageLongPressCopy(
          color: theme.color.isDark
              ? theme.color.neutralColor7
              : theme.color.neutralColor3,
        ),
        onTap: () async {
          Clipboard.setData(ClipboardData(text: message.textContent));
          ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.messageCopied);
          Navigator.of(context).pop();
        },
      ));
    }

    // 回复
    if (message.status == MessageStatus.SUCCESS) {
      items.add(ChatUIKitBottomSheetItem.normal(
        icon: ChatUIKitImageLoader.messageLongPressReply(
          color: theme.color.isDark
              ? theme.color.neutralColor7
              : theme.color.neutralColor3,
        ),
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontWeight: theme.font.bodyLarge.fontWeight,
          fontSize: theme.font.bodyLarge.fontSize,
        ),
        label: ChatUIKitLocal.messagesViewLongPressActionsTitleReply
            .getString(context),
        onTap: () async {
          Navigator.of(context).pop();
          replyMessaged(message);
        },
      ));
    }
    // 转发
    if (message.status == MessageStatus.SUCCESS) {
      items.add(ChatUIKitBottomSheetItem.normal(
        icon: ChatUIKitImageLoader.messageLongPressForward(
          color: theme.color.isDark
              ? theme.color.neutralColor7
              : theme.color.neutralColor3,
        ),
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontWeight: theme.font.bodyLarge.fontWeight,
          fontSize: theme.font.bodyLarge.fontSize,
        ),
        label: '转发',
        onTap: () async {
          Navigator.of(context).pop();
          forwardMessage(
            [message],
            isMultiSelect: false,
          );
        },
      ));
    }

    // 多选
    if (message.status == MessageStatus.SUCCESS) {
      items.add(ChatUIKitBottomSheetItem.normal(
        icon: ChatUIKitImageLoader.messageLongPressMultiSelected(
          color: theme.color.isDark
              ? theme.color.neutralColor7
              : theme.color.neutralColor3,
        ),
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontWeight: theme.font.bodyLarge.fontWeight,
          fontSize: theme.font.bodyLarge.fontSize,
        ),
        label: '多选',
        onTap: () async {
          Navigator.of(context).pop();
          controller.enableMultiSelectMode();
        },
      ));
    }

    // 翻译
    if (message.status == MessageStatus.SUCCESS &&
        message.bodyType == MessageType.TXT) {
      items.add(ChatUIKitBottomSheetItem.normal(
        icon: ChatUIKitImageLoader.messageLongPressTranslate(
          color: theme.color.isDark
              ? theme.color.neutralColor7
              : theme.color.neutralColor3,
        ),
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontWeight: theme.font.bodyLarge.fontWeight,
          fontSize: theme.font.bodyLarge.fontSize,
        ),
        label: message.hasTranslate ? '显示原文' : '翻译',
        onTap: () async {
          Navigator.of(context).pop();
          controller.translateMessage(
            message,
            showTranslate: !message.hasTranslate,
          );
        },
      ));
    }

    // 创建话题
    if (message.status == MessageStatus.SUCCESS &&
        message.chatType == ChatType.GroupChat) {
      items.add(ChatUIKitBottomSheetItem.normal(
        label: '创建话题(TODO)',
        icon: ChatUIKitImageLoader.messageLongPressThread(
          color: theme.color.isDark
              ? theme.color.neutralColor7
              : theme.color.neutralColor3,
        ),
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontWeight: theme.font.bodyLarge.fontWeight,
          fontSize: theme.font.bodyLarge.fontSize,
        ),
        onTap: () async {
          Navigator.of(context).pop();
          replyMessaged(message);
        },
      ));
    }

    // 编辑
    if (message.bodyType == MessageType.TXT &&
        message.direction == MessageDirection.SEND) {
      items.add(ChatUIKitBottomSheetItem.normal(
        label: ChatUIKitLocal.messagesViewLongPressActionsTitleEdit
            .getString(context),
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontWeight: theme.font.bodyLarge.fontWeight,
          fontSize: theme.font.bodyLarge.fontSize,
        ),
        icon: ChatUIKitImageLoader.messageLongPressEdit(
          color: theme.color.isDark
              ? theme.color.neutralColor7
              : theme.color.neutralColor3,
        ),
        onTap: () async {
          Navigator.of(context).pop();
          textMessageEdit(message);
        },
      ));
    }

    // 举报
    items.add(ChatUIKitBottomSheetItem.normal(
      label: ChatUIKitLocal.messagesViewLongPressActionsTitleReport
          .getString(context),
      style: TextStyle(
        color: theme.color.isDark
            ? theme.color.neutralColor98
            : theme.color.neutralColor1,
        fontWeight: theme.font.bodyLarge.fontWeight,
        fontSize: theme.font.bodyLarge.fontSize,
      ),
      icon: ChatUIKitImageLoader.messageLongPressReport(
        color: theme.color.isDark
            ? theme.color.neutralColor7
            : theme.color.neutralColor3,
      ),
      onTap: () async {
        Navigator.of(context).pop();
        reportMessage(message);
      },
    ));

    // 删除
    items.add(ChatUIKitBottomSheetItem.normal(
      label: ChatUIKitLocal.messagesViewLongPressActionsTitleDelete
          .getString(context),
      style: TextStyle(
        color: theme.color.isDark
            ? theme.color.neutralColor98
            : theme.color.neutralColor1,
        fontWeight: theme.font.bodyLarge.fontWeight,
        fontSize: theme.font.bodyLarge.fontSize,
      ),
      icon: ChatUIKitImageLoader.messageLongPressDelete(
        color: theme.color.isDark
            ? theme.color.neutralColor7
            : theme.color.neutralColor3,
      ),
      onTap: () async {
        Navigator.of(context).pop();
        deleteMessage(message);
      },
    ));

    // 撤回
    if (message.direction == MessageDirection.SEND &&
        message.serverTime >=
            DateTime.now().millisecondsSinceEpoch -
                ChatUIKitSettings.recallExpandTime * 1000) {
      items.add(ChatUIKitBottomSheetItem.normal(
        label: ChatUIKitLocal.messagesViewLongPressActionsTitleRecall
            .getString(context),
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontWeight: theme.font.bodyLarge.fontWeight,
          fontSize: theme.font.bodyLarge.fontSize,
        ),
        icon: ChatUIKitImageLoader.messageLongPressRecall(
          color: theme.color.isDark
              ? theme.color.neutralColor7
              : theme.color.neutralColor3,
        ),
        onTap: () async {
          Navigator.of(context).pop();
          recallMessage(message);
        },
      ));
    }
    return items;
  }

  void attemptSendInputType() {
    controller.attemptSendInputType();
  }

  void forwardMessage(List<Message> message, {bool isMultiSelect = false}) {
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
}
