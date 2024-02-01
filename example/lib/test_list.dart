import 'package:flutter/material.dart';

class TestList extends StatefulWidget {
  const TestList({super.key});

  @override
  State<TestList> createState() => _TestListState();
}

class _TestListState extends State<TestList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MessageList22();
  }
}

class MessageList22 extends StatefulWidget {
  const MessageList22({super.key});

  @override
  State<MessageList22> createState() => _MessageList22State();
}

class _MessageList22State extends State<MessageList22> {
  late ScrollController _autoScrollController;

  List<String> newList = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 3; i++) {
      newList.add(i.toString());
    }

    newList = newList.reversed.toList();
    _autoScrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      cacheExtent: 1500,
      controller: _autoScrollController,
      reverse: true,
      shrinkWrap: true,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _newMessage(index);
            },
            childCount: newList.length,
          ),
        ),
      ],
    );
  }

  Widget _newMessage(int index) {
    return SizedBox(
      height: 80,
      child: Text(newList[index]),
    );
  }
}
