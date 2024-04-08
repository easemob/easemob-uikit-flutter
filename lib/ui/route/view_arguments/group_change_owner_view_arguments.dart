import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class GroupChangeOwnerViewArguments implements ChatUIKitViewArguments {
  GroupChangeOwnerViewArguments({
    required this.groupId,
    this.listViewItemBuilder,
    this.onSearchTap,
    this.searchBarHideText,
    this.listViewBackground,
    this.onItemTap,
    this.onItemLongPress,
    this.appBar,
    this.controller,
    this.loadErrorMessage,
    this.enableAppBar = true,
    this.title,
    this.viewObserver,
    this.attributes,
  });

  final String groupId;

  final GroupMemberListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onItemTap;
  final void Function(BuildContext context, ContactItemModel model)? onItemLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableAppBar;
  final String? title;

  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  GroupChangeOwnerViewArguments copyWith({
    String? groupId,
    GroupMemberListViewController? controller,
    ChatUIKitAppBar? appBar,
    void Function(List<ContactItemModel> data)? onSearchTap,
    ChatUIKitContactItemBuilder? listViewItemBuilder,
    void Function(BuildContext context, ContactItemModel model)? onItemTap,
    void Function(BuildContext context, ContactItemModel model)? onItemLongPress,
    String? searchBarHideText,
    Widget? listViewBackground,
    String? loadErrorMessage,
    bool? enableAppBar,
    String? title,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return GroupChangeOwnerViewArguments(
      groupId: groupId ?? this.groupId,
      controller: controller ?? this.controller,
      appBar: appBar ?? this.appBar,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
      onItemTap: onItemTap ?? this.onItemTap,
      onItemLongPress: onItemLongPress ?? this.onItemLongPress,
      searchBarHideText: searchBarHideText ?? this.searchBarHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      loadErrorMessage: loadErrorMessage ?? this.loadErrorMessage,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      title: title ?? this.title,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
