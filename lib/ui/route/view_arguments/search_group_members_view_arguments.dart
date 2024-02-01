import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class SearchGroupMembersViewArguments implements ChatUIKitViewArguments {
  SearchGroupMembersViewArguments({
    required this.searchData,
    required this.searchHideText,
    this.onTap,
    this.itemBuilder,
    this.appBar,
    this.enableAppBar = false,
    this.attributes,
  });

  final List<NeedSearch> searchData;
  final String searchHideText;
  final void Function(BuildContext context, ChatUIKitProfile profile)? onTap;
  final Widget Function(BuildContext context, ChatUIKitProfile profile,
      String? searchKeyword)? itemBuilder;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  @override
  String? attributes;

  SearchGroupMembersViewArguments copyWith({
    List<NeedSearch>? searchData,
    String? searchHideText,
    void Function(BuildContext context, ChatUIKitProfile profile)? onTap,
    Widget Function(BuildContext context, ChatUIKitProfile profile,
            String? searchKeyword)?
        itemBuilder,
    ChatUIKitAppBar? appBar,
    bool? enableAppBar,
    String? attributes,
  }) {
    return SearchGroupMembersViewArguments(
      searchData: searchData ?? this.searchData,
      searchHideText: searchHideText ?? this.searchHideText,
      onTap: onTap ?? this.onTap,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      appBar: appBar ?? this.appBar,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      attributes: attributes ?? this.attributes,
    );
  }
}
