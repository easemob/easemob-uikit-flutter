import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ContactsView extends StatefulWidget {
  ContactsView.arguments(
    ContactsViewArguments arguments, {
    super.key,
  })  : listViewItemBuilder = arguments.listViewItemBuilder,
        onSearchTap = arguments.onSearchTap,
        searchHideText = arguments.searchHideText,
        listViewBackground = arguments.listViewBackground,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        appBar = arguments.appBar,
        controller = arguments.controller,
        enableAppBar = arguments.enableAppBar,
        beforeItems = arguments.beforeItems,
        afterItems = arguments.afterItems,
        loadErrorMessage = arguments.loadErrorMessage,
        title = arguments.title,
        enableSearchBar = arguments.enableSearchBar,
        attributes = arguments.attributes;

  const ContactsView({
    this.appBar,
    this.enableAppBar = true,
    this.enableSearchBar = true,
    this.onSearchTap,
    this.searchHideText,
    this.listViewBackground,
    this.onTap,
    this.onLongPress,
    this.listViewItemBuilder,
    this.controller,
    this.loadErrorMessage,
    this.beforeItems,
    this.afterItems,
    this.title,
    this.attributes,
    super.key,
  });

  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final String? title;
  final void Function(List<ContactItemModel> data)? onSearchTap;
  final bool enableSearchBar;
  final List<ChatUIKitListViewMoreItem>? beforeItems;
  final List<ChatUIKitListViewMoreItem>? afterItems;
  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final String? attributes;

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> with ContactObserver {
  late final ContactListViewController controller;

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    controller = widget.controller ?? ContactListViewController();
  }

  @override
  void dispose() {
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
      appBar: widget.appBar ??
          ChatUIKitAppBar(
            title: widget.title ?? 'Contacts',
            titleTextStyle: TextStyle(
              color: theme.color.isDark
                  ? theme.color.primaryColor6
                  : theme.color.primaryColor5,
              fontSize: theme.font.titleLarge.fontSize,
              fontWeight: FontWeight.w900,
            ),
            showBackButton: false,
            leading: Container(
              margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              child: ChatUIKitAvatar.current(
                size: 32,
                avatarUrl:
                    ChatUIKitProvider.instance.currentUserData?.avatarUrl,
              ),
            ),
            trailing: IconButton(
              iconSize: 24,
              color: theme.color.isDark
                  ? theme.color.neutralColor95
                  : theme.color.neutralColor3,
              icon: const Icon(Icons.person_add_alt_1_outlined),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: addContact,
            ),
          ),
      body: SafeArea(
        child: ContactListView(
          controller: controller,
          itemBuilder: widget.listViewItemBuilder,
          beforeWidgets: widget.beforeItems ?? beforeWidgets,
          afterWidgets: widget.afterItems,
          searchHideText: widget.searchHideText,
          background: widget.listViewBackground,
          onTap: widget.onTap ?? tapContactInfo,
          onLongPress: widget.onLongPress,
          onSearchTap: widget.onSearchTap ?? onSearchTap,
          enableSearchBar: widget.enableSearchBar,
          errorMessage: widget.loadErrorMessage,
        ),
      ),
    );

    return content;
  }

  List<ChatUIKitListViewMoreItem> get beforeWidgets {
    return [
      ChatUIKitListViewMoreItem(
        title: ChatUIKitLocal.contactsViewNewRequests.getString(context),
        onTap: () {
          ChatUIKitRoute.pushOrPushNamed(
                  context,
                  ChatUIKitRouteNames.newRequestsView,
                  NewRequestsViewArguments(attributes: widget.attributes))
              .then((value) {
            controller.refresh();
          });
        },
        trailing: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: ChatUIKitBadge(ChatUIKitContext.instance.requestList().length),
        ),
      ),
      ChatUIKitListViewMoreItem(
          title: ChatUIKitLocal.contactsViewGroups.getString(context),
          onTap: () {
            ChatUIKitRoute.pushOrPushNamed(
                context,
                ChatUIKitRouteNames.groupsView,
                GroupsViewArguments(attributes: widget.attributes));
          }),
    ];
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
        searchHideText:
            ChatUIKitLocal.conversationsViewSearchHint.getString(context),
        searchData: list,
      ),
    ).then((value) {
      if (value != null && value is ChatUIKitProfile) {
        ChatUIKitRoute.pushOrPushNamed(
          context,
          ChatUIKitRouteNames.contactDetailsView,
          ContactDetailsViewArguments(profile: value, actions: [
            ChatUIKitActionModel(
              title: ChatUIKitLocal.contactDetailViewSend.getString(context),
              icon: 'assets/images/chat.png',
              packageName: ChatUIKitImageLoader.packageName,
              onTap: (context) {
                ChatUIKitRoute.pushOrPushNamed(
                  context,
                  ChatUIKitRouteNames.messagesView,
                  MessagesViewArguments(
                    profile: value,
                    attributes: widget.attributes,
                  ),
                );
              },
            ),
          ]),
        ).then((value) {
          ChatUIKit.instance.onConversationsUpdate();
        });
      }
    });
  }

  void tapContactInfo(BuildContext context, ContactItemModel model) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.contactDetailsView,
      ContactDetailsViewArguments(profile: model.profile, actions: [
        ChatUIKitActionModel(
          title: ChatUIKitLocal.contactDetailViewSend.getString(context),
          icon: 'assets/images/chat.png',
          packageName: ChatUIKitImageLoader.packageName,
          onTap: (context) {
            ChatUIKitRoute.pushOrPushNamed(
              context,
              ChatUIKitRouteNames.messagesView,
              MessagesViewArguments(
                profile: model.profile,
                attributes: widget.attributes,
              ),
            );
          },
        ),
      ]),
    ).then((value) {
      ChatUIKit.instance.onConversationsUpdate();
    });
  }

  void addContact() async {
    String? userId = await showChatUIKitDialog(
      title: ChatUIKitLocal.contactsAddContactAlertTitle.getString(context),
      content:
          ChatUIKitLocal.contactsAddContactAlertSubTitle.getString(context),
      context: context,
      hintsText: [
        ChatUIKitLocal.contactsAddContactAlertHintText.getString(context)
      ],
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal.contactsAddContactAlertButtonCancel
              .getString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.inputsConfirm(
          label: ChatUIKitLocal.contactsAddContactAlertButtonConfirm
              .getString(context),
          onInputsTap: (inputs) async {
            Navigator.of(context).pop(inputs.first);
          },
        ),
      ],
    );

    if (userId?.isNotEmpty == true) {
      try {
        await ChatUIKit.instance.sendContactRequest(userId: userId!);
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  @override
  // 用于更新好友请求未读数
  void onContactRequestReceived(String userId, String? reason) {
    setState(() {});
  }

  // 用户更新好友请求未读数
  @override
  void onContactAdded(String userId) {
    if (mounted) {
      // 用户更新好友请求未读数
      setState(() {});
      // 刷新好友列表
      controller.reload();
    }
  }

  // 用于更新删除好友后的列表刷新
  @override
  void onContactDeleted(String userId) {
    if (mounted) {
      controller.reload();
    }
  }
}
