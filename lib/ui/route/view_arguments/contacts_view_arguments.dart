import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ContactsViewArguments implements ChatUIKitViewArguments {
  ContactsViewArguments({
    this.controller,
    this.appBar,
    this.enableAppBar = true,
    this.enableSearchBar = true,
    this.onSearchTap,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.searchHideText,
    this.listViewBackground,
    this.loadErrorMessage,
    this.beforeItems,
    this.afterItems,
    this.title,
    this.attributes,
  });

  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final bool enableSearchBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;
  final List<ChatUIKitListViewMoreItem>? beforeItems;
  final List<ChatUIKitListViewMoreItem>? afterItems;
  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final String? title;

  @override
  String? attributes;

  ContactsViewArguments copyWith({
    ContactListViewController? controller,
    ChatUIKitAppBar? appBar,
    void Function(List<ContactItemModel> data)? onSearchTap,
    ChatUIKitContactItemBuilder? listViewItemBuilder,
    void Function(BuildContext context, ContactItemModel model)? onTap,
    void Function(BuildContext context, ContactItemModel model)? onLongPress,
    String? searchHideText,
    Widget? listViewBackground,
    String? loadErrorMessage,
    bool? enableSearchBar,
    bool? enableAppBar,
    String? attributes,
  }) {
    return ContactsViewArguments(
      controller: controller ?? this.controller,
      appBar: appBar ?? this.appBar,
      enableSearchBar: enableSearchBar ?? this.enableSearchBar,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      searchHideText: searchHideText ?? this.searchHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      loadErrorMessage: loadErrorMessage ?? this.loadErrorMessage,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      attributes: attributes ?? this.attributes,
    );
  }
}
