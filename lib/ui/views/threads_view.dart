import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ThreadsView extends StatefulWidget {
  ThreadsView.arguments(
    ThreadsViewArguments arguments, {
    super.key,
  })  : profile = arguments.profile,
        attributes = arguments.attributes,
        viewObserver = arguments.viewObserver;

  const ThreadsView({
    required this.profile,
    super.key,
    this.attributes,
    this.viewObserver,
  });

  final String? attributes;

  final ChatUIKitViewObserver? viewObserver;

  final ChatUIKitProfile profile;

  @override
  State<ThreadsView> createState() => _ThreadsViewState();
}

class _ThreadsViewState extends State<ThreadsView> with ThreadObserver {
  bool fetching = false;
  bool hasMore = true;
  String? cursor;
  int limit = 20;
  List<ChatThread> list = [];

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    fetchThreads();
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onChatThreadDestroy(ChatThreadEvent event) {
    if (event.chatThread?.parentId == widget.profile.id) {
      list.removeWhere(
        (element) => element.threadId == event.chatThread?.threadId,
      );
      setState(() {});
    }
  }

  @override
  void onChatThreadUpdate(ChatThreadEvent event) {
    if (event.chatThread?.parentId == widget.profile.id) {
      int index = list.indexWhere(
        (element) => element.threadId == event.chatThread?.threadId,
      );
      if (index != -1) {
        list[index] = event.chatThread!;
        setState(() {});
      }
    }
  }

  @override
  void onChatThreadCreate(ChatThreadEvent event) async {
    if (event.chatThread?.parentId == widget.profile.id) {
      list.insert(0, event.chatThread!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    return Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        centerTitle: false,
        title: '所有话题',
        titleTextStyle: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor100
              : theme.color.neutralColor1,
          fontWeight: theme.font.titleMedium.fontWeight,
          fontSize: theme.font.titleMedium.fontSize,
        ),
        subtitle: widget.profile.showName,
      ),
      body: SafeArea(
        child: NotificationListener(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              if (notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
                fetchThreads();
              }
            }
            return false;
          },
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: theme.color.isDark
                      ? theme.color.neutralColor2
                      : theme.color.neutralColor9,
                ),
              );
            },
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: ChatUIKitMessageThreadWidget(
                  enableMessageCount: false,
                  onTap: () {
                    pushToThread(list[index]);
                  },
                  titleStyle: TextStyle(
                    color: theme.color.isDark
                        ? theme.color.neutralColor100
                        : theme.color.neutralColor1,
                    fontWeight: theme.font.titleSmall.fontWeight,
                    fontSize: theme.font.titleSmall.fontSize,
                  ),
                  subtitleStyle: TextStyle(
                    color: theme.color.isDark
                        ? theme.color.neutralColor6
                        : theme.color.neutralColor5,
                    fontWeight: theme.font.labelMedium.fontWeight,
                    fontSize: theme.font.labelMedium.fontSize,
                  ),
                  threadIcon: const SizedBox(),
                  chatThread: list[index],
                  backgroundColor: theme.color.isDark
                      ? theme.color.neutralColor1
                      : theme.color.neutralColor98,
                ),
              );
            },
            itemCount: list.length,
          ),
        ),
      ),
    );
  }

  void fetchThreads() async {
    if (fetching || hasMore == false) return;
    fetching = true;
    try {
      CursorResult<ChatThread> result =
          await ChatUIKit.instance.fetchChatThreadsWithParentId(
        parentId: widget.profile.id,
        cursor: cursor,
        limit: limit,
      );
      cursor = result.cursor;
      if (result.data.length < limit) {
        hasMore = false;
      }
      list.addAll(result.data);
      Map<String, Message> map =
          await ChatUIKit.instance.fetchLatestMessageWithChatThreads(
        chatThreadIds: result.data.map((e) => e.threadId).toList(),
      );

      for (var key in map.keys) {
        int index = list.indexWhere((element) => element.threadId == key);
        if (index != -1) {
          list[index] = list[index].copyWith(
            lastMessage: map[key],
          );
        }
      }

      setState(() {});
    } catch (e) {
      debugPrint('fetchThreads error: $e');
    }
    fetching = false;
  }

  void pushToThread(ChatThread thread) async {
    Future(() async {
      Message? msg =
          await ChatUIKit.instance.loadMessage(messageId: thread.messageId);
      if (msg != null) {
        return MessageModel(message: msg, thread: thread);
      }
    }).then((value) {
      ChatUIKitRoute.pushOrPushNamed(
        context,
        ChatUIKitRouteNames.threadMessagesView,
        ThreadMessagesViewArguments(
          controller: ThreadMessagesViewController(
            thread: thread,
            model: value,
          ),
        ),
      );
    });
  }
}
