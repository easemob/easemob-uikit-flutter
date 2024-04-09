import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupMentionView extends StatefulWidget {
  GroupMentionView.arguments(GroupMentionViewArguments arguments, {super.key})
      : listViewItemBuilder = arguments.listViewItemBuilder,
        onSearchTap = arguments.onSearchTap,
        searchBarHideText = arguments.searchBarHideText,
        listViewBackground = arguments.listViewBackground,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        appBar = arguments.appBar,
        controller = arguments.controller,
        enableAppBar = arguments.enableAppBar,
        groupId = arguments.groupId,
        title = arguments.title,
        appBarTrailingActionsBuilder = arguments.appBarTrailingActionsBuilder,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes;

  const GroupMentionView({
    required this.groupId,
    this.listViewItemBuilder,
    this.onSearchTap,
    this.searchBarHideText,
    this.listViewBackground,
    this.onTap,
    this.onLongPress,
    this.appBar,
    this.controller,
    this.enableAppBar = true,
    this.attributes,
    this.title,
    this.viewObserver,
    this.appBarTrailingActionsBuilder,
    super.key,
  });

  final String groupId;
  final GroupMemberListViewController? controller;
  final ChatUIKitAppBar? appBar;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)? onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final String? title;
  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;
  @override
  State<GroupMentionView> createState() => _GroupMentionViewState();
}

class _GroupMentionViewState extends State<GroupMentionView> {
  final ValueNotifier<List<ChatUIKitProfile>> selectedProfiles = ValueNotifier<List<ChatUIKitProfile>>([]);
  late final GroupMemberListViewController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? GroupMemberListViewController(groupId: widget.groupId);
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark ? theme.color.neutralColor1 : theme.color.neutralColor98,
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                showBackButton: true,
                centerTitle: false,
                title: widget.title ?? '@${ChatUIKitLocal.groupMembersViewTitle.localString(context)}',
                trailingActions: widget.appBarTrailingActionsBuilder?.call(context, null),
              ),
      body: ValueListenableBuilder(
        valueListenable: selectedProfiles,
        builder: (context, value, child) {
          return GroupMemberListView(
            beforeWidgets: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: const MentionAllItem(),
              )
            ],
            groupId: widget.groupId,
            controller: controller,
            itemBuilder: widget.listViewItemBuilder ??
                (context, model) {
                  return InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).pop(model.profile);
                    },
                    child: ChatUIKitContactListViewItem(model),
                  );
                },
            searchHideText: widget.searchBarHideText,
            background: widget.listViewBackground,
            onSearchTap: widget.onSearchTap ?? onSearchTap,
          );
        },
      ),
    );

    return content;
  }

  void onSearchTap(List<ContactItemModel> data) async {
    List<NeedSearch> list = [];
    for (var item in data) {
      list.add(item);
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: selectedProfiles,
          builder: (context, value, child) {
            return SearchView(
              searchHideText: ChatUIKitLocal.groupMentionViewSearchHint.localString(context),
              searchData: list,
              itemBuilder: (context, profile, searchKeyword) {
                return InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).pop(profile);
                  },
                  child: ChatUIKitSearchListViewItem(
                    profile: profile,
                    highlightWord: searchKeyword,
                  ),
                );
              },
            );
          },
        );
      },
    ).then((value) {
      if (value is ChatUIKitProfile) {
        Navigator.of(context).pop(value);
      }
    });
  }
}

class MentionAllItem extends StatelessWidget {
  const MentionAllItem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    TextStyle normalStyle = TextStyle(
      color: theme.color.isDark ? theme.color.neutralColor98 : theme.color.neutralColor1,
      fontSize: theme.font.titleMedium.fontSize,
      fontWeight: theme.font.titleMedium.fontWeight,
    );

    Widget name = Text(
      ChatUIKitLocal.groupMentionViewMentionAll.localString(context),
      overflow: TextOverflow.ellipsis,
      style: normalStyle,
      textScaler: TextScaler.noScaling,
    );

    Widget avatar = ChatUIKitAvatar(
      size: 40,
    );

    Widget content = Row(
      children: [
        avatar,
        const SizedBox(width: 12),
        name,
      ],
    );
    content = Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      height: 60 - 0.5,
      color: theme.color.isDark ? theme.color.neutralColor1 : theme.color.neutralColor98,
      child: content,
    );

    content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        content,
        Container(
          height: borderHeight,
          color: theme.color.isDark ? theme.color.neutralColor2 : theme.color.neutralColor9,
          margin: const EdgeInsets.only(left: 16),
        )
      ],
    );
    return content;
  }
}
