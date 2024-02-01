// ignore_for_file: deprecated_member_use
import 'dart:math';
import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitVoiceMessageWidget extends StatefulWidget {
  const ChatUIKitVoiceMessageWidget({
    required this.message,
    this.style,
    this.icon,
    this.playing = false,
    this.forceLeft,
    super.key,
  });
  final TextStyle? style;
  final Message message;
  final Widget? icon;
  final bool playing;
  final bool? forceLeft;

  @override
  State<ChatUIKitVoiceMessageWidget> createState() =>
      _ChatUIKitVoiceMessageWidgetState();
}

class _ChatUIKitVoiceMessageWidgetState
    extends State<ChatUIKitVoiceMessageWidget>
    with SingleTickerProviderStateMixin {
  late final Message message;
  late AnimationController controller;
  late Animation<int> animation;
  @override
  void initState() {
    super.initState();
    message = widget.message;
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    animation = IntTween(begin: 0, end: 2).animate(controller)
      ..addListener(() {
        safeSetState(() {});
      });
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.playing) {
      if (!controller.isAnimating) {
        controller.repeat();
      }
    } else {
      controller.stop();
    }
    final theme = ChatUIKitTheme.of(context);
    bool left =
        widget.forceLeft ?? message.direction == MessageDirection.RECEIVE;

    Color iconColor = left
        ? theme.color.isDark
            ? theme.color.neutralColor98
            : theme.color.neutralSpecialColor5
        : theme.color.isDark
            ? theme.color.neutralSpecialColor3
            : theme.color.neutralColor98;
    Color textColor = left
        ? theme.color.isDark
            ? theme.color.neutralColor98
            : theme.color.neutralColor1
        : theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98;

    Widget timeWidget = Text(
      '${message.duration}"',
      textScaleFactor: 1.0,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: widget.style ??
          TextStyle(
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
            color: textColor,
          ),
    );

    Widget iconWidget;
    if (!controller.isAnimating) {
      iconWidget = ChatUIKitImageLoader.bubbleVoice(2, color: iconColor);
    } else {
      iconWidget =
          ChatUIKitImageLoader.bubbleVoice(animation.value, color: iconColor);
    }

    if (!left) {
      iconWidget = Transform.rotate(angle: pi, child: iconWidget);
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: left ? TextDirection.ltr : TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [iconWidget, const SizedBox(width: 2), timeWidget],
    );

    double width = 70;
    if (message.duration < 10 && message.duration >= 0) {
      width = 70;
    } else if (message.duration < 20 && message.duration > 9) {
      width = 95;
    } else if (message.duration < 30 && message.duration > 19) {
      width = 120;
    } else if (message.duration < 40 && message.duration > 29) {
      width = 145;
    } else if (message.duration < 50 && message.duration > 39) {
      width = 170;
    } else if (message.duration < 60 && message.duration > 49) {
      width = 195;
    } else {
      width = 220;
    }

    // 减去padding left & right
    width -= 16;

    content = SizedBox(
      width: width,
      child: content,
    );

    return content;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
