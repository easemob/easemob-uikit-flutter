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
    this.willCreateHandler,
    this.createGroupInfo,
    this.attributes,
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
  final WillCreateHandler? willCreateHandler;
  final CreateGroupInfo? createGroupInfo;
  @override
  String? attributes;

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
    WillCreateHandler? willCreateHandler,
    CreateGroupInfo? createGroupInfo,
    String? attributes,
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
      willCreateHandler: willCreateHandler ?? this.willCreateHandler,
      createGroupInfo: createGroupInfo ?? this.createGroupInfo,
      attributes: attributes ?? this.attributes,
    );
  }
}
