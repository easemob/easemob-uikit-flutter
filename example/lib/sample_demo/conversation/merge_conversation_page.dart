import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class MergeConversationPage extends StatefulWidget {
  const MergeConversationPage({super.key});

  @override
  State<MergeConversationPage> createState() => _MergeConversationPageState();
}

class _MergeConversationPageState extends State<MergeConversationPage> {
  late ConversationListViewController conversationListViewController;

  @override
  void initState() {
    super.initState();
    conversationListViewController = ConversationListViewController(
      willShowHandler: (conversations) {
        List<String> conversationGroupIds =
            MergedHelper().conversationGroupIds();
        for (String conversationGroupId in conversationGroupIds) {
          int totalUnreadCount = 0;
          Message? latestMessage;
          int newestTimestamp = 0;
          // 得到mergedId下的所有会话
          List<ConversationItemModel> list = conversations
              .where((element) =>
                  MergedHelper().getMergedId(element.profile.id) ==
                  conversationGroupId)
              .toList();

          /// 计算总未读数和得到最后一条消息
          for (var item in list) {
            totalUnreadCount += item.unreadCount;
            if (newestTimestamp < (item.lastMessage?.serverTime ?? 0)) {
              latestMessage = item.lastMessage;
              newestTimestamp = item.lastMessage!.serverTime;
            }
          }
          conversations.removeWhere((element) => MergedHelper()
              .allMergedConversations()
              .contains(element.profile.id));

          conversations.add(
            CustomConversationItemModel(
              profile: ChatUIKitProfile.custom(
                id: conversationGroupId,
                nickname: '合并会话',
              ),
              totalUnreadCount: totalUnreadCount,
              lastMessage: latestMessage,
            ),
          );

          List<ConversationItemModel> pinedList =
              conversations.where((element) {
            return element.pinned;
          }).toList();

          conversations.removeWhere((element) {
            return element.pinned;
          });

          pinedList.sort((a, b) {
            return (b.lastMessage?.serverTime ?? 0)
                .compareTo(a.lastMessage?.serverTime ?? 0);
          });

          conversations.sort((a, b) {
            return (b.lastMessage?.serverTime ?? 0)
                .compareTo(a.lastMessage?.serverTime ?? 0);
          });
          conversations = pinedList + conversations;
        }

        return conversations;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConversationsView(
      onItemLongPressHandler: (context, model, defaultActions) {
        if (model is CustomConversationItemModel) {
          return [];
        } else {
          return [
                ChatUIKitBottomSheetAction.normal(
                  label: '合并会话',
                  onTap: () async {
                    Navigator.of(context).pop();
                    await MergedHelper().addConversationToMerged(
                      'mergedId',
                      model,
                      mergeName: '合并会话',
                    );
                    await conversationListViewController.reload();
                  },
                )
              ] +
              defaultActions;
        }
      },
      enableAppBar: false,
      itemBuilder: (context, model) {
        return ChatUIKitConversationListViewItem(
          model,
          beforeSubtitle:
              model is CustomConversationItemModel && model.totalUnreadCount > 0
                  ? Text("[${model.totalUnreadCount}]")
                  : null,
        );
      },
      onItemTap: (context, info) {
        if (info is CustomConversationItemModel) {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => const MergedConversationsView(),
            ),
          )
              .then((value) {
            conversationListViewController.reload();
          });
        } else {
          ChatUIKitRoute.pushOrPushNamed(
              context,
              ChatUIKitRouteNames.messagesView,
              MessagesViewArguments(profile: info.profile));
        }
      },
      controller: conversationListViewController,
    );
  }

  @override
  void dispose() {
    conversationListViewController.dispose();
    super.dispose();
  }
}

class CustomConversationItemModel extends ConversationItemModel {
  final int totalUnreadCount;

  CustomConversationItemModel({
    required super.profile,
    this.totalUnreadCount = 0,
    super.lastMessage,
  });
}

/// 真实环境中建议存储到db。
class MergedHelper {
  final Map<String, List<String>> _map = {};

