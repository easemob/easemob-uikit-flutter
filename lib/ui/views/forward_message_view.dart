import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/ui/custom/custom_tab_indicator.dart';
import 'package:flutter/material.dart';

class ForwardMessageView extends StatefulWidget {
  ForwardMessageView.arguments(
    ForwardMessageViewArguments arguments, {
    super.key,
  })  : messages = arguments.messages,
        enableAppBar = arguments.enableAppBar,
        appBar = arguments.appBar,
        title = arguments.title,
        attributes = arguments.attributes;

  const ForwardMessageView({
    required this.messages,
    this.enableAppBar = true,
    this.appBar,
    this.title,
    this.attributes,
    super.key,
  });

  final List<Message> messages;
  final bool enableAppBar;
  final ChatUIKitAppBar? appBar;
  final String? title;

  final String? attributes;
  @override
  State<ForwardMessageView> createState() => _ForwardMessageViewState();
}

class _ForwardMessageViewState extends State<ForwardMessageView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<String> forwardedList = [];

  ChatUIKitViewObserver? viewObserver;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: !widget.enableAppBar
          ? null
          : widget.appBar ??
              ChatUIKitAppBar(
                showBackButton: true,
                onBackButtonPressed: () {
                  Navigator.of(context).pop(forwardedList.isNotEmpty);
                },
                leading: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.maybePop(context);
                  },
                  child: Text(
                    widget.title ??
                        ChatUIKitLocal.forwardMessageViewTitle
                            .getString(context),
                    textScaler: TextScaler.noScaling,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.color.isDark
                          ? theme.color.neutralColor98
                          : theme.color.neutralColor1,
                      fontWeight: theme.font.titleMedium.fontWeight,
                      fontSize: theme.font.titleMedium.fontSize,
                    ),
                  ),
                ),
              ),
      body: Column(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            indicator: CustomTabIndicator(
              radius: 2,
              color: ChatUIKitTheme.of(context).color.isDark
                  ? ChatUIKitTheme.of(context).color.primaryColor6
                  : ChatUIKitTheme.of(context).color.primaryColor5,
              size: const Size(28, 4),
            ),
            controller: _tabController,
            labelStyle: TextStyle(
              fontWeight:
                  ChatUIKitTheme.of(context).font.titleMedium.fontWeight,
              fontSize: ChatUIKitTheme.of(context).font.titleMedium.fontSize,
            ),
            labelColor: (ChatUIKitTheme.of(context).color.isDark
                ? ChatUIKitTheme.of(context).color.neutralColor98
                : ChatUIKitTheme.of(context).color.neutralColor1),
            tabs: const [
              Tab(text: '联系人'),
              Tab(text: '群组'),
            ],
          ),
          Expanded(
              child: TabBarView(controller: _tabController, children: [
            ContactsView(
              enableAppBar: false,
              beforeItems: const [],
              onSearchTap: (data) {
                onSearchTap(data, context, theme);
              },
              listViewItemBuilder: (context, model) {
                Widget item = Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ChatUIKitContactListViewItem(model),
                    SizedBox(
                      width: 60,
                      height: 28,
                      child: forwardButton(theme, model.profile.id, false),
                    ),
                  ],
                );
                item = Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: item,
                );

                return item;
              },
            ),
            GroupsView(
                enableAppBar: false,
                listViewItemBuilder: (context, model) {
                  Widget item = Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ChatUIKitGroupListViewItem(model),
                      ),
                      SizedBox(
                        width: 60,
                        height: 28,
                        child: forwardButton(theme, model.profile.id, true),
                      ),
                    ],
                  );
                  item = Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: item,
                  );

                  return item;
                }),
          ])),
        ],
      ),
    );

    return content;
  }

  void onSearchTap(List<ContactItemModel> data, BuildContext context,
      ChatUIKitTheme theme) async {
    viewObserver ??= ChatUIKitViewObserver();
    List<NeedSearch> list = [];
    for (var item in data) {
      list.add(item);
    }

    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.searchUsersView,
      SearchViewArguments(
        viewObserver: viewObserver,
        itemBuilder: (context, profile, searchKeyword) {
          Widget item = Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ChatUIKitSearchListViewItem(
                profile: profile,
                highlightWord: searchKeyword,
              ),
              SizedBox(
                width: 60,
                height: 28,
                child: Builder(
                  builder: (ctx) {
                    return forwardButton(theme, profile.id, false);
                  },
                ),
              ),
            ],
          );
          item = Padding(
            padding: const EdgeInsets.only(right: 24),
            child: item,
          );

          return item;
        },
        searchHideText:
            ChatUIKitLocal.conversationsViewSearchHint.getString(context),
        searchData: list,
      ),
    ).then((value) => viewObserver = null);
  }

  Widget forwardButton(
    ChatUIKitTheme theme,
    String profileId,
    bool isGroup,
  ) {
    bool hasForwarded = forwardedList.contains(profileId);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor3
            : theme.color.neutralColor95,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: () {
        forwardedList.add(profileId);
        setState(() {});
        viewObserver?.refresh();
      },
      child: Text(
        hasForwarded ? '已转发' : '转发',
        textAlign: TextAlign.right,
        textScaler: TextScaler.noScaling,
        style: TextStyle(
            color: hasForwarded
                ? theme.color.isDark
                    ? theme.color.neutralColor5
                    : theme.color.neutralColor7
                : theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor1,
            fontSize: theme.font.labelMedium.fontSize,
            fontWeight: theme.font.labelMedium.fontWeight),
      ),
    );
  }
}
