import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class SelectContactView extends StatefulWidget {
  SelectContactView.arguments(SelectContactViewArguments arguments, {super.key})
      : listViewItemBuilder = arguments.listViewItemBuilder,
        onSearchTap = arguments.onSearchTap,
        searchBarHideText = arguments.searchBarHideText,
        listViewBackground = arguments.listViewBackground,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        appBar = arguments.appBar,
        controller = arguments.controller,
        enableAppBar = arguments.enableAppBar,
        title = arguments.title,
        appBarTrailingActionsBuilder = arguments.appBarTrailingActionsBuilder,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes;

  const SelectContactView({
    this.title,
    this.listViewItemBuilder,
    this.onSearchTap,
    this.searchBarHideText,
    this.listViewBackground,
    this.onTap,
    this.onLongPress,
    this.appBar,
    this.enableAppBar = true,
    this.controller,
    this.attributes,
    this.viewObserver,
    this.appBarTrailingActionsBuilder,
    super.key,
  });

  final String? title;
  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)? onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;

  @override
  State<SelectContactView> createState() => _SelectContactViewState();
}

class _SelectContactViewState extends State<SelectContactView> {
  late final ContactListViewController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ContactListViewController();
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
      backgroundColor: theme.color.isDark ? theme.color.neutralColor1 : theme.color.neutralColor98,
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                title: widget.title,
                centerTitle: false,
                showBackButton: true,
                trailingActions: () {
                  List<ChatUIKitAppBarTrailingAction> actions = [
                    ChatUIKitAppBarTrailingAction(
                      actionType: ChatUIKitActionType.cancel,
                      onTap: (context) {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        ChatUIKitLocal.messagesViewSelectContactCancel.localString(context),
                        textScaler: TextScaler.noScaling,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.color.isDark ? theme.color.neutralColor98 : theme.color.neutralColor1,
                          fontWeight: theme.font.titleMedium.fontWeight,
                          fontSize: theme.font.titleMedium.fontSize,
                        ),
                      ),
                    )
                  ];
                  return widget.appBarTrailingActionsBuilder?.call(context, actions) ?? actions;
                }(),
              ),
      body: ContactListView(
        controller: controller,
        itemBuilder: widget.listViewItemBuilder,
        searchHideText: widget.searchBarHideText,
        background: widget.listViewBackground,
        onTap: widget.onTap ?? tapContactInfo,
        onSearchTap: widget.onSearchTap ?? onSearchTap,
      ),
    );

    return content;
  }

  void onSearchTap(List<ContactItemModel> data) async {
    List<NeedSearch> list = [];
    for (var item in data) {
      list.add(item);
    }

    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.searchUsersView,
      SearchViewArguments(
        onTap: (ctx, profile) {
          Navigator.of(ctx).pop(profile);
        },
        searchHideText: ChatUIKitLocal.selectContactViewSearchHint.localString(context),
        searchData: list,
        attributes: widget.attributes,
      ),
    ).then((value) {
      if (value != null) {
        Navigator.of(context).pop(value);
      }
    });
  }

  void tapContactInfo(BuildContext context, ContactItemModel info) {
    Navigator.of(context).pop(info.profile);
  }
}
