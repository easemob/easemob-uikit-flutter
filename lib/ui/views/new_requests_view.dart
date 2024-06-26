import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class NewRequestsView extends StatefulWidget {
  NewRequestsView.arguments(NewRequestsViewArguments arguments, {super.key})
      : controller = arguments.controller,
        appBar = arguments.appBar,
        onSearchTap = arguments.onSearchTap,
        listViewItemBuilder = arguments.listViewItemBuilder,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        searchBarHideText = arguments.searchBarHideText,
        listViewBackground = arguments.listViewBackground,
        enableAppBar = arguments.enableAppBar,
        loadErrorMessage = arguments.loadErrorMessage,
        title = arguments.title,
        appBarTrailingActionsBuilder = arguments.appBarTrailingActionsBuilder,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes;

  const NewRequestsView({
    this.controller,
    this.appBar,
    this.onSearchTap,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.searchBarHideText,
    this.listViewBackground,
    this.loadErrorMessage,
    this.enableAppBar = true,
    this.title,
    this.attributes,
    this.viewObserver,
    this.appBarTrailingActionsBuilder,
    super.key,
  });

  final NewRequestListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<NewRequestItemModel> data)? onSearchTap;
  final ChatUIKitNewRequestItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, NewRequestItemModel model)? onTap;
  final void Function(BuildContext context, NewRequestItemModel model)?
      onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableAppBar;
  final String? title;
  final ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;
  final String? attributes;

  @override
  State<NewRequestsView> createState() => _NewRequestsViewState();
}

class _NewRequestsViewState extends State<NewRequestsView>
    with ContactObserver, ChatSDKEventsObserver {
  late final NewRequestListViewController controller;
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    controller = widget.controller ?? NewRequestListViewController();
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future(() => {ChatUIKitContext.instance.markAllRequestsAsRead()});
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
                  centerTitle: false,
                  title: widget.title ??
                      ChatUIKitLocal.newRequestsViewTitle.localString(context),
                  trailingActions:
                      widget.appBarTrailingActionsBuilder?.call(context, null),
                ),
        body: SafeArea(
          child: NewRequestsListView(
            controller: controller,
            itemBuilder: widget.listViewItemBuilder,
            searchHideText: widget.searchBarHideText,
            background: widget.listViewBackground,
            errorMessage: widget.loadErrorMessage,
            // onTap: widget.onTap ?? onItemTap,
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
          ),
        ));

    return content;
  }

  // 暂定不需要跳进详情页面
  void onItemTap(BuildContext context, NewRequestItemModel model) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.newRequestDetailsView,
      NewRequestDetailsViewArguments(
        profile: model.profile,
        isReceivedRequest: true,
        attributes: widget.attributes,
      ),
    ).then((value) {
      if (value == true) {
        if (mounted && value == true) {
          controller.reload();
        }
      }
    });
  }

  @override
  void onContactRequestReceived(String userId, String? reason) {
    if (mounted) {
      controller.reload();
    }
  }
}
