import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

typedef EmojiClick = void Function(String emoji);

class ChatUIKitInputEmojiBar extends StatelessWidget {
  final double maxCrossAxisExtent;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double childAspectRatio;

  final double bigSizeRatio;

  final EmojiClick? emojiClicked;

  final VoidCallback? deleteOnTap;

  const ChatUIKitInputEmojiBar({
    super.key,
    this.maxCrossAxisExtent = 36,
    this.mainAxisSpacing = 19.0,
    this.crossAxisSpacing = 19.0,
    this.childAspectRatio = 1.0,
    this.bigSizeRatio = 0.0,
    this.emojiClicked,
    this.deleteOnTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = GridView.custom(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 60),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
        mainAxisExtent: maxCrossAxisExtent,
      ),
      childrenDelegate: SliverChildBuilderDelegate(
        (context, position) {
          return _getEmojiItemContainer(position);
        },
        childCount: ChatUIKitEmojiData.listSize,
      ),
    );

    content = Stack(
      children: [
        content,
        Positioned(
          right: 20,
          bottom: 20,
          width: 36,
          height: 36,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              deleteOnTap?.call();
            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: ChatUIKitTheme.of(context).color.isDark
                    ? ChatUIKitShadow.darkSmall
                    : ChatUIKitShadow.lightSmall,
                borderRadius: BorderRadius.circular(24),
                color: (ChatUIKitTheme.of(context).color.isDark
                    ? ChatUIKitTheme.of(context).color.neutralColor3
                    : ChatUIKitTheme.of(context).color.neutralColor98),
              ),
              child: ChatUIKitImageLoader.emojiDelete(
                size: 20,
                color: (ChatUIKitTheme.of(context).color.isDark
                    ? ChatUIKitTheme.of(context).color.neutralColor98
                    : ChatUIKitTheme.of(context).color.neutralColor3),
              ),
            ),
          ),
        ),
      ],
    );

    return content;
  }

  _getEmojiItemContainer(int index) {
    var emoji = ChatUIKitEmojiData.emojiImagePaths[index];
    return ChatExpression(emoji, bigSizeRatio, emojiClicked);
  }
}

class ChatExpression extends StatelessWidget {
  final String emojiName;

  final double bigSizeRatio;

  final EmojiClick? emojiClicked;

  const ChatExpression(
    this.emojiName,
    this.bigSizeRatio,
    this.emojiClicked, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = Image.asset(
      emojiName,
      package: ChatUIKitEmojiData.packageName,
      width: 32,
      height: 32,
    );
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        emojiClicked?.call(emojiName);
      },
      child: icon,
    );
  }
}
