import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ConversationsViewArguments implements ChatUIKitViewArguments {
  ConversationsViewArguments({
    this.controller,
    this.appBar,
    this.onSearchTap,
    this.beforeWidgets,
    this.afterWidgets,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPressHandler,
    this.searchBarHideText,
    this.listViewBackground,
    this.enableAppBar = true,
    this.appBarMoreActionsBuilder,
    this.enableSearchBar = true,
    this.title,
    this.attributes,
  });

  final ConversationListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ConversationModel> data)? onSearchTap;
  final List<Widget>? beforeWidgets;
  final List<Widget>? afterWidgets;
  final ConversationItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ConversationModel model)? onTap;
  final ConversationsViewItemLongPressHandler? onLongPressHandler;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final bool enableSearchBar;
  final AppBarMoreActionsBuilder? appBarMoreActionsBuilder;
  final String? title;
  @override
  String? attributes;

  ConversationsViewArguments copyWith({
    ConversationListViewController? controller,
    ChatUIKitAppBar? appBar,
    void Function(List<ConversationModel> data)? onSearchTap,
    List<NeedAlphabeticalWidget>? beforeWidgets,
    List<NeedAlphabeticalWidget>? afterWidgets,
    ChatUIKitListItemBuilder? listViewItemBuilder,
    void Function(BuildContext context, ConversationModel model)? onTap,
    ConversationsViewItemLongPressHandler? onLongPressHandler,
    String? searchBarHideText,
    Widget? listViewBackground,
    bool? enableAppBar,
    bool? enableSearchBar,
    AppBarMoreActionsBuilder? appBarMoreActionsBuilder,
    String? attributes,
  }) {
    return ConversationsViewArguments(
      controller: controller ?? this.controller,
      appBar: appBar ?? this.appBar,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      beforeWidgets: beforeWidgets ?? this.beforeWidgets,
      afterWidgets: afterWidgets ?? this.afterWidgets,
      listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
      onTap: onTap ?? this.onTap,
      enableSearchBar: enableSearchBar ?? this.enableSearchBar,
      onLongPressHandler: onLongPressHandler ?? this.onLongPressHandler,
      searchBarHideText: searchBarHideText ?? this.searchBarHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBarMoreActionsBuilder:
          appBarMoreActionsBuilder ?? this.appBarMoreActionsBuilder,
      attributes: attributes ?? this.attributes,
    );
  }
}
