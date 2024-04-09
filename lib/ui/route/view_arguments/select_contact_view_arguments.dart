import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class SelectContactViewArguments implements ChatUIKitViewArguments {
  SelectContactViewArguments({
    this.title,
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
    this.appBarTrailingActionsBuilder,
  });
  final ContactListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;
  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)? onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final String? title;
  final bool enableAppBar;

  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;

  SelectContactViewArguments copyWith(
      {ContactListViewController? controller,
      ChatUIKitAppBar? appBar,
      void Function(List<ContactItemModel> data)? onSearchTap,
      ChatUIKitContactItemBuilder? listViewItemBuilder,
      void Function(BuildContext context, ContactItemModel model)? onTap,
      void Function(BuildContext context, ContactItemModel model)? onLongPress,
      String? searchBarHideText,
      Widget? listViewBackground,
      String? title,
      bool? enableAppBar,
      ChatUIKitViewObserver? viewObserver,
      String? attributes,
      ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder}) {
    return SelectContactViewArguments(
      controller: controller ?? this.controller,
      appBar: appBar ?? this.appBar,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      searchBarHideText: searchBarHideText ?? this.searchBarHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      title: title ?? this.title,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
      appBarTrailingActionsBuilder: appBarTrailingActionsBuilder ?? this.appBarTrailingActionsBuilder,
    );
  }
}
