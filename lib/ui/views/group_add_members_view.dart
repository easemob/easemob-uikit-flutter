import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupAddMembersView extends StatefulWidget {
  GroupAddMembersView.arguments(GroupAddMembersViewArguments arguments, {super.key})
      : listViewItemBuilder = arguments.listViewItemBuilder,
        onSearchTap = arguments.onSearchTap,
        searchBarHideText = arguments.searchBarHideText,
        listViewBackground = arguments.listViewBackground,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        appBar = arguments.appBar,
        controller = arguments.controller,
        groupId = arguments.groupId,
        enableAppBar = arguments.enableAppBar,
        inGroupMembers = arguments.inGroupMembers,
        title = arguments.title,
        viewObserver = arguments.viewObserver,
        appBarTrailingActionsBuilder = arguments.appBarTrailingActionsBuilder,
        attributes = arguments.attributes;

  const GroupAddMembersView({
    required this.groupId,
    this.listViewItemBuilder,
    this.onSearchTap,
    this.searchBarHideText,
    this.listViewBackground,
    this.onTap,
    this.onLongPress,
    this.appBar,
    this.controller,
    this.inGroupMembers,
    this.enableAppBar = true,
    this.title,
    this.viewObserver,
    this.attributes,
    this.appBarTrailingActionsBuilder,
    super.key,
  });

  final String groupId;
  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;
  final List<ChatUIKitProfile>? inGroupMembers;
  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)? onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final String? title;
  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;

  @override
  State<GroupAddMembersView> createState() => _GroupAddMembersViewState();
}

class _GroupAddMembersViewState extends State<GroupAddMembersView> {
  late final ContactListViewController controller;
  List<ChatUIKitProfile> selectedProfiles = [];

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
                showBackButton: true,
                centerTitle: false,
                title: widget.title ?? ChatUIKitLocal.groupAddMembersViewTitle.localString(context),
                trailingActions: () {
                  List<ChatUIKitAppBarTrailingAction> actions = [
                    ChatUIKitAppBarTrailingAction(
                      actionType: ChatUIKitActionType.add,
                      onTap: (context) {
                        if (selectedProfiles.isEmpty) {
                          return;
                        }
                        Navigator.of(context).pop(selectedProfiles);
                      },
                      child: Text(
                        selectedProfiles.isEmpty
                            ? ChatUIKitLocal.groupAddMembersViewAdd.localString(context)
                            : '${ChatUIKitLocal.groupAddMembersViewAdd.localString(context)}(${selectedProfiles.length})',
                        textScaler: TextScaler.noScaling,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
                          fontWeight: theme.font.labelMedium.fontWeight,
                          fontSize: theme.font.labelMedium.fontSize,
                        ),
                      ),
                    )
                  ];
                  return widget.appBarTrailingActionsBuilder?.call(context, actions) ?? actions;
                }(),
              ),
      body: ContactListView(
        controller: controller,
        itemBuilder: widget.listViewItemBuilder ??
            (context, model) {
              return InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  if (widget.inGroupMembers?.any((element) => element.id == model.profile.id) != true) {
                    tapContactInfo(model.profile);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 19.5, right: 15.5),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          widget.inGroupMembers?.any((element) => element.id == model.profile.id) == true
                              ? Icon(
                                  Icons.check_box,
                                  size: 28,
                                  color: theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
                                )
                              : selectedProfiles.contains(model.profile)
                                  ? Icon(
                                      Icons.check_box,
                                      size: 28,
                                      color: theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
                                    )
                                  : Icon(
                                      Icons.check_box_outline_blank,
                                      size: 28,
                                      color: theme.color.isDark ? theme.color.neutralColor4 : theme.color.neutralColor7,
                                    ),
                          Expanded(child: ChatUIKitContactListViewItem(model))
                        ],
                      ),
                      if (widget.inGroupMembers?.any((element) => element.id == model.profile.id) == true)
                        Opacity(
                          opacity: 0.6,
                          child: Container(
                            color: theme.color.isDark ? theme.color.neutralColor1 : theme.color.neutralColor98,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
        searchHideText: widget.searchBarHideText,
        background: widget.listViewBackground,
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
          cantChangeSelected: widget.inGroupMembers,
          canChangeSelected: selectedProfiles,
          searchHideText: ChatUIKitLocal.createGroupViewSearchContact.localString(context),
          searchData: list,
          enableMulti: true,
          attributes: widget.attributes,
        )).then(
      (value) {
        if (value is List<ChatUIKitProfile>) {
          selectedProfiles = [...value];
          setState(() {});
        }
      },
    );
  }

  void tapContactInfo(ChatUIKitProfile profile) {
    List<ChatUIKitProfile> list = selectedProfiles;
    if (list.contains(profile)) {
      list.remove(profile);
    } else {
      list.add(profile);
    }
    selectedProfiles = [...list];
    setState(() {});
  }
}
