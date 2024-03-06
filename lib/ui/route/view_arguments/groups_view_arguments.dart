import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class GroupsViewArguments implements ChatUIKitViewArguments {
  GroupsViewArguments({
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
    this.title,
    this.viewObserver,
    this.attributes,
  });
  final GroupListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<GroupItemModel> data)? onSearchTap;
  final ChatUIKitGroupItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, GroupItemModel model)? onTap;
  final void Function(BuildContext context, GroupItemModel model)? onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final String? title;
  final bool enableAppBar;

  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  GroupsViewArguments copyWith({
    GroupListViewController? controller,
    ChatUIKitAppBar? appBar,
    void Function(List<GroupItemModel> data)? onSearchTap,
    ChatUIKitGroupItemBuilder? listViewItemBuilder,
    void Function(BuildContext context, GroupItemModel model)? onTap,
    void Function(BuildContext context, GroupItemModel model)? onLongPress,
    String? searchBarHideText,
    Widget? listViewBackground,
    String? loadErrorMessage,
    bool? enableAppBar,
    String? title,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return GroupsViewArguments(
      controller: controller ?? this.controller,
      appBar: appBar ?? this.appBar,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
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
