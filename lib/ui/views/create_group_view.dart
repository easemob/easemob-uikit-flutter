// ignore_for_file: deprecated_member_use

import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

typedef WillCreateHandler = Future<CreateGroupInfo?> Function(
  BuildContext context,
  CreateGroupInfo? createGroupInfo,
  List<ChatUIKitProfile> selectedProfiles,
);

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
        willCreateHandler = arguments.willCreateHandler,
        createGroupInfo = arguments.createGroupInfo,
        controller = arguments.controller,
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
    this.willCreateHandler,
    this.attributes,
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
  final WillCreateHandler? willCreateHandler;
  final String? attributes;

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
                    ChatUIKitLocal.createGroupViewTitle.getString(context),
                    textScaleFactor: 1.0,
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
                trailing: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    if (selectedProfiles.isEmpty) {
                      return;
                    }
                    createGroup();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 5, 24, 5),
                    child: Text(
                      selectedProfiles.isEmpty
                          ? ChatUIKitLocal.createGroupViewCreate
                              .getString(context)
                          : '${ChatUIKitLocal.createGroupViewCreate.getString(context)}(${selectedProfiles.length})',
                      textScaleFactor: 1.0,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.color.isDark
                            ? theme.color.primaryColor6
                            : theme.color.primaryColor5,
                        fontWeight: theme.font.labelMedium.fontWeight,
                        fontSize: theme.font.labelMedium.fontSize,
                      ),
                    ),
                  ),
                ),
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
                              color: theme.color.isDark
                                  ? theme.color.primaryColor6
                                  : theme.color.primaryColor5,
                            )
                          : Icon(
                              Icons.check_box_outline_blank,
                              size: 28,
                              color: theme.color.isDark
                                  ? theme.color.neutralColor4
                                  : theme.color.neutralColor7,
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
        SearchUsersViewArguments(
          onTap: (ctx, profile) {
            Navigator.of(ctx).pop(profile);
          },
          canChangeSelected: selectedProfiles,
          searchHideText:
              ChatUIKitLocal.createGroupViewSearchContact.getString(context),
          searchData: list,
          enableMulti: true,
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

  void createGroup() async {
    CreateGroupInfo? info;
    if (widget.willCreateHandler != null) {
      info = await widget.willCreateHandler!(
        context,
        widget.createGroupInfo,
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
          selectedProfiles.map((e) => e.showName).join(','),
      desc: info?.groupDesc ?? widget.createGroupInfo?.groupDesc,
      options: GroupOptions(
        maxCount: 1000,
        style: GroupStyle.PrivateMemberCanInvite,
      ),
      inviteMembers: userIds,
    )
        .then((value) {
      Navigator.of(context).pop(value);
    }).catchError((e) {});
  }
}

class CreateGroupInfo {
  CreateGroupInfo({
    required this.groupName,
    this.groupDesc,
    this.groupAvatar,
  });

  final String groupName;
  final String? groupDesc;
  final String? groupAvatar;
}
