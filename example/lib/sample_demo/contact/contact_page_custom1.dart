import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ContactAndGroupPage extends StatefulWidget {
  const ContactAndGroupPage({super.key});

  @override
  State<ContactAndGroupPage> createState() => _ContactAndGroupPageState();
}

class _ContactAndGroupPageState extends State<ContactAndGroupPage>
    with SingleTickerProviderStateMixin {
  late TabController mController;

  final List<Tab> titleTabs = const [
    Tab(text: 'Contacts'),
    Tab(text: 'Groups'),
  ];

  @override
  void initState() {
    super.initState();
    mController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TabBar(
          controller: mController,
          labelColor: Colors.green,
          labelStyle: const TextStyle(fontSize: 16),
          unselectedLabelColor: Colors.black,
          unselectedLabelStyle: const TextStyle(fontSize: 14),
          indicatorColor: Colors.green,
          isScrollable: false,
          tabs: titleTabs,
        ),
      ),
      body: TabBarView(
        controller: mController,
        children: [
          ContactListView(
            onSearchTap: onSearchContactTap,
            onTap: (context, model) => toContactDetail(model.profile),
          ),
          GroupListView(
            enableSearch: true,
            onSearchTap: onSearchGroupTap,
            onTap: (context, model) => toGroupDetail(model.profile),
          ),
        ],
      ),
    );
  }

  void onSearchContactTap(List<ContactItemModel> data) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.searchView,
      SearchViewArguments(
        onTap: (ctx, profile) {
          Navigator.of(ctx).pop(profile);
        },
        searchHideText:
            ChatUIKitLocal.conversationsViewSearchHint.localString(context),
        searchData: data,
      ),
    ).then((value) {
      if (value != null && value is ChatUIKitProfile) {
        toContactDetail(value);
      }
    });
  }

  void toContactDetail(ChatUIKitProfile profile) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.contactDetailsView,
      ContactDetailsViewArguments(
        profile: profile,
      ),
    );
  }

  void onSearchGroupTap(List<GroupItemModel> data) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.searchView,
      SearchViewArguments(
        onTap: (ctx, profile) {
          Navigator.of(ctx).pop(profile);
        },
        searchHideText:
            ChatUIKitLocal.conversationsViewSearchHint.localString(context),
        searchData: data,
      ),
    ).then((value) {
      if (value != null && value is ChatUIKitProfile) {
        toGroupDetail(value);
      }
    });
  }

  void toGroupDetail(ChatUIKitProfile profile) {
    ChatUIKit.instance.getGroup(groupId: profile.id).then((group) {
      ChatUIKitRoute.pushOrPushNamed(
        context,
        ChatUIKitRouteNames.groupDetailsView,
        GroupDetailsViewArguments(
          profile: profile,
          group: group,
        ),
      );
    });
  }
}

class CustomContactAppBarPage extends StatefulWidget {
  const CustomContactAppBarPage({super.key});

  @override
  State<CustomContactAppBarPage> createState() =>
      _CustomContactAppBarPageState();
}

class _CustomContactAppBarPageState extends State<CustomContactAppBarPage> {
  @override
  Widget build(BuildContext context) {
    return ContactsView(
      appBarModel: ChatUIKitAppBarModel(
        showBackButton: false,
        title: 'Title',
        titleTextStyle: const TextStyle(color: Colors.blue, fontSize: 20),
        subtitle: 'CustomSubtitle',
        subTitleTextStyle: const TextStyle(color: Colors.red, fontSize: 12),
        centerTitle: true,
        leadingActions: [
          ChatUIKitAppBarAction(
            child: const Text('LeftButton'),
            onTap: (context) {
              showChatUIKitDialog(
                  context: context,
                  title: 'Custom',
                  barrierDismissible: false,
                  actionItems: [
                    ChatUIKitDialogAction.confirm(label: 'Confirm'),
                  ]);
            },
          )
        ],
        trailingActionsBuilder: (context, defaultList) {
          return [
            ChatUIKitAppBarAction(
              child: const Padding(
                  padding: EdgeInsets.all(3), child: Icon(Icons.add)),
              onTap: (context) {
                showChatUIKitDialog(
                    context: context,
                    title: 'Add',
                    barrierDismissible: false,
                    actionItems: [
                      ChatUIKitDialogAction.confirm(label: 'Confirm'),
                    ]);
              },
            ),
            ...(defaultList ?? []),
          ];
        },
      ),
    );
  }
}
