import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroupDetailsView extends StatefulWidget {
  GroupDetailsView.arguments(
    GroupDetailsViewArguments arguments, {
    super.key,
  })  : profile = arguments.profile,
        appBar = arguments.appBar,
        enableAppBar = arguments.enableAppBar,
        actions = arguments.actions,
        onMessageDidClear = arguments.onMessageDidClear,
        viewObserver = arguments.viewObserver,
        contentWidgetBuilder = arguments.contentWidgetBuilder,
        attributes = arguments.attributes;

  const GroupDetailsView({
    required this.profile,
    required this.actions,
    this.appBar,
    this.enableAppBar = true,
    this.attributes,
    this.onMessageDidClear,
    this.contentWidgetBuilder,
    this.viewObserver,
    super.key,
  });
  final List<ChatUIKitModelAction> actions;
  final ChatUIKitProfile profile;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final String? attributes;
  final VoidCallback? onMessageDidClear;
  final WidgetBuilder? contentWidgetBuilder;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<GroupDetailsView> createState() => _GroupDetailsViewState();
}

class _GroupDetailsViewState extends State<GroupDetailsView>
    with GroupObserver, MultiObserver, ChatUIKitProviderObserver {
  ValueNotifier<bool> isNotDisturb = ValueNotifier<bool>(false);
  int memberCount = 0;
  Group? group;
  ChatUIKitProfile? profile;
  late final List<ChatUIKitModelAction>? actions;
  @override
  void initState() {
    super.initState();
    assert(widget.actions.length <= 5,
        'The number of actions in the list cannot exceed 5');

    ChatUIKit.instance.addObserver(this);
    ChatUIKitProvider.instance.addObserver(this);
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
    actions = widget.actions;
    profile = widget.profile;
    fetchGroupInfos();
  }

  void fetchGroupInfos() {
    isNotDisturb.value =
        ChatUIKitContext.instance.conversationIsMute(profile!.id);
    fetchGroup();
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    ChatUIKit.instance.removeObserver(this);
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {
    if (map.keys.contains(profile!.id)) {
      profile = map[profile!.id];
      safeSetState(() {});
    }
  }

  @override
  void onMemberJoinedFromGroup(String groupId, String member) {
    if (groupId == profile!.id) {
      memberCount += 1;
    }
  }

  @override
  void onMemberExitedFromGroup(String groupId, String member) {
    if (groupId == profile!.id) {
      memberCount -= 1;
    }
  }

  @override
  void onOwnerChangedFromGroup(
      String groupId, String newOwner, String oldOwner) {
    if (groupId == profile!.id) {
      fetchGroup();
    }
  }

  @override
  void onSpecificationDidUpdate(Group group) {
    if (group.groupId == profile!.id) {
      fetchGroup();
    }
  }

  @override
  void onGroupEvent(
      MultiDevicesEvent event, String groupId, List<String>? userIds) {
    if (groupId == profile!.id) {
      if (event == MultiDevicesEvent.GROUP_LEAVE) {
        ChatUIKitRoute.popToGroupsView(
          context,
          model: ChatUIKitRouteBackModel.remove(profile!.id),
        );
      }

      if (event == MultiDevicesEvent.GROUP_DESTROY) {
        ChatUIKitRoute.popToGroupsView(
          context,
          model: ChatUIKitRouteBackModel.remove(profile!.id),
        );
      }

      if (event == MultiDevicesEvent.GROUP_ASSIGN_OWNER) {
        fetchGroup();
      }
    }
  }

  void fetchGroup() async {
    try {
      // 本地不准，暂时不使用本地数据。
      // group = await ChatUIKit.instance.getGroup(groupId: profile!.id);
      group = await ChatUIKit.instance.fetchGroupInfo(groupId: profile!.id);
      memberCount = group?.memberCount ?? 0;
      safeSetState(() {});
    } on ChatError catch (e) {
      debugPrint(e.toString());
    }
  }

  void fetchSilentInfo() async {
    try {
      Conversation conversation = await ChatUIKit.instance.createConversation(
          conversationId: profile!.id, type: ConversationType.GroupChat);
      Map<String, ChatSilentModeResult> map = await ChatUIKit.instance
          .fetchSilentModel(conversations: [conversation]);
      isNotDisturb.value =
          map.values.first.remindType != ChatPushRemindType.ALL;
    } on ChatError catch (e) {
      debugPrint(e.toString());
    }
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
                  trailing: IconButton(
                    iconSize: 24,
                    color: theme.color.isDark
                        ? theme.color.neutralColor95
                        : theme.color.neutralColor3,
                    icon: const Icon(Icons.more_vert),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: showBottom,
                  ),
                ),
        body: _buildContent());

    return content;
  }

  Widget _buildContent() {
    final theme = ChatUIKitTheme.of(context);
    Widget avatar = statusAvatar();

    Widget name = Text(
      profile!.showName,
      overflow: TextOverflow.ellipsis,
      textScaler: TextScaler.noScaling,
      maxLines: 1,
      style: TextStyle(
        fontSize: theme.font.headlineLarge.fontSize,
        fontWeight: theme.font.headlineLarge.fontWeight,
        color: theme.color.isDark
            ? theme.color.neutralColor100
            : theme.color.neutralColor1,
      ),
    );

    Widget desc = group?.description?.isNotEmpty == true
        ? Text(
            group?.description ?? '',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            textScaler: TextScaler.noScaling,
            maxLines: 3,
            style: TextStyle(
              fontSize: theme.font.bodySmall.fontSize,
              fontWeight: theme.font.bodySmall.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor95
                  : theme.color.neutralColor3,
            ),
          )
        : const SizedBox();

    Widget easeId = Text(
      'ID: ${profile!.id}',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textScaler: TextScaler.noScaling,
      style: TextStyle(
        fontSize: theme.font.bodySmall.fontSize,
        fontWeight: theme.font.bodySmall.fontWeight,
        color: theme.color.isDark
            ? theme.color.neutralColor5
            : theme.color.neutralColor7,
      ),
    );

    Widget row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        easeId,
        const SizedBox(width: 2),
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Clipboard.setData(ClipboardData(text: profile!.id));
            ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.groupIdCopied);
          },
          child: Icon(
            Icons.file_copy_sharp,
            size: 16,
            color: theme.color.isDark
                ? theme.color.neutralColor5
                : theme.color.neutralColor7,
          ),
        ),
      ],
    );

    List<Widget> items = [];

    double width = () {
      if (widget.actions.length > 2) {
        return (MediaQuery.of(context).size.width -
                24 -
                widget.actions.length * 8 -
                MediaQuery.of(context).padding.left -
                MediaQuery.of(context).padding.right) /
            widget.actions.length;
      } else {
        return 114.0;
      }
    }();

    for (var action in widget.actions) {
      items.add(
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => action.onTap?.call(context),
          child: Container(
            margin: const EdgeInsets.only(left: 4, right: 4),
            height: 62,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.color.isDark
                  ? theme.color.neutralColor2
                  : theme.color.neutralColor95,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: action.iconSize?.width ?? 24,
                  height: action.iconSize?.height ?? 24,
                  child: Image.asset(
                    action.icon,
                    color: theme.color.isDark
                        ? theme.color.primaryColor6
                        : theme.color.primaryColor5,
                    package: action.packageName,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  action.title,
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: theme.font.bodySmall.fontSize,
                    fontWeight: theme.font.bodySmall.fontWeight,
                    color: theme.color.isDark
                        ? theme.color.primaryColor6
                        : theme.color.primaryColor5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget actionItem = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: items,
    );

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        avatar,
        const SizedBox(height: 12),
        name,
        const SizedBox(height: 4),
        if (group?.description?.isNotEmpty == true) desc,
        if (group?.description?.isNotEmpty == true) const SizedBox(height: 4),
        row,
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: actionItem,
        ),
        const SizedBox(height: 20),
      ],
    );

    content = ListView(
      children: [
        content,
        if (widget.contentWidgetBuilder != null)
          widget.contentWidgetBuilder!.call(context),
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            ChatUIKitRoute.pushOrPushNamed(
              context,
              ChatUIKitRouteNames.groupMembersView,
              GroupMembersViewArguments(
                profile: widget.profile,
                enableMemberOperation:
                    group?.permissionType == GroupPermissionType.Owner,
                attributes: widget.attributes,
              ),
            );
          },
          child: ChatUIKitDetailsListViewItem(
            title: ChatUIKitLocal.groupDetailViewMember.getString(context),
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  () {
                    if (memberCount == 0) {
                      return const SizedBox();
                    } else {
                      return Text(
                        '$memberCount',
                        textScaler: TextScaler.noScaling,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.color.isDark
                              ? theme.color.neutralColor6
                              : theme.color.neutralColor5,
                          fontSize: theme.font.labelLarge.fontSize,
                          fontWeight: theme.font.labelLarge.fontWeight,
                        ),
                      );
                    }
                  }(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: theme.color.isDark
                        ? theme.color.neutralColor5
                        : theme.color.neutralColor7,
                    size: 18,
                  )
                ],
              ),
            ),
          ),
        ),
        ChatUIKitDetailsListViewItem(
          title: ChatUIKitLocal.groupDetailViewDoNotDisturb.getString(context),
          trailing: ValueListenableBuilder(
            valueListenable: isNotDisturb,
            builder: (context, value, child) {
              return CupertinoSwitch(
                value: isNotDisturb.value,
                activeColor: theme.color.isDark
                    ? theme.color.primaryColor6
                    : theme.color.primaryColor5,
                trackColor: theme.color.isDark
                    ? theme.color.neutralColor3
                    : theme.color.neutralColor9,
                onChanged: (value) async {
                  if (value == true) {
                    await ChatUIKit.instance.setSilentMode(
                        conversationId: profile!.id,
                        type: ConversationType.GroupChat,
                        param: ChatSilentModeParam.remindType(
                            ChatPushRemindType.MENTION_ONLY));
                  } else {
                    await ChatUIKit.instance.clearSilentMode(
                        conversationId: profile!.id,
                        type: ConversationType.GroupChat);
                  }
                  safeSetState(() {
                    isNotDisturb.value = value;
                  });
                },
              );
            },
          ),
        ),
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: clearAllHistory,
          child: ChatUIKitDetailsListViewItem(
              title: ChatUIKitLocal.groupDetailViewClearChatHistory
                  .getString(context)),
        ),
        if (group?.permissionType == GroupPermissionType.Owner) ...[
          Container(
            height: 20,
            color: theme.color.isDark
                ? theme.color.neutralColor3
                : theme.color.neutralColor95,
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              changeGroupName();
            },
            child: ChatUIKitDetailsListViewItem(
              title: ChatUIKitLocal.groupDetailViewGroupName.getString(context),
              trailing: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      group?.name ?? "",
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.noScaling,
                      maxLines: 1,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: theme.color.isDark
                            ? theme.color.neutralColor6
                            : theme.color.neutralColor5,
                        fontSize: theme.font.labelLarge.fontSize,
                        fontWeight: theme.font.labelLarge.fontWeight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: theme.color.isDark
                        ? theme.color.neutralColor5
                        : theme.color.neutralColor7,
                    size: 18,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              changeGroupDesc();
            },
            child: ChatUIKitDetailsListViewItem(
              title:
                  ChatUIKitLocal.groupDetailViewDescription.getString(context),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      group?.description ?? "",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(
                        color: theme.color.isDark
                            ? theme.color.neutralColor6
                            : theme.color.neutralColor5,
                        fontSize: theme.font.labelLarge.fontSize,
                        fontWeight: theme.font.labelLarge.fontWeight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: theme.color.isDark
                        ? theme.color.neutralColor5
                        : theme.color.neutralColor7,
                    size: 18,
                  )
                ],
              ),
            ),
          ),
        ]
      ],
    );
    content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: content,
    );
    return content;
  }

  void clearAllHistory() async {
    final ret = await showChatUIKitDialog(
      title: ChatUIKitLocal.groupDetailViewClearChatHistory.getString(context),
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal.groupDetailViewClearChatHistoryAlertButtonCancel
              .getString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: ChatUIKitLocal
              .contactDetailViewClearChatHistoryAlertButtonConfirm
              .getString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (ret == true) {
      await ChatUIKit.instance.deleteLocalConversation(
        conversationId: profile!.id,
      );

      widget.onMessageDidClear?.call();
    }
  }

  void showBottom() async {
    List<ChatUIKitBottomSheetItem> list = [];
    if (group?.permissionType == GroupPermissionType.Owner) {
      list.add(
        ChatUIKitBottomSheetItem.normal(
          label: ChatUIKitLocal.groupDetailViewTransferGroup.getString(context),
          onTap: () async {
            Navigator.of(context).pop();
            changeOwner();
          },
        ),
      );
      list.add(
        ChatUIKitBottomSheetItem.destructive(
          label: ChatUIKitLocal.groupDetailViewDisbandGroup.getString(context),
          onTap: () async {
            Navigator.of(context).pop();
            destroyGroup();
          },
        ),
      );
    } else {
      list.add(
        ChatUIKitBottomSheetItem.destructive(
          label: ChatUIKitLocal.groupDetailViewLeaveGroup.getString(context),
          onTap: () async {
            Navigator.of(context).pop();
            leaveGroup();
          },
        ),
      );
    }

    showChatUIKitBottomSheet(
      cancelLabel: ChatUIKitLocal.groupDetailViewCancel.getString(context),
      context: context,
      items: list,
    );
  }

  Widget statusAvatar() {
    // 暂时不需要订阅
    return ChatUIKitAvatar(
      avatarUrl: profile!.avatarUrl,
      size: 100,
    );
  }

  void destroyGroup() async {
    final ret = await showChatUIKitDialog(
      title: ChatUIKitLocal.groupDetailViewDisbandAlertTitle.getString(context),
      content:
          ChatUIKitLocal.groupDetailViewDisbandAlertSubTitle.getString(context),
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal.groupDetailViewDisbandAlertButtonCancel
              .getString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: ChatUIKitLocal.groupDetailViewDisbandAlertButtonConfirm
              .getString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (ret == true) {
      ChatUIKit.instance.destroyGroup(groupId: profile!.id).then((value) {
        ChatUIKitRoute.popToGroupsView(
          context,
          model: ChatUIKitRouteBackModel.remove(profile!.id),
        );
      }).catchError((e) {});
    }
  }

  void leaveGroup() async {
    final ret = await showChatUIKitDialog(
      title: ChatUIKitLocal.groupDetailViewLeaveAlertTitle.getString(context),
      content:
          ChatUIKitLocal.groupDetailViewLeaveAlertSubTitle.getString(context),
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal.groupDetailViewLeaveAlertButtonCancel
              .getString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: ChatUIKitLocal.groupDetailViewLeaveAlertButtonConfirm
              .getString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (ret == true) {
      ChatUIKit.instance.leaveGroup(groupId: profile!.id).then((value) {
        ChatUIKitRoute.popToGroupsView(
          context,
          model: ChatUIKitRouteBackModel.remove(profile!.id),
        );
      }).catchError((e) {});
    }
  }

  void changeOwner() async {
    final ret = await ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.groupChangeOwnerView,
      GroupChangeOwnerViewArguments(
        groupId: profile!.id,
        attributes: widget.attributes,
      ),
    );

    if (ret == true) {
      fetchGroup();
    }
  }

  void changeGroupName() {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.changeInfoView,
      ChangeInfoViewArguments(
        title: ChatUIKitLocal.groupDetailViewGroupName.getString(context),
        maxLength: 32,
        attributes: widget.attributes,
        inputTextCallback: () async {
          if (group?.groupId != null) {
            return group!.name ?? '';
          }
          return null;
        },
      ),
    ).then((value) {
      if (value is String) {
        ChatUIKit.instance
            .changeGroupName(groupId: group!.groupId, name: value)
            .then((_) {
          fetchGroup();
        }).catchError((e) {});
      }
    });
  }

  void changeGroupDesc() {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.changeInfoView,
      ChangeInfoViewArguments(
        title: ChatUIKitLocal.groupDetailViewDescription.getString(context),
        maxLength: 256,
        attributes: widget.attributes,
        inputTextCallback: () async {
          if (group?.groupId != null) {
            return group!.description ?? '';
          }
          return null;
        },
      ),
    ).then((value) {
      if (value is String) {
        ChatUIKit.instance
            .changeGroupDescription(groupId: group!.groupId, desc: value)
            .then((_) {
          fetchGroup();
        }).catchError((e) {
          debugPrint(e.toString());
        });
      }
    });
  }
}
