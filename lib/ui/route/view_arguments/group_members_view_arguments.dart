import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class GroupMembersViewArguments implements ChatUIKitViewArguments {
  GroupMembersViewArguments({
    required this.profile,
    this.controller,
    this.appBar,
    this.onSearchTap,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.searchBarHideText,
    this.listViewBackground,
    this.loadErrorMessage,
    this.enableAppBar = true,
    this.enableMemberOperation = false,
    this.attributes,
  });

  final ChatUIKitProfile profile;
  final GroupMemberListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableMemberOperation;
  final bool enableAppBar;

  @override
  String? attributes;

  GroupMembersViewArguments copyWith({
    ChatUIKitProfile? profile,
    GroupMemberListViewController? controller,
    ChatUIKitAppBar? appBar,
    void Function(List<ContactItemModel> data)? onSearchTap,
    ChatUIKitContactItemBuilder? listViewItemBuilder,
    void Function(BuildContext context, ContactItemModel model)? onTap,
    void Function(BuildContext context, ContactItemModel model)? onLongPress,
    String? searchBarHideText,
    Widget? listViewBackground,
    String? loadErrorMessage,
    bool? enableMemberOperation,
    bool? enableAppBar,
    String? attributes,
  }) {
    return GroupMembersViewArguments(
      profile: profile ?? this.profile,
      controller: controller ?? this.controller,
      appBar: appBar ?? this.appBar,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      searchBarHideText: searchBarHideText ?? this.searchBarHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      loadErrorMessage: loadErrorMessage ?? this.loadErrorMessage,
      enableMemberOperation:
          enableMemberOperation ?? this.enableMemberOperation,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      attributes: attributes ?? this.attributes,
    );
  }
}
