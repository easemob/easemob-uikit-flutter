import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class SelectContactViewArguments implements ChatUIKitViewArguments {
  SelectContactViewArguments({
    this.title,
    this.backText,
    this.controller,
    this.appBar,
    this.onSearchTap,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.searchBarHideText,
    this.listViewBackground,
    this.enableAppBar = true,
    this.viewObserver,
    this.attributes,
  });
  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;
  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)? onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final String? backText;
  final String? title;
  final bool enableAppBar;

  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  SelectContactViewArguments copyWith({
    ContactListViewController? controller,
    ChatUIKitAppBar? appBar,
    void Function(List<ContactItemModel> data)? onSearchTap,
    ChatUIKitContactItemBuilder? listViewItemBuilder,
    void Function(BuildContext context, ContactItemModel model)? onTap,
    void Function(BuildContext context, ContactItemModel model)? onLongPress,
    String? searchBarHideText,
    Widget? listViewBackground,
    String? backText,
    String? title,
    bool? enableAppBar,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return SelectContactViewArguments(
      controller: controller ?? this.controller,
      appBar: appBar ?? this.appBar,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      searchBarHideText: searchBarHideText ?? this.searchBarHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      backText: backText ?? this.backText,
      title: title ?? this.title,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
