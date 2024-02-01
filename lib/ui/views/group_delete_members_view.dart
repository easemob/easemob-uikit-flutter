// ignore_for_file: deprecated_member_use
import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class GroupDeleteMembersView extends StatefulWidget {
  GroupDeleteMembersView.arguments(GroupDeleteMembersViewArguments arguments,
      {super.key})
      : listViewItemBuilder = arguments.listViewItemBuilder,
        onSearchTap = arguments.onSearchTap,
        searchBarHideText = arguments.searchBarHideText,
        listViewBackground = arguments.listViewBackground,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        appBar = arguments.appBar,
        controller = arguments.controller,
        enableAppBar = arguments.enableAppBar,
        groupId = arguments.groupId,
        attributes = arguments.attributes;

  const GroupDeleteMembersView({
    required this.groupId,
    this.listViewItemBuilder,
    this.onSearchTap,
    this.searchBarHideText,
    this.listViewBackground,
    this.onTap,
    this.onLongPress,
    this.appBar,
    this.controller,
    this.enableAppBar = true,
    this.attributes,
    super.key,
  });

  final String groupId;
  final GroupMemberListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final String? attributes;

  @override
  State<GroupDeleteMembersView> createState() => _GroupDeleteMembersViewState();
}

class _GroupDeleteMembersViewState extends State<GroupDeleteMembersView> {
  List<ChatUIKitProfile> selectedProfiles = [];
  late final GroupMemberListViewController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        GroupMemberListViewController(
          groupId: widget.groupId,
          includeOwner: false,
        );
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
                    ChatUIKitLocal.groupDeleteMembersViewTitle
                        .getString(context),
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
                    ensureDelete();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 5, 24, 5),
                    child: Text(
                      selectedProfiles.isEmpty
                          ? ChatUIKitLocal.groupDeleteMembersViewDelete
                              .getString(context)
                          : '${ChatUIKitLocal.groupDeleteMembersViewDelete.getString(context)}(${selectedProfiles.length})',
                      textScaleFactor: 1.0,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.color.isDark
                            ? selectedProfiles.isEmpty
                                ? theme.color.neutralColor5
                                : theme.color.errorColor6
                            : selectedProfiles.isEmpty
                                ? theme.color.neutralColor7
                                : theme.color.errorColor5,
                        fontWeight: theme.font.labelMedium.fontWeight,
                        fontSize: theme.font.labelMedium.fontSize,
                      ),
                    ),
                  ),
                ),
              ),
      body: GroupMemberListView(
        groupId: widget.groupId,
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

  void ensureDelete() async {
    showChatUIKitDialog(
      context: context,
      title: ChatUIKitLocal.groupDeleteMembersViewAlertTitle.getString(context),
      content:
          ChatUIKitLocal.groupDeleteMembersViewAlertSubTitle.getString(context),
      items: [
        ChatUIKitDialogItem.cancel(
            label: ChatUIKitLocal.groupDeleteMembersViewAlertButtonCancel
                .getString(context)),
        ChatUIKitDialogItem.confirm(
            label: ChatUIKitLocal.groupDeleteMembersViewAlertButtonConfirm
                .getString(context),
            onTap: () async => Navigator.of(context).pop(true))
      ],
    ).then((value) {
      if (value == true) {
        Navigator.of(context).pop(selectedProfiles);
      }
    });
  }
}
