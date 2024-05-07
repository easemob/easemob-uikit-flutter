import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupsView extends StatefulWidget {
  GroupsView.arguments(GroupsViewArguments arguments, {super.key})
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

  const GroupsView({
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

  final GroupListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<GroupItemModel> data)? onSearchTap;
  final ChatUIKitGroupItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, GroupItemModel model)? onTap;
  final void Function(BuildContext context, GroupItemModel model)? onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableAppBar;
  final String? title;
  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;
  @override
  State<GroupsView> createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
  late final GroupListViewController controller;
  ValueNotifier<int> joinedCount = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? GroupListViewController();
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
    ChatUIKit.instance.fetchJoinedGroupCount().then((value) {
      if (mounted) {
        joinedCount.value = value;
        safeSetState(() {});
      }
    }).catchError((e) {});
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    joinedCount.dispose();
    super.dispose();
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
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
                centerTitle: false,
                trailingActions:
                    widget.appBarTrailingActionsBuilder?.call(context, null),
                titleWidget: ValueListenableBuilder<int>(
                  valueListenable: joinedCount,
                  builder: (context, value, child) {
                    return Text(
                      widget.title ??
                          "${ChatUIKitLocal.groupsViewTitle.localString(context)}${value != 0 ? '($value)' : ''}",
                      textScaler: TextScaler.noScaling,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: theme.font.titleMedium.fontWeight,
                        fontSize: theme.font.titleMedium.fontSize,
                        color: theme.color.isDark
                            ? theme.color.neutralColor98
                            : theme.color.neutralColor1,
                      ),
                    );
                  },
                ),
              ),
      body: SafeArea(
        child: GroupListView(
          controller: controller,
          itemBuilder: widget.listViewItemBuilder,
          searchHideText: widget.searchBarHideText,
          background: widget.listViewBackground,
          errorMessage: widget.loadErrorMessage,
          onTap: widget.onTap ?? tapGroupInfo,
          onLongPress: widget.onLongPress,
        ),
      ),
    );

    return content;
  }

  void tapGroupInfo(BuildContext context, GroupItemModel model) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.groupDetailsView,
      GroupDetailsViewArguments(
        attributes: widget.attributes,
        profile: model.profile,
      ),
    ).then((value) {
      ChatUIKitRouteBackModel? model = ChatUIKitRoute.lastModel;
      if (model != null) {
        if (model.type == ChatUIKitRouteBackType.remove) {
          controller.list.removeWhere((element) {
            return element is GroupItemModel &&
                element.profile.id == model.profileId;
          });
          controller.refresh();
        }
      }
    });
  }
}
