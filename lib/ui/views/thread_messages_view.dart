import 'dart:io';
import 'dart:math';

import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThreadMessagesView extends StatefulWidget {
  ThreadMessagesView.arguments(
    ThreadMessagesViewArguments argument, {
    super.key,
  })  : attributes = argument.attributes,
        viewObserver = argument.viewObserver,
        controller = argument.controller,
        appBar = argument.appBar,
        enableAppBar = argument.enableAppBar,
        title = argument.title,
        subtitle = argument.subtitle,
        inputBarController = argument.inputBarController,
        inputBarFocusNode = argument.inputBarFocusNode,
        morePressActions = argument.morePressActions,
        onMoreActionsItemsHandler = argument.onMoreActionsItemsHandler,
        longPressActions = argument.longPressActions,
        onItemLongPressHandler = argument.onItemLongPressHandler,
        forceLeft = argument.forceLeft,
        emojiWidget = argument.emojiWidget,
        replyBarBuilder = argument.replyBarBuilder,
        quoteBuilder = argument.quoteBuilder;

  const ThreadMessagesView({
    this.attributes,
    this.viewObserver,
    required this.controller,
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
    super.key,
  });

  final String? attributes;

  final ChatUIKitViewObserver? viewObserver;

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

  @override
  State<ThreadMessagesView> createState() => _ThreadMessagesViewState();
}

