import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ThreadMembersView extends StatefulWidget {
  ThreadMembersView.arguments(
    ThreadMembersViewArguments args, {
    super.key,
  })  : thread = args.thread,
        attributes = args.attributes,
        viewObserver = args.viewObserver,
        controller = args.controller;

  const ThreadMembersView({
    required this.thread,
    super.key,
    this.attributes,
    this.controller,
    this.viewObserver,
  });

  final String? attributes;
  final ChatUIKitViewObserver? viewObserver;

  final ChatThread thread;
  final ThreadMembersViewController? controller;

  @override
  State<ThreadMembersView> createState() => _ThreadMembersViewState();
}

class _ThreadMembersViewState extends State<ThreadMembersView> {
  late ThreadMembersViewController controller;
  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        ThreadMembersViewController(
          thread: widget.thread,
        );

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    controller.fetchMembers();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
        title: '话题成员',
        titleTextStyle: TextStyle(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1,
          fontWeight: theme.font.titleMedium.fontWeight,
          fontSize: theme.font.titleMedium.fontSize,
        ),
      ),
      body: SafeArea(
        child: NotificationListener(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              debugPrint(
                  "_scrollController.position.pixels ${_scrollController.position.pixels}"
                  "_scrollController.position.maxScrollExtent ${_scrollController.position.maxScrollExtent}");
              if (_scrollController.position.pixels -
                      _scrollController.position.maxScrollExtent >
                  -1500) {
                controller.fetchMembers();
              }
            }

            return true;
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemBuilder: (ctx, index) {
              return ChatUIKitContactListViewItem(controller.modelsList[index]);
            },
            itemCount: controller.modelsList.length,
          ),
        ),
      ),
    );
  }
}
