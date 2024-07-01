import 'dart:math';

import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:em_chat_uikit/ui/controllers/pin_message_list_view_controller.dart';
import 'package:flutter/material.dart';

double itemHeight = 64;
double appBarHeight = 56;

class PinListItemModel {
  final Message message;
  final MessagePinInfo pinInfo;

  const PinListItemModel({
    required this.message,
    required this.pinInfo,
  });

  PinListItemModel copyWith({
    Message? message,
    MessagePinInfo? pinInfo,
    VoidCallback? onTap,
    bool? isConfirming,
  }) {
    return PinListItemModel(
      message: message ?? this.message,
      pinInfo: pinInfo ?? this.pinInfo,
    );
  }

  String get senderShowName {
    return message.nickname ?? message.from!;
  }

  String get operatorShowName {
    return ChatUIKitProvider.instance
        .getProfile(ChatUIKitProfile.contact(id: pinInfo.operatorId))
        .showName;
  }
}

class PinMessageListView extends StatefulWidget {
  const PinMessageListView({
    required this.pinMessagesController,
    this.maxHeight = 300,
    this.duration = const Duration(milliseconds: 100),
    this.barrierColor,
    this.onTap,
    super.key,
  });

  final double maxHeight;
  final Duration duration;
  final Color? barrierColor;
  final PinMessageListViewController pinMessagesController;

  final void Function(Message message)? onTap;

  @override
  State<PinMessageListView> createState() => _PinMessageListViewState();
}

class _PinMessageListViewState extends State<PinMessageListView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? animation;
  late CurvedAnimation cure;
  late Color barrierColor;

  String? confirmMsgId;

  bool isShow = false;
  List<PinListItemModel> items = [];

  @override
  void initState() {
    super.initState();
    barrierColor = widget.barrierColor ?? Colors.black.withOpacity(0.3);
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    cure = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        confirmMsgId = null;
      }
    });

    _controller.addListener(() {
      setState(() {});
    });

    widget.pinMessagesController.list.addListener(() {
      if (items != widget.pinMessagesController.list.value) {
        items = widget.pinMessagesController.list.value;
        animation = Tween<double>(
                begin: 0, end: items.length * itemHeight + appBarHeight)
            .animate(cure);
        if (widget.pinMessagesController.isShow) {
          _controller.animateTo(items.length * itemHeight + appBarHeight,
              duration: widget.duration);
          setState(() {});
        }
      }
      if (items.isEmpty) {
        widget.pinMessagesController.hide();
      }
    });

    animation =
        Tween<double>(begin: 0, end: items.length * itemHeight + appBarHeight)
            .animate(cure);

    widget.pinMessagesController.addListener(() {
      if (widget.pinMessagesController.needReload) {
        setState(() {});
      }

      if (widget.pinMessagesController.isShow) {
        isShow = true;
        _controller.forward();
      } else {
        isShow = false;
        _controller.reverse();
      }
    });
  }

  @override
  void didUpdateWidget(covariant PinMessageListView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(),
        animation?.status == AnimationStatus.dismissed
            ? const SizedBox()
            : Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: -100,
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: AnimatedContainer(
                    duration: widget.duration,
                    color: isShow ? barrierColor : Colors.transparent,
                  ),
                  onTap: () {
                    widget.pinMessagesController.hide();
                  },
                ),
              ),
        Container(
          constraints: BoxConstraints(
            maxHeight: widget.maxHeight,
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedContainer(
                  color: theme.color.isDark
                      ? theme.color.neutralColor1
                      : theme.color.neutralColor98,
                  height: min(constraints.maxHeight, animation!.value),
                  duration: widget.duration,
                  child: Scrollbar(
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          floating: false,
                          elevation: 0,
                          leading: const SizedBox(),
                          leadingWidth: 0,
                          backgroundColor: theme.color.isDark
                              ? theme.color.neutralColor1
                              : theme.color.neutralColor98,
                          scrolledUnderElevation: 0,
                          title: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: ChatUIKitImageLoader.pinMessage(
                                    color: theme.color.isDark
                                        ? theme.color.neutralColor9
                                        : theme.color.neutralColor3,
                                    width: 18,
                                    height: 18),
                              ),
                              Text(
                                '${items.length} 条消息置顶',
                                style: TextStyle(
                                  fontWeight: theme.font.bodyMedium.fontWeight,
                                  fontSize: theme.font.bodyMedium.fontSize,
                                ),
                              )
                            ],
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              Message msg = items[index].message;
                              return InkWell(
                                onTap: () {
                                  widget.pinMessagesController.hide();
                                  widget.onTap?.call(msg);
                                },
                                child: PinListItem(
                                  model: items[index],
                                  isConfirming: confirmMsgId == msg.msgId,
                                  onDeleteTap: (confirm) {
                                    if (confirm) {
                                      widget.pinMessagesController
                                          .unPinMsg(items[index].message.msgId);
                                    } else {
                                      confirmMsgId = items[index].message.msgId;
                                      setState(() {});
                                    }
                                  },
                                ),
                              );
                            },
                            childCount: items.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class PinListItem extends StatelessWidget {
  const PinListItem({
    required this.model,
    this.isConfirming = false,
    this.onDeleteTap,
    super.key,
  });
  final void Function(bool confirm)? onDeleteTap;
  final PinListItemModel model;
  final bool isConfirming;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
      height: itemHeight,
      child: Container(
        decoration: BoxDecoration(
          color: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor95,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${model.operatorShowName} 置顶了 ${model.senderShowName} 的消息',
                      style: TextStyle(
                        fontWeight: theme.font.bodyMedium.fontWeight,
                        fontSize: theme.font.bodyMedium.fontSize,
                        color: theme.color.isDark
                            ? theme.color.neutralColor7
                            : theme.color.neutralColor4,
                      ),
                    ),
                  ),
                  Text(
                    ChatUIKitTimeFormatter.instance.formatterHandler?.call(
                            context,
                            ChatUIKitTimeType.messagePinTime,
                            model.message.serverTime) ??
                        ChatUIKitTimeTool.getChatTimeStr(
                          model.pinInfo.pinTime,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ChatUIKitEmojiRichText(
                      text: model.message.showInfoTranslate(
                        context,
                        needShowName: true,
                      ),
                      emojiSize: const Size(16, 16),
                      style: TextStyle(
                        fontWeight: theme.font.bodyMedium.fontWeight,
                        fontSize: theme.font.bodyMedium.fontSize,
                        color: theme.color.isDark
                            ? theme.color.neutralColor7
                            : theme.color.neutralColor4,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  InkWell(
                    onTap: () => onDeleteTap?.call(isConfirming),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: isConfirming
                          ? BoxDecoration(
                              color: theme.color.isDark
                                  ? theme.color.neutralColor3
                                  : theme.color.neutralColor9,
                              borderRadius: BorderRadius.circular(4),
                            )
                          : null,
                      child: () {
                        if (isConfirming) {
                          return Text(
                            '确认移除',
                            style: TextStyle(
                              fontWeight: theme.font.labelMedium.fontWeight,
                              fontSize: theme.font.labelMedium.fontSize,
                              color: theme.color.isDark
                                  ? theme.color.neutralColor98
                                  : theme.color.neutralColor1,
                            ),
                          );
                        } else {
                          return Text(
                            '移除',
                            style: TextStyle(
                              fontWeight: theme.font.labelMedium.fontWeight,
                              fontSize: theme.font.labelMedium.fontSize,
                              color: theme.color.isDark
                                  ? theme.color.neutralSpecialColor6
                                  : theme.color.neutralSpecialColor5,
                            ),
                          );
                        }
                      }(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
