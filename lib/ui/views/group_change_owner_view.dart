import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupChangeOwnerView extends StatefulWidget {
  GroupChangeOwnerView.arguments(GroupChangeOwnerViewArguments arguments,
      {super.key})
      : groupId = arguments.groupId,
        listViewItemBuilder = arguments.listViewItemBuilder,
        onSearchTap = arguments.onSearchTap,
        searchBarHideText = arguments.searchBarHideText,
        listViewBackground = arguments.listViewBackground,
        onItemTap = arguments.onItemTap,
        onItemLongPress = arguments.onItemLongPress,
        appBar = arguments.appBar,
        controller = arguments.controller,
        enableAppBar = arguments.enableAppBar,
        loadErrorMessage = arguments.loadErrorMessage,
        title = arguments.title,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes;

  const GroupChangeOwnerView({
    required this.groupId,
    this.listViewItemBuilder,
    this.onSearchTap,
    this.searchBarHideText,
    this.listViewBackground,
    this.onItemTap,
    this.onItemLongPress,
    this.appBar,
    this.controller,
    this.loadErrorMessage,
    this.enableAppBar = true,
    this.title,
    this.attributes,
    this.viewObserver,
    super.key,
  });

  final String groupId;

  final GroupMemberListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onItemTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onItemLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableAppBar;
  final String? title;
  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<GroupChangeOwnerView> createState() => _GroupChangeOwnerViewState();
}

class _GroupChangeOwnerViewState extends State<GroupChangeOwnerView> {
  late final GroupMemberListViewController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        GroupMemberListViewController(
          groupId: widget.groupId,
          includeOwner: false,
        );
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                  showBackButton: true,
                  leading: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.maybePop(context);
                    },
                    child: Text(
                      widget.title ??
                          ChatUIKitLocal.groupChangeOwnerViewTitle
                              .localString(context),
                      textScaler: TextScaler.noScaling,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.color.isDark
                            ? theme.color.neutralColor98
                            : theme.color.neutralColor1,
                        fontWeight: theme.font.titleMedium.fontWeight,
                        fontSize: theme.font.titleMedium.fontSize,
                      ),
                    ),
                  )),
      body: GroupMemberListView(
        groupId: widget.groupId,
        controller: controller,
        itemBuilder: (context, model) {
          Widget? content = widget.listViewItemBuilder?.call(context, model);
          content ??= () {
            Widget? item;
            item ??= InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (widget.onItemTap != null) {
                  widget.onItemTap?.call(context, model);
                } else {
                  showConfirmDialog(context, model);
                }
              },
              onLongPress: () {
                widget.onItemTap?.call(context, model);
              },
              child: ChatUIKitContactListViewItem(model),
            );

            return item;
          }();
          return content;
        },
        searchHideText: widget.searchBarHideText,
        background: widget.listViewBackground,
        onTap: showConfirmDialog,
      ),
    );

    return content;
  }

  void showConfirmDialog(BuildContext context, ContactItemModel model) async {
    bool? ret = await showChatUIKitDialog(
      title: ChatUIKitLocal.groupChangeOwnerViewAlertTitle.localString(context),
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal.groupChangeOwnerViewAlertButtonCancel
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: ChatUIKitLocal.groupChangeOwnerViewAlertButtonConfirm
              .localString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        )
      ],
    );

    if (ret == true) {
      ChatUIKit.instance
          .changeGroupOwner(groupId: widget.groupId, newOwner: model.profile.id)
          .then((value) {
        Navigator.of(context).pop(true);
      }).catchError((e) {});
    }
  }
}
