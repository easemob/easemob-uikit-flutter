import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ChatUIKitMessageThreadWidget extends StatefulWidget {
  const ChatUIKitMessageThreadWidget({
    required this.chatThread,
    this.threadIcon,
    this.titleStyle,
    this.subtitleStyle,
    this.backgroundColor,
    this.enableMessageCount = true,
    this.onTap,
    super.key,
  });
  final ChatThread chatThread;
  final VoidCallback? onTap;
  final Widget? threadIcon;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Color? backgroundColor;
  final bool enableMessageCount;
  @override
  State<ChatUIKitMessageThreadWidget> createState() =>
      _ChatUIKitMessageThreadWidgetState();
}

class _ChatUIKitMessageThreadWidgetState
    extends State<ChatUIKitMessageThreadWidget> {
  int threadMessageCount = 0;
  String threadName = '';
  String subtitle = '';

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    threadMessageCount = widget.chatThread.messageCount;
    threadName = widget.chatThread.threadName ?? '';
    subtitle = widget.chatThread.lastMessage?.showInfoTranslate(
          context,
          needShowName: true,
        ) ??
        ChatUIKitLocal.threadNoLastMessage.localString(context);
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: widget.threadIcon ??
                  ChatUIKitImageLoader.messageLongPressThread(
                    width: 16,
                    height: 16,
                    color: theme.color.isDark
                        ? theme.color.neutralColor95
                        : theme.color.neutralColor3,
                  ),
            ),
            Expanded(
              child: ChatUIKitEmojiRichText(
                text: threadName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: widget.titleStyle ??
                    TextStyle(
                      fontWeight: theme.font.labelSmall.fontWeight,
                      fontSize: theme.font.labelSmall.fontSize,
                      color: theme.color.isDark
                          ? theme.color.neutralColor95
                          : theme.color.neutralColor3,
                    ),
              ),
            ),
            if (widget.enableMessageCount)
              RichText(
                maxLines: 1,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '${threadMessageCount > 99 ? '99+' : threadMessageCount}',
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 7,
                          color: theme.color.isDark
                              ? theme.color.neutralColor95
                              : theme.color.neutralColor3,
                        ),
                      ),
                    ),
                  ],
                  style: TextStyle(
                    fontWeight: theme.font.labelSmall.fontWeight,
                    fontSize: theme.font.labelSmall.fontSize,
                    color: theme.color.isDark
                        ? theme.color.primaryColor6
                        : theme.color.primaryColor5,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: widget.subtitleStyle ??
                TextStyle(
                  fontWeight: theme.font.bodyMedium.fontWeight,
                  fontSize: theme.font.bodyMedium.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor6
                      : theme.color.neutralColor5,
                ),
          ),
        ),
      ],
    );
    content = Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: widget.backgroundColor ??
              (theme.color.isDark
                  ? theme.color.neutralColor2
                  : theme.color.neutralColor95)),
      child: content,
    );

    content = InkWell(
      focusColor: Colors.transparent,
      onTap: widget.onTap,
      child: content,
    );

    return content;
  }
}
