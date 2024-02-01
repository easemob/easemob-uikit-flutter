import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

typedef ConversationItemBuilder = Widget? Function(
    BuildContext context, ConversationModel model);

class ConversationListView extends StatefulWidget {
  const ConversationListView({
    this.controller,
    this.itemBuilder,
    this.beforeWidgets,
    this.afterWidgets,
    this.onSearchTap,
    this.searchBarHideText,
    this.background,
    this.errorMessage,
    this.reloadMessage,
    this.onTap,
    this.onLongPress,
    this.enableLongPress = true,
    this.enableSearchBar = true,
    super.key,
  });

  final void Function(List<ConversationModel> data)? onSearchTap;
  final ConversationItemBuilder? itemBuilder;
  final void Function(BuildContext context, ConversationModel info)? onTap;
  final void Function(BuildContext context, ConversationModel info)?
      onLongPress;
  final List<Widget>? beforeWidgets;
  final List<Widget>? afterWidgets;

  final String? searchBarHideText;
  final Widget? background;
  final String? errorMessage;
  final String? reloadMessage;
  final ConversationListViewController? controller;
  final bool enableLongPress;
  final bool enableSearchBar;

  @override
  State<ConversationListView> createState() => _ConversationListViewState();
}

class _ConversationListViewState extends State<ConversationListView>
    with ChatObserver, MultiObserver, ChatUIKitProviderObserver {
  late ConversationListViewController controller;

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    ChatUIKitProvider.instance.addObserver(this);
    controller = widget.controller ?? ConversationListViewController();
    controller.fetchItemList();

    controller.loadingType.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    ChatUIKitProvider.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void onProfilesUpdate(
    Map<String, ChatUIKitProfile> map,
  ) {
    controller.reload();
  }

  @override
  void onMessagesReceived(List<Message> messages) async {
    // for (var msg in messages) {
    //   if (msg.hasMention) {
    //     Conversation? conversation = await ChatUIKit.instance.getConversation(
    //       conversationId: msg.conversationId!,
    //       type: ConversationType.values[msg.chatType.index],
    //     );
    //     await conversation?.addMention();
    //   }
    // }
    if (mounted) {
      controller.reload();
    }
  }

  @override
  void onMessagesRecalled(List<Message> recalled, List<Message> replaces) {
    List<String> recalledIds = recalled.map((e) => e.msgId).toList();
    bool has = controller.list.cast<ConversationModel>().any((element) {
      return recalledIds.contains(element.lastMessage?.msgId ?? "");
    });
    if (mounted && has) {
      controller.reload();
    }
  }

  @override
  void onConversationsUpdate() {
    controller.reload();
  }

  @override
  void onConversationEvent(
      MultiDevicesEvent event, String conversationId, ConversationType type) {
    if (event == MultiDevicesEvent.CONVERSATION_DELETE ||
        event == MultiDevicesEvent.CONVERSATION_PINNED ||
        event == MultiDevicesEvent.CONVERSATION_UNPINNED) {
      controller.fetchItemList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatUIKitListView(
      type: controller.loadingType.value,
      list: controller.list,
      refresh: () {
        controller.fetchItemList();
      },
      enableSearchBar: widget.enableSearchBar,
      errorMessage: widget.errorMessage,
      reloadMessage: widget.reloadMessage,
      beforeWidgets: widget.beforeWidgets,
      afterWidgets: widget.afterWidgets,
      background: widget.background,
      onSearchTap: (data) {
        List<ConversationModel> list = [];
        for (var item in data) {
          if (item is ConversationModel) {
            list.add(item);
          }
        }
        widget.onSearchTap?.call(list);
      },
      searchBarHideText: widget.searchBarHideText,
      findChildIndexCallback: (key) {
        int index = -1;
        if (key is ValueKey<String>) {
          final ValueKey<String> valueKey = key;
          index = controller.list.indexWhere((info) {
            if (info is ConversationModel) {
              return info.profile.id == valueKey.value;
            } else {
              return false;
            }
          });
        }

        return index > -1 ? index : null;
      },
      itemBuilder: (context, model) {
        if (model is ConversationModel) {
          Widget? item;
          if (widget.itemBuilder != null) {
            item = widget.itemBuilder!(context, model);
          }
          item ??= InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              widget.onTap?.call(context, model);
            },
            onLongPress: () {
              if (widget.enableLongPress) {
                widget.onLongPress?.call(context, model);
              }
            },
            child: ChatUIKitConversationListViewItem(
              model,
            ),
          );

          item = SizedBox(
            key: ValueKey(model.profile.id),
            child: item,
          );

          return item;
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
