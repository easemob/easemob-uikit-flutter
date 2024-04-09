import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class CreateGroupViewArguments implements ChatUIKitViewArguments {
  CreateGroupViewArguments({
    this.listViewItemBuilder,
    this.onSearchTap,
    this.searchBarHideText,
    this.listViewBackground,
    this.onItemTap,
    this.onItemLongPress,
    this.appBar,
    this.controller,
    this.enableAppBar = true,
    this.createGroupHandler,
    this.createGroupInfo,
    this.title,
    this.viewObserver,
    this.attributes,
    this.appBarTrailingActionsBuilder,
  });

  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(ContactItemModel model)? onItemTap;
  final void Function(ContactItemModel model)? onItemLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final CreateGroupHandler? createGroupHandler;
  final CreateGroupInfo? createGroupInfo;
  final String? title;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;

  CreateGroupViewArguments copyWith({
    ContactListViewController? controller,
    ChatUIKitAppBar? appBar,
    void Function(List<ContactItemModel> data)? onSearchTap,
    ChatUIKitContactItemBuilder? listViewItemBuilder,
    void Function(ContactItemModel model)? onItemTap,
    void Function(ContactItemModel model)? onItemLongPress,
    String? searchBarHideText,
    Widget? listViewBackground,
    bool? enableAppBar,
    CreateGroupHandler? createGroupHandler,
    CreateGroupInfo? createGroupInfo,
    void Function(Group? group, ChatError? error)? onCreateGroup,
    String? title,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
    ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder,
  }) {
    return CreateGroupViewArguments(
        controller: controller ?? this.controller,
        appBar: appBar ?? this.appBar,
        onSearchTap: onSearchTap ?? this.onSearchTap,
        listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
        onItemTap: onItemTap ?? this.onItemTap,
        onItemLongPress: onItemLongPress ?? this.onItemLongPress,
        searchBarHideText: searchBarHideText ?? this.searchBarHideText,
        listViewBackground: listViewBackground ?? this.listViewBackground,
        enableAppBar: enableAppBar ?? this.enableAppBar,
        createGroupHandler: createGroupHandler ?? this.createGroupHandler,
        createGroupInfo: createGroupInfo ?? this.createGroupInfo,
        title: title ?? this.title,
        viewObserver: viewObserver ?? this.viewObserver,
        attributes: attributes ?? this.attributes,
        appBarTrailingActionsBuilder: appBarTrailingActionsBuilder ?? this.appBarTrailingActionsBuilder);
  }
}
