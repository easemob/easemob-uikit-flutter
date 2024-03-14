import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ChatUIKitMessageReactionsRow extends StatefulWidget {
  const ChatUIKitMessageReactionsRow({
    required this.reactions,
    required this.isLeft,
    required this.onReactionTap,
    this.onReactionInfoTap,
    super.key,
  });

  final List<MessageReaction> reactions;
  final Function(MessageReaction reaction)? onReactionTap;
  final VoidCallback? onReactionInfoTap;
  final bool isLeft;

  @override
  State<ChatUIKitMessageReactionsRow> createState() =>
      _ChatUIKitMessageReactionsRowState();
}

class _ChatUIKitMessageReactionsRowState
    extends State<ChatUIKitMessageReactionsRow> {
  @override
  Widget build(BuildContext context) {
    if (widget.reactions.isEmpty) return const SizedBox();
    ChatUIKitTheme theme = ChatUIKitTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> children = [];
        for (final reaction in widget.reactions) {
          if (children.length > 6) break;
          children.add(
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                widget.onReactionTap?.call(reaction);
              },
              child: ChatUIkitReactionWidget(
                reaction,
                theme: theme,
              ),
            ),
          );
          children.add(const SizedBox(width: 4));
        }
        children.add(
          InkWell(
            onTap: widget.onReactionInfoTap,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: theme.color.isDark
                    ? theme.color.neutralColor2
                    : theme.color.neutralColor95,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ChatUIKitImageLoader.more(height: 20, width: 22),
              ),
            ),
          ),
        );
        return Row(
            mainAxisAlignment:
                widget.isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: children);
      },
    );
  }
}
