import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class NewRequestsView extends StatefulWidget {
  NewRequestsView.arguments(NewRequestsViewArguments argument, {super.key})
      : controller = argument.controller,
        appBar = argument.appBar,
        onSearchTap = argument.onSearchTap,
        listViewItemBuilder = argument.listViewItemBuilder,
        onTap = argument.onTap,
        onLongPress = argument.onLongPress,
        searchBarHideText = argument.searchBarHideText,
        listViewBackground = argument.listViewBackground,
        enableAppBar = argument.enableAppBar,
        loadErrorMessage = argument.loadErrorMessage,
        title = argument.title,
        viewObserver = argument.viewObserver,
        attributes = argument.attributes;

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
  final String? attributes;

  @override
  State<NewRequestsView> createState() => _NewRequestsViewState();
}

class _NewRequestsViewState extends State<NewRequestsView>
    with ContactObserver, ChatSDKEventsObserver {
  late final NewRequestListViewController controller;
  int? joinedCount;
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
                          ChatUIKitLocal.newRequestsViewTitle
                              .getString(context),
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
                  ),
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
