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
        viewObserver = arguments.viewObserver,
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
    this.viewObserver,
    super.key,
  });

  /// 联系人列表控制器，用于控制联系人列表数据，如果不设置将会自动创建。详细参考 [ContactListViewController]。
  final ContactListViewController? controller;

  /// 自定义AppBar, 如果设置后将会替换默认的AppBar。详细参考 [ChatUIKitAppBar]。
  final ChatUIKitAppBar? appBar;

  /// 是否显示AppBar, 默认为 `true`。 当为 `false` 时将不会显示AppBar。同时也会影响到是否显示标题。
  final bool enableAppBar;

  /// 自定义标题。
  final String? title;

  /// 点击搜索按钮的回调，点击后会把当前的联系人列表数据传递过来。如果不设置默认会跳转到搜索页面。具体参考 [SearchView]。
  final void Function(List<ContactItemModel> data)? onSearchTap;

  /// 是否开启搜索框，默认为 `true`。如果设置为 `false` 将不会显示搜索框。
  final bool enableSearchBar;

  /// 联系人列表之前的数据。
  final List<ChatUIKitListViewMoreItem>? beforeItems;

  /// 联系人列表之后的数据。
  final List<ChatUIKitListViewMoreItem>? afterItems;

  /// 联系人列表的 `item` 构建器，如果设置后需要显示联系人时会直接回调，如果不处理可以返回 `null`。
  final ChatUIKitContactItemBuilder? listViewItemBuilder;

  /// 点击联系人列表的回调，点击后会把当前的联系人数据传递过来。具体参考 [ContactItemModel]。 如果不是设置默认会跳转到联系人详情页面。具体参考 [ContactDetailsView]。
  final void Function(BuildContext context, ContactItemModel model)? onTap;

  /// 长按联系人列表的回调，长按后会把当前的联系人数据传递过来。具体参考 [ContactItemModel]。
  final void Function(BuildContext context, ContactItemModel model)? onLongPress;

  /// 联系人搜索框的隐藏文字。
  final String? searchHideText;

  /// 联系人列表的背景，联系人为空时会显示，如果设置后将会替换默认的背景。
  final Widget? listViewBackground;

  /// 联系人列表的加载错误提示，如果设置后将会替换默认的错误提示。
  final String? loadErrorMessage;

  /// View 附加属性，设置后的内容将会带入到下一个页面。
  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> with ContactObserver {
  late final ContactListViewController controller;

  @override
  void initState() {
    super.initState();
    widget.viewObserver?.addListener(() {
      setState(() {});
    });

    ChatUIKit.instance.addObserver(this);
    controller = widget.controller ?? ContactListViewController();
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
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
                title: widget.title ?? 'Contacts',
                titleTextStyle: TextStyle(
                  color: theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5,
                  fontSize: theme.font.titleLarge.fontSize,
                  fontWeight: FontWeight.w900,
                ),
                showBackButton: false,
                leading: Container(
                  margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: ChatUIKitAvatar.current(
                    size: 32,
                    avatarUrl: ChatUIKitProvider.instance.currentUserProfile?.avatarUrl,
                  ),
                ),
                trailing: IconButton(
                  iconSize: 24,
                  color: theme.color.isDark ? theme.color.neutralColor95 : theme.color.neutralColor3,
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
          onTap: widget.onTap ??
              (ctx, model) {
                tapContactInfo(ctx, model.profile);
              },
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
        title: ChatUIKitLocal.contactsViewNewRequests.localString(context),
        onTap: () {
          ChatUIKitRoute.pushOrPushNamed(
                  context, ChatUIKitRouteNames.newRequestsView, NewRequestsViewArguments(attributes: widget.attributes))
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
          title: ChatUIKitLocal.contactsViewGroups.localString(context),
          onTap: () {
            ChatUIKitRoute.pushOrPushNamed(
                context, ChatUIKitRouteNames.groupsView, GroupsViewArguments(attributes: widget.attributes));
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
      SearchViewArguments(
          onTap: (ctx, profile) {
            Navigator.of(ctx).pop(profile);
          },
          searchHideText: ChatUIKitLocal.conversationsViewSearchHint.localString(context),
          searchData: list,
          attributes: widget.attributes),
    ).then((value) {
      if (value != null && value is ChatUIKitProfile) {
        tapContactInfo(context, value);
      }
    });
  }

  void tapContactInfo(BuildContext context, ChatUIKitProfile profile) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.contactDetailsView,
      ContactDetailsViewArguments(
          profile: profile,
          actionsBuilder: (context) {
            return [
              ChatUIKitModelAction(
                title: ChatUIKitLocal.contactDetailViewSend.localString(context),
                icon: 'assets/images/chat.png',
                iconSize: const Size(32, 32),
                packageName: ChatUIKitImageLoader.packageName,
                onTap: (context) {
                  ChatUIKitRoute.pushOrPushNamed(
                    context,
                    ChatUIKitRouteNames.messagesView,
                    MessagesViewArguments(
                      profile: profile,
                      attributes: widget.attributes,
                    ),
                  );
                },
              ),
              ChatUIKitModelAction(
                title: ChatUIKitLocal.contactDetailViewSearch.localString(context),
                icon: 'assets/images/search_history.png',
                packageName: ChatUIKitImageLoader.packageName,
                iconSize: const Size(32, 32),
                onTap: (context) {
                  ChatUIKitRoute.pushOrPushNamed(
                    context,
                    ChatUIKitRouteNames.searchHistoryView,
                    SearchHistoryViewArguments(
                      profile: profile,
                      attributes: widget.attributes,
                    ),
                  ).then((value) {
                    if (value != null && value is Message) {
                      ChatUIKitRoute.pushOrPushNamed(
                        context,
                        ChatUIKitRouteNames.messagesView,
                        MessagesViewArguments(
                          profile: profile,
                          attributes: widget.attributes,
                          controller: MessageListViewController(
                            profile: profile,
                            searchedMsg: value,
                          ),
                        ),
                      );
                    }
                  });
                },
              ),
            ];
          }),
    ).then((value) {
      ChatUIKit.instance.onConversationsUpdate();
    });
  }

  void addContact() async {
    String? userId = await showChatUIKitDialog(
      title: ChatUIKitLocal.contactsAddContactAlertTitle.localString(context),
      content: ChatUIKitLocal.contactsAddContactAlertSubTitle.localString(context),
      context: context,
      hintsText: [ChatUIKitLocal.contactsAddContactAlertHintText.localString(context)],
      items: [
        ChatUIKitDialogItem.cancel(
          label: ChatUIKitLocal.contactsAddContactAlertButtonCancel.localString(context),
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.inputsConfirm(
          label: ChatUIKitLocal.contactsAddContactAlertButtonConfirm.localString(context),
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
