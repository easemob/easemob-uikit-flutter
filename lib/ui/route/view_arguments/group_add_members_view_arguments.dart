import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class GroupAddMembersViewArguments implements ChatUIKitViewArguments {
  GroupAddMembersViewArguments({
    required this.groupId,
    this.controller,
    this.appBar,
    this.onSearchTap,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.searchBarHideText,
    this.listViewBackground,
    this.inGroupMembers,
    this.title,
    this.enableAppBar = true,
    this.viewObserver,
    this.attributes,
    this.appBarTrailingActionsBuilder,
  });

  final String groupId;
  final List<ChatUIKitProfile>? inGroupMembers;
  final ContactListViewController? controller;
  final PreferredSizeWidget? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final String? title;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;
  GroupAddMembersViewArguments copyWith(
      {String? groupId,
      List<ChatUIKitProfile>? inGroupMembers,
      ContactListViewController? controller,
      ChatUIKitAppBar? appBar,
      void Function(List<ContactItemModel> data)? onSearchTap,
      ChatUIKitContactItemBuilder? listViewItemBuilder,
      void Function(BuildContext context, ContactItemModel model)? onTap,
      void Function(BuildContext context, ContactItemModel model)? onLongPress,
      String? searchBarHideText,
      Widget? listViewBackground,
      bool? enableAppBar,
      String? title,
      ChatUIKitViewObserver? viewObserver,
      String? attributes,
      ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder}) {
    return GroupAddMembersViewArguments(
        groupId: groupId ?? this.groupId,
        inGroupMembers: inGroupMembers ?? this.inGroupMembers,
        controller: controller ?? this.controller,
        appBar: appBar ?? this.appBar,
        onSearchTap: onSearchTap ?? this.onSearchTap,
        listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
        onTap: onTap ?? this.onTap,
        onLongPress: onLongPress ?? this.onLongPress,
        searchBarHideText: searchBarHideText ?? this.searchBarHideText,
        listViewBackground: listViewBackground ?? this.listViewBackground,
        enableAppBar: enableAppBar ?? this.enableAppBar,
        title: title ?? this.title,
        viewObserver: viewObserver ?? this.viewObserver,
        attributes: attributes ?? this.attributes,
        appBarTrailingActionsBuilder:
            appBarTrailingActionsBuilder ?? this.appBarTrailingActionsBuilder);
  }
}
