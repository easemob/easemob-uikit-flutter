import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class CreateGroupView extends StatefulWidget {
  CreateGroupView.arguments(
    CreateGroupViewArguments arguments, {
    super.key,
  })  : listViewItemBuilder = arguments.listViewItemBuilder,
        onSearchTap = arguments.onSearchTap,
        searchBarHideText = arguments.searchBarHideText,
        listViewBackground = arguments.listViewBackground,
        onItemTap = arguments.onItemTap,
        onItemLongPress = arguments.onItemLongPress,
        appBar = arguments.appBar,
        enableAppBar = arguments.enableAppBar,
        createHandler = arguments.createGroupHandler,
        createGroupInfo = arguments.createGroupInfo,
        controller = arguments.controller,
        title = arguments.title,
        viewObserver = arguments.viewObserver,
        appBarTrailingActionsBuilder = arguments.appBarTrailingActionsBuilder,
        attributes = arguments.attributes;

  const CreateGroupView({
    this.listViewItemBuilder,
    this.onSearchTap,
    this.createGroupInfo,
    this.searchBarHideText,
    this.listViewBackground,
    this.onItemTap,
    this.onItemLongPress,
    this.appBar,
    this.controller,
    this.enableAppBar = true,
    this.createHandler,
    this.title,
    this.attributes,
    this.viewObserver,
    this.appBarTrailingActionsBuilder,
    super.key,
  });

  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;
  final CreateGroupInfo? createGroupInfo;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(ContactItemModel model)? onItemTap;
  final void Function(ContactItemModel model)? onItemLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final String? title;
  final CreateGroupHandler? createHandler;
  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;

  @override
  State<CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
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
                centerTitle: false,
                title: widget.title ?? ChatUIKitLocal.createGroupViewTitle.localString(context),
                trailingActions: () {
                  List<ChatUIKitAppBarTrailingAction> actions = [
                    ChatUIKitAppBarTrailingAction(
                      actionType: ChatUIKitActionType.create,
                      onTap: (context) {
                        if (selectedProfiles.isEmpty) {
                          return;
                        }
                        createGroup();
                      },
                      child: Text(
                        selectedProfiles.isEmpty
                            ? ChatUIKitLocal.createGroupViewCreate.localString(context)
                            : '${ChatUIKitLocal.createGroupViewCreate.localString(context)}(${selectedProfiles.length})',
                        textScaler: TextScaler.noScaling,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
                          fontWeight: theme.font.labelMedium.fontWeight,
                          fontSize: theme.font.labelMedium.fontSize,
                        ),
                      ),
                    ),
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
                  tapContactInfo(model.profile);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 19.5, right: 15.5),
                  child: Row(
                    children: [
                      selectedProfiles.contains(model.profile)
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
                canChangeSelected: selectedProfiles,
                searchHideText: ChatUIKitLocal.createGroupViewSearchContact.localString(context),
                searchData: list,
                enableMulti: true,
                attributes: widget.attributes))
        .then(
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

  void createGroup() async {
    CreateGroupInfo? info;
    if (widget.createHandler != null) {
      info = await widget.createHandler!(
        context,
        selectedProfiles,
      );
      if (info == null) {
        return;
      }
    }
    List<String> userIds = selectedProfiles.map((e) => e.id).toList();
    ChatUIKit.instance
        .createGroup(
      groupName: info?.groupName ??
          widget.createGroupInfo?.groupName ??
          [
            ...selectedProfiles + [ChatUIKitProvider.instance.currentUserProfile!]
          ].map((e) => e.showName).join(','),
      desc: info?.groupDesc ?? widget.createGroupInfo?.groupDesc,
      options: GroupOptions(
        maxCount: 1000,
        style: GroupStyle.PrivateMemberCanInvite,
      ),
      inviteMembers: userIds,
    )
        .then((value) {
      if (info?.onGroupCreateCallback != null) {
        info?.onGroupCreateCallback?.call(value, null);
      } else {
        Navigator.of(context).pop(value);
      }
    }).catchError((e) {
      info?.onGroupCreateCallback?.call(null, e);
    });
  }
}

class CreateGroupInfo {
  CreateGroupInfo({
    required this.groupName,
    this.groupDesc,
    this.groupAvatar,
    this.onGroupCreateCallback,
  });

  final String groupName;
  final String? groupDesc;
  final String? groupAvatar;
  final GroupCreateCallback? onGroupCreateCallback;
}