class _ThreadMessagesViewState extends State<ThreadMessagesView>
    with ThreadObserver {
  String? title;
  late ThreadMessagesViewController controller;
  late final ChatUIKitInputBarController inputBarController;
  bool showEmoji = false;
  bool showMoreBtn = true;

  bool messageEditCanSend = false;
  ChatUIKitInputBarController? editBarTextEditingController;
  Message? editMessage;
  MessageModel? replyMessage;
  Message? _playingMessage;
  late final ImagePicker _picker;
  late final AudioPlayer _player;
  late final AutoScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    controller = widget.controller;
    controller.addListener(() {
      setState(() {});
    });

    inputBarController =
        widget.inputBarController ?? ChatUIKitInputBarController();
    inputBarController.addListener(() {
      if (showMoreBtn != !inputBarController.text.trim().isNotEmpty) {
        showMoreBtn = !inputBarController.text.trim().isNotEmpty;
        setState(() {});
      }
    });

    inputBarController.focusNode.addListener(() {
      if (editMessage != null) return;
      if (inputBarController.hasFocus) {
        showEmoji = false;
        setState(() {});
      }
    });
    _scrollController = AutoScrollController();
    widget.viewObserver?.addListener(() {
      setState(() {});
    });

    _picker = ImagePicker();
    _player = AudioPlayer();
    loadThreadMessages();
  }

  void loadThreadMessages() {
    controller.fetchItemList();
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    controller.dispose();
    widget.viewObserver?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        title: controller.title(widget.title),
        subtitle: widget.subtitle,
        centerTitle: false,
        trailing: InkWell(
          onTap: showMenuBottomSheet,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.more_vert,
              color: theme.color.isDark
                  ? theme.color.neutralColor9
                  : theme.color.neutralColor3,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: clearAllType,
              child: ThreadMessageListView(
                scrollController: _scrollController,
                header: originMsgWidget(theme),
                controller: controller,
                onItemLongPress: (context, model) {
                  onItemLongPress(model);
                  return true;
                },
                itemBuilder: itemBuilder,
                onReactionItemTap: (model, reaction) {
                  controller.updateReaction(
                    model.message.msgId,
                    reaction.reaction,
                    !reaction.isAddedBySelf,
                  );
                },
              ),
            )),
            inputBar(theme),
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
            )
          ],
        ),
      ),
    );

    return content;
  }

  Widget? itemBuilder(BuildContext context, MessageModel model) {
    if (model.message.bodyType != MessageType.VOICE) return null;

    Widget content = ChatUIKitMessageListViewMessageItem(
      isPlaying: _playingMessage?.msgId == model.message.msgId,
      key: ValueKey(model.message.localTime),
      quoteBuilder: widget.quoteBuilder,
      onAvatarTap: () {},
      onAvatarLongPressed: () {},
      onBubbleDoubleTap: () {},
      onBubbleLongPressed: () {},
      onBubbleTap: () {},
      onNicknameTap: () {},
      model: model,
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
      alignment: model.message.direction == MessageDirection.SEND
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: content,
    );

    return content;
  }

  Widget originMsgWidget(ChatUIKitTheme theme) {
    MessageModel? model = controller.model;
    if (model == null) {
      return const Text('No data');
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ChatUIKitAvatar(
            avatarUrl: model.message.fromProfile.avatarUrl,
            size: 28,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        model.message.fromProfile.showName,
                        style: TextStyle(
                          fontWeight: theme.font.titleSmall.fontWeight,
                          fontSize: theme.font.titleSmall.fontSize,
                          color: theme.color.isDark
                              ? theme.color.neutralSpecialColor6
                              : theme.color.neutralSpecialColor5,
                        ),
                      ),
                      Text(
                        ChatUIKitTimeFormatter.instance.formatterHandler?.call(
                                context,
                                ChatUIKitTimeType.message,
                                model.message.serverTime) ??
                            ChatUIKitTimeTool.getChatTimeStr(
                              model.message.serverTime,
                              needTime: true,
                            ),
                        style: TextStyle(
                          fontWeight: theme.font.bodySmall.fontWeight,
                          fontSize: theme.font.bodySmall.fontSize,
                          color: theme.color.isDark
                              ? theme.color.neutralColor6
                              : theme.color.neutralColor5,
                        ),
                      )
                    ],
                  ),
                  Row(children: [subWidget(theme, model)]),
                  const SizedBox(height: 8),
                  Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: theme.color.isDark
                        ? theme.color.neutralColor2
                        : theme.color.neutralColor98,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget subWidget(ChatUIKitTheme theme, MessageModel model) {
    Widget? msgWidget;
    if (model.message.bodyType == MessageType.TXT) {
      msgWidget = Flexible(
          fit: FlexFit.loose,
          child: ChatUIKitTextMessageWidget(
            model: model,
            style: TextStyle(
              fontWeight: theme.font.bodyMedium.fontWeight,
              fontSize: theme.font.bodyMedium.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor98
                  : theme.color.neutralColor2,
            ),
          ));
    } else if (model.message.bodyType == MessageType.IMAGE) {
      msgWidget = ChatUIKitImageMessageWidget(model: model);
    } else if (model.message.bodyType == MessageType.VOICE) {
      msgWidget = ChatUIKitVoiceMessageWidget(model: model, playing: false);
    } else if (model.message.bodyType == MessageType.VIDEO) {
      msgWidget = ChatUIKitVideoMessageWidget(model: model);
    } else if (model.message.bodyType == MessageType.FILE) {
      msgWidget = ChatUIKitFileMessageWidget(model: model);
    } else if (model.message.bodyType == MessageType.COMBINE) {
      msgWidget = ChatUIKitCombineMessageWidget(model: model);
    } else if (model.message.bodyType == MessageType.CUSTOM) {
      if (model.message.isCardMessage) {
        msgWidget = ChatUIKitCardMessageWidget(model: model);
      }
    }
    msgWidget ??= ChatUIKitNonsupportMessageWidget(model: model);
    return msgWidget;
  }

  void showMenuBottomSheet() {
    final theme = ChatUIKitTheme.of(context);
    List<ChatUIKitBottomSheetItem> items = [];
    if (controller.hasPermission) {
      items.add(
        ChatUIKitBottomSheetItem.normal(
          label: '编辑话题',
          onTap: () async {
            Navigator.of(context).pop();
            ChatUIKitRoute.pushOrPushNamed(
              context,
              ChatUIKitRouteNames.changeInfoView,
              ChangeInfoViewArguments(
                title: "话题名称",
                hint: '新名称',
                maxLength: 128,
              ),
            ).then((value) {
              if (value is String) {
                controller.changeThreadName(value);
              }
            });
          },
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor2,
            fontSize: theme.font.labelLarge.fontSize,
            fontWeight: theme.font.labelLarge.fontWeight,
          ),
          icon: ChatUIKitImageLoader.messageEdit(
              color: theme.color.isDark
                  ? theme.color.neutralColor98
                  : theme.color.neutralColor2),
        ),
      );
    }
    items.add(
      ChatUIKitBottomSheetItem.normal(
        label: '话题成员',
        onTap: () async {
          Navigator.of(context).pop();
          ChatUIKitRoute.pushOrPushNamed(
            context,
            ChatUIKitRouteNames.threadMembersView,
            ThreadMembersViewArguments(
              thread: controller.thread!,
              attributes: widget.attributes,
            ),
          );
        },
        style: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontSize: theme.font.labelLarge.fontSize,
          fontWeight: theme.font.labelLarge.fontWeight,
        ),
        icon: ChatUIKitImageLoader.contacts(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1),
      ),
    );
    if (controller.hasPermission) {
      items.add(
        ChatUIKitBottomSheetItem.destructive(
          label: '删除话题',
          onTap: () async {
            Navigator.of(context).pop();
            controller.destroyChatThread();
          },
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.errorColor6
                : theme.color.errorColor5,
            fontSize: theme.font.labelLarge.fontSize,
            fontWeight: theme.font.labelLarge.fontWeight,
          ),
          icon: ChatUIKitImageLoader.voiceDelete(
            color: theme.color.isDark
                ? theme.color.errorColor6
                : theme.color.errorColor5,
          ),
        ),
      );
    } else {
      if (!controller.hasPermission) {
        items.add(
          ChatUIKitBottomSheetItem.destructive(
            label: '离开话题',
            onTap: () async {
              Navigator.of(context).pop();
              controller.leaveChatThread().then((value) {
                Navigator.of(context).pop();
              }).catchError((e) {
                debugPrint('leaveChatThread: $e');
              });
            },
            style: TextStyle(
              color: theme.color.isDark
                  ? theme.color.neutralColor98
                  : theme.color.neutralColor1,
              fontSize: theme.font.labelLarge.fontSize,
              fontWeight: theme.font.labelLarge.fontWeight,
            ),
            icon: ChatUIKitImageLoader.leaveThread(
              color: theme.color.isDark
                  ? theme.color.errorColor6
                  : theme.color.errorColor5,
            ),
          ),
        );
      }
    }

    showChatUIKitBottomSheet(
      context: context,
      items: items,
    );
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
                  String text = inputBarController.text.trim();
                  if (text.isNotEmpty) {
                    dynamic mention;
                    if (inputBarController.isAtAll && text.contains("@All")) {
                      mention = true;
                    }

                    if (inputBarController.mentionList.isNotEmpty) {
                      List<String> mentionList = [];
                      List<ChatUIKitProfile> list =
                          inputBarController.mentionList;
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

  void textMessageEdit(Message message) {
    clearAllType();
    if (message.bodyType != MessageType.TXT) return;
    editMessage = message;
    editBarTextEditingController =
        ChatUIKitInputBarController(text: editMessage?.textContent ?? "");
    setState(() {});
  }

  void replyMessaged(MessageModel model) {
    // clearAllType();
    // inputBarController.requestFocus();
    replyMessage = model;
    setState(() {});
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

  void onItemLongPress(MessageModel model) async {
    final theme = ChatUIKitTheme.of(context);
    clearAllType();
    List<ChatUIKitBottomSheetItem>? items = widget.longPressActions;
    items ??= defaultItemLongPressed(model, theme);

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

  List<ChatUIKitBottomSheetItem> defaultItemLongPressed(
      MessageModel model, ChatUIKitTheme theme) {
    List<ChatUIKitBottomSheetItem> items = [];
    // 复制
    if (model.message.bodyType == MessageType.TXT) {
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
          Clipboard.setData(ClipboardData(text: model.message.textContent));
          ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.messageCopied);
          Navigator.of(context).pop();
        },
      ));
    }

    // 回复
    if (model.message.status == MessageStatus.SUCCESS) {
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
          replyMessaged(model);
        },
      ));
    }
    // 转发
    if (model.message.status == MessageStatus.SUCCESS) {
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
            [model.message],
            isMultiSelect: false,
          );
        },
      ));
    }

    // 多选
    if (model.message.status == MessageStatus.SUCCESS) {
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
    if (model.message.status == MessageStatus.SUCCESS &&
        model.message.bodyType == MessageType.TXT) {
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
        label: model.message.hasTranslate ? '显示原文' : '翻译',
        onTap: () async {
          Navigator.of(context).pop();
          controller.translateMessage(
            model.message,
            showTranslate: !model.message.hasTranslate,
          );
        },
      ));
    }

    // 编辑
    if (model.message.bodyType == MessageType.TXT &&
        model.message.direction == MessageDirection.SEND) {
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
          textMessageEdit(model.message);
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
        reportMessage(model);
      },
    ));

    return items;
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

  void showBottomSheet() {}

  Widget? bottomSheetTitle(MessageModel model, ChatUIKitTheme theme) {
    if (ChatUIKitSettings.enableReaction == false) return null;
    List<MessageReaction>? reactions = model.reactions;

    return Padding(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          int maxCount = width ~/ (36 + 12) - 1;
          List<Widget> items = [];
          for (var i = 0;
              i < min(ChatUIKitSettings.favoriteReaction.length, maxCount);
              i++) {
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
                        ? (theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5)
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
            mainAxisAlignment:
                full ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
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

  void showAllReactionEmojis(MessageModel model, ChatUIKitTheme theme) {
    showChatUIKitBottomSheet(
      context: context,
      showCancel: false,
      body: ChatUIKitInputEmojiBar(
        selectedEmojis: model.reactions
            ?.where((e) => e.isAddedBySelf == true)
            .map((e) => e.reaction)
            .toList(),
        selectedColor: theme.color.isDark
            ? theme.color.primaryColor6
            : theme.color.primaryColor5,
        emojiClicked: (emojiPath) async {
          var emoji = ChatUIKitEmojiData.getEmoji(emojiPath);
          bool needAdd = false;
          if (model.reactions == null) {
            needAdd = true;
          } else {
            needAdd = model.reactions?.indexWhere((element) =>
                    element.reaction == emoji && element.isAddedBySelf) ==
                -1;
          }

          Navigator.of(context).pop();
          await controller.updateReaction(model.message.msgId,
              ChatUIKitEmojiData.emojiMap[emojiPath]!, needAdd);
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

  @override
  void onChatThreadCreate(ChatThreadEvent event) {}
  @override
  void onChatThreadDestroy(ChatThreadEvent event) async {
    if (event.chatThread?.threadId == controller.thread?.threadId) {
      Navigator.of(context).pop();
    }
  }

  @override
  void onChatThreadUpdate(ChatThreadEvent event) {
    if (event.chatThread?.threadId == controller.thread?.threadId) {
      if (event.type == ChatThreadOperation.Create) {}
    }
  }

  @override
  void onUserKickOutOfChatThread(ChatThreadEvent event) {}
}
