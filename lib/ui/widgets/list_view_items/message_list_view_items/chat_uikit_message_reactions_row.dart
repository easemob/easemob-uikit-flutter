import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitMessageReactionsRow extends StatefulWidget {
  const ChatUIKitMessageReactionsRow({required this.reactions, super.key});

  final List<MessageReaction> reactions;

  @override
  State<ChatUIKitMessageReactionsRow> createState() =>
      _ChatUIKitMessageReactionsRowState();
}

class _ChatUIKitMessageReactionsRowState
    extends State<ChatUIKitMessageReactionsRow> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: [
          for (final reaction in widget.reactions)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    reaction.reaction,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
