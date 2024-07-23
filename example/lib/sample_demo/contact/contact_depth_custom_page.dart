import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ContactDepthCustomPage extends StatefulWidget {
  const ContactDepthCustomPage({super.key});

  @override
  State<ContactDepthCustomPage> createState() => _ContactDepthCustomPageState();
}

class _ContactDepthCustomPageState extends State<ContactDepthCustomPage> {
  ContactListViewController controller = ContactListViewController();
  ScrollController scrollController = ScrollController();

  ValueNotifier<String?> letter = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();

    ChatUIKitAlphabetSortHelper.instance.sortHandler =
        (groupId, userId, showName) {
      if (showName == '1912') return 'ABC';
      return null;
    };

    controller.fetchItemList();
    controller.loadingType.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ChatUIKitAlphabeticalWidget(
          universalAlphabeticalLetter: '#',
          sortAlphabetical: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#',
          highlightColor: Colors.red,
          onSelectLetterChanged: (context, alphabetical) {
            letter.value = alphabetical;
          },
          list: controller.list,
          scrollController: scrollController,
          builder: (context, list) {
            return ChatUIKitListView(
              onRefresh: controller.enableRefresh
                  ? () async {
                      await controller.fetchItemList(reload: true);
                    }
                  : null,
              scrollController: scrollController,
              type: controller.loadingType.value,
              list: list,
              refresh: () {
                controller.fetchItemList();
              },
              errorMessage: 'Error',
              reloadMessage: 'Fetching',
              findChildIndexCallback: (Key key) {
                int index = -1;
                if (key is ValueKey<String>) {
                  final ValueKey<String> valueKey = key;
                  index = controller.list.indexWhere((info) {
                    if (info is ContactItemModel) {
                      return info.profile.id == valueKey.value;
                    } else {
                      return false;
                    }
                  });
                }
                return index > -1 ? index : null;
              },
              onSearchTap: onSearchContactTap,
              searchBarHideText: 'Search',
              itemBuilder: (context, model) {
                if (model is ContactItemModel) {
                  return InkWell(
                    onTap: () => toContactDetail(model.profile),
                    child: ChatUIKitContactListViewItem(model),
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          },
        ),
        Positioned(
          child: ValueListenableBuilder(
            valueListenable: letter,
            child: const SizedBox(),
            builder: (context, value, child) {
              if (value == null) {
                return child!;
              }
              return Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      value.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void onSearchContactTap(List<ChatUIKitListItemModelBase> data) {
    List<NeedSearch> searchData = data.whereType<NeedSearch>().toList();
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.searchView,
      SearchViewArguments(
        onTap: (ctx, profile) {
          Navigator.of(ctx).pop(profile);
        },
        searchHideText:
            ChatUIKitLocal.conversationsViewSearchHint.localString(context),
        searchData: searchData,
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
}
