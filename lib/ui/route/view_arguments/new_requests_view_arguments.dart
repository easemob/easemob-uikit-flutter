import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class NewRequestsViewArguments implements ChatUIKitViewArguments {
  NewRequestsViewArguments({
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
    this.appBarTrailingActionsBuilder,
  });

  final NewRequestListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<NewRequestItemModel> data)? onSearchTap;
  final ChatUIKitNewRequestItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, NewRequestItemModel model)? onTap;
  final void Function(BuildContext context, NewRequestItemModel model)? onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableAppBar;
  final String? title;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;

  NewRequestsViewArguments copyWith(
      {NewRequestListViewController? controller,
      ChatUIKitAppBar? appBar,
      void Function(List<NewRequestItemModel> data)? onSearchTap,
      ChatUIKitNewRequestItemBuilder? listViewItemBuilder,
      void Function(BuildContext context, NewRequestItemModel model)? onTap,
      void Function(BuildContext context, NewRequestItemModel model)? onLongPress,
      String? searchBarHideText,
      Widget? listViewBackground,
      String? loadErrorMessage,
      bool? enableAppBar,
      String? title,
      ChatUIKitViewObserver? viewObserver,
      String? attributes,
      ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder}) {
    return NewRequestsViewArguments(
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
      appBarTrailingActionsBuilder: appBarTrailingActionsBuilder ?? this.appBarTrailingActionsBuilder,
    );
  }
}
