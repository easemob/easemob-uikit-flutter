import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactDetailsView extends StatefulWidget {
  ContactDetailsView.arguments(ContactDetailsViewArguments arguments,
      {super.key})
      : actions = arguments.actions,
        profile = arguments.profile,
        onMessageDidClear = arguments.onMessageDidClear,
        enableAppBar = arguments.enableAppBar,
        appBar = arguments.appBar,
        attributes = arguments.attributes;

  const ContactDetailsView({
    required this.profile,
    required this.actions,
    this.onMessageDidClear,
    this.appBar,
    this.enableAppBar = true,
    this.attributes,
    super.key,
  });

  final ChatUIKitProfile profile;
  final List<ChatUIKitActionModel> actions;
  final VoidCallback? onMessageDidClear;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final String? attributes;
  @override
  State<ContactDetailsView> createState() => _ContactDetailsViewState();
}

class _ContactDetailsViewState extends State<ContactDetailsView>
    with ChatUIKitProviderObserver {
  ValueNotifier<bool> isNotDisturb = ValueNotifier<bool>(false);
  ChatUIKitProfile? profile;
  late final List<ChatUIKitActionModel>? actions;
  @override
  void initState() {
    super.initState();
    assert(widget.actions.length <= 5,
        'The number of actions in the list cannot exceed 5');
    profile = widget.profile;
    actions = widget.actions;
    ChatUIKitProvider.instance.addObserver(this);
    isNotDisturb.value =
        ChatUIKitContext.instance.conversationIsMute(profile!.id);
    fetchInfo();
  }

  void fetchInfo() async {
    Conversation conversation = await ChatUIKit.instance.createConversation(
        conversationId: profile!.id, type: ConversationType.Chat);
    Map<String, ChatSilentModeResult> map = await ChatUIKit.instance
        .fetchSilentModel(conversations: [conversation]);
    isNotDisturb.value = map.values.first.remindType != ChatPushRemindType.ALL;
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    isNotDisturb.dispose();
    super.dispose();
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  void onProfilesUpdate(
    Map<String, ChatUIKitProfile> map,
  ) {
    if (map.keys.contains(profile?.id)) {
      safeSetState(() {
        profile = map[profile?.id];
      });
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

    Widget easeId = Text(
      'ID: ${profile!.id}',
      overflow: TextOverflow.ellipsis,
      textScaler: TextScaler.noScaling,
      maxLines: 1,
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
            ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.userIdCopied);
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
                  ? theme.color.neutralColor3
                  : theme.color.neutralColor95,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
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
      children: [
        const SizedBox(height: 20),
        avatar,
        const SizedBox(height: 12),
        name,
        const SizedBox(height: 4),
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
        ChatUIKitDetailsListViewItem(
          title:
              ChatUIKitLocal.contactDetailViewDoNotDisturb.getString(context),
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
                        type: ConversationType.Chat,
                        param: ChatSilentModeParam.remindType(
                            ChatPushRemindType.MENTION_ONLY));
                  } else {
                    await ChatUIKit.instance.clearSilentMode(
                        conversationId: profile!.id,
                        type: ConversationType.Chat);
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
              title: ChatUIKitLocal.contactDetailViewClearChatHistory
                  .getString(context)),
        ),
      ],
    );

    return content;
  }

  void clearAllHistory() async {
    final ret = await showChatUIKitDialog(
      title: ChatUIKitLocal.contactDetailViewClearChatHistoryAlertTitle
          .getString(context),
      content: ChatUIKitLocal.contactDetailViewClearChatHistoryAlertSubTitle
          .getString(context),
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal
              .contactDetailViewClearChatHistoryAlertButtonCancel
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
        conversationId: widget.profile.id,
      );
      widget.onMessageDidClear?.call();
    }
  }

  void showBottom() async {
    bool? ret = await showChatUIKitBottomSheet(
      cancelLabel: ChatUIKitLocal.contactDetailViewCancel.getString(context),
      context: context,
      items: [
        ChatUIKitBottomSheetItem.destructive(
          label: ChatUIKitLocal.contactDetailViewDelete.getString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
            return true;
          },
        ),
      ],
    );

    if (ret == true) {
      deleteContact();
    }
  }

  Widget statusAvatar() {
    // final theme = ChatUIKitTheme.of(context);
    return ChatUIKitAvatar(
      avatarUrl: profile!.avatarUrl,
      size: 100,
    );
    /* // 暂时不需要 Presence，等需要再打开
    return FutureBuilder(
      future:
          ChatUIKit.instance.fetchPresenceStatus(members: [profile!.id]),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return ChatUIKitAvatar(
            avatarUrl: profile!.avatarUrl,
            size: 100,
          );
        }
        Widget content;
        if (snapshot.data?.isNotEmpty == true) {
          Presence presence = snapshot.data![0];
          if (presence.statusDetails?.values.any((element) => element != 0) ==
              true) {
            content = Stack(
              children: [
                const SizedBox(width: 110, height: 110),
                ChatUIKitAvatar(
                  avatarUrl: profile!.avatarUrl,
                  size: 100,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 15,
                    height: 20,
                    color: theme.color.isDark
                        ? theme.color.primaryColor1
                        : theme.color.primaryColor98,
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 10,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: theme.color.isDark
                          ? theme.color.secondaryColor6
                          : theme.color.secondaryColor5,
                      border: Border.all(
                        color: theme.color.isDark
                            ? theme.color.primaryColor1
                            : theme.color.primaryColor98,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            );
          } else {
            content = ChatUIKitAvatar(
              avatarUrl: profile!.avatarUrl,
              size: 100,
            );
          }
        } else {
          content = ChatUIKitAvatar(
            avatarUrl: profile!.avatarUrl,
            size: 100,
          );
        }

        return content;
      },
    );
    */
  }

  void deleteContact() async {
    final ret = await showChatUIKitDialog(
      title:
          ChatUIKitLocal.contactDetailViewDeleteAlertTitle.getString(context),
      content: ChatUIKitLocal.contactDetailViewDeleteAlertSubTitle
          .getString(context),
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal.contactDetailViewDeleteAlertButtonCancel
              .getString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: ChatUIKitLocal.contactDetailViewDeleteAlertButtonConfirm
              .getString(context),
          onTap: () async {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
    if (ret == true) {
      ChatUIKit.instance.deleteContact(userId: profile!.id).then((value) {
        ChatUIKitRoute.popToRoot(context);
      }).catchError((e) {});
    }
  }
}