  static MergedHelper? _instance;

  MergedHelper._();

  factory MergedHelper() {
    _instance ??= MergedHelper._();
    return _instance!;
  }

  Future<void> addConversationToMerged(
      String mergedId, ConversationItemModel model,
      {String? mergeName}) async {
    if (_map[mergedId] == null) {
      _map[mergedId] = [];
    }
    _map[mergedId]!.add(model.profile.id);

    ChatUIKitProvider.instance.addProfiles(
      [
        ChatUIKitProfile.custom(
          id: mergedId,
          nickname: mergeName,
        )
      ],
    );
  }

  void removeMergedConversation(
    String mergedId,
    String conversationId,
  ) async {
    if (_map[mergedId] == null) {
      _map[mergedId] = [];
    }
    int index =
        _map[mergedId]!.indexWhere((element) => element == conversationId);
    if (index != -1) {
      _map[mergedId]?.removeAt(index);
      if (_map[mergedId]!.isEmpty) {
        _map.remove(mergedId);
      }
    }
  }

  List<String> allMergedConversations() {
    return _map.values.expand((element) => element).toList();
  }

  List<String> conversationGroupIds() {
    return _map.keys.toList();
  }

  String? getMergedId(String conversationId) {
    for (var key in _map.keys) {
      if (_map[key]!.contains(conversationId)) {
        return key;
      }
    }
    return null;
  }
}

class MergedConversationsView extends StatefulWidget {
  const MergedConversationsView({super.key});

  @override
  State<MergedConversationsView> createState() =>
      _MergedConversationsViewState();
}

class _MergedConversationsViewState extends State<MergedConversationsView> {
  late MergedConversationListViewController controller;

  @override
  void initState() {
    super.initState();
    controller = MergedConversationListViewController(
      MergedHelper().allMergedConversations(),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const ChatUIKitAppBar(
          title: '合并会话',
        ),
        body: ConversationsView(
          enableAppBar: false,
          controller: controller,
          onItemLongPressHandler: (context, model, defaultActions) {
            return [
                  ChatUIKitBottomSheetAction.normal(
                    label: '取消合并',
                    onTap: () async {
                      Navigator.of(context).pop();
                      controller.removeConversation(model.profile.id);
                    },
                  )
                ] +
                defaultActions;
          },
        ));
  }
}

class MergedConversationListViewController
    extends ConversationListViewController {
  final List<String> conversationIds;
  MergedConversationListViewController(this.conversationIds);

  @override
  Future<void> fetchItemList({bool force = false}) async {
    loadingType.value = ChatUIKitListViewType.loading;
    List<Conversation> items = await ChatUIKit.instance.getAllConversations();
    items =
        items.where((element) => conversationIds.contains(element.id)).toList();
    try {
      items = await clearEmptyConversations(items);
      List<ConversationItemModel> tmp =
          await mapperToConversationModelItems(items);
      list.clear();
      list.addAll(tmp);

      if (list.isEmpty) {
        loadingType.value = ChatUIKitListViewType.empty;
      } else {
        loadingType.value = ChatUIKitListViewType.normal;
      }
    } catch (e) {
      loadingType.value = ChatUIKitListViewType.error;
    }
  }

  @override
  Future<void> reload() async {
    loadingType.value = ChatUIKitListViewType.refresh;
    List<Conversation> items = await ChatUIKit.instance.getAllConversations();
    items =
        items.where((element) => conversationIds.contains(element.id)).toList();
    items = await clearEmptyConversations(items);
    List<ConversationItemModel> tmp =
        await mapperToConversationModelItems(items);
    list.clear();
    list.addAll(tmp);
    if (list.isEmpty) {
      loadingType.value = ChatUIKitListViewType.empty;
    } else {
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  void removeConversation(String conversationId) {
    conversationIds.removeWhere((element) => element == conversationId);
    MergedHelper().removeMergedConversation('mergedId', conversationId);
    reload();
  }
}
