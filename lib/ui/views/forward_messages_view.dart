import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ForwardMessagesView extends StatefulWidget {
  ForwardMessagesView.arguments(
    ForwardMessagesViewArguments arguments, {
    super.key,
  })  : message = arguments.message,
        enableAppBar = arguments.enableAppBar,
        appBar = arguments.appBar,
        title = arguments.title,
        viewObserver = arguments.viewObserver,
        summaryBuilder = arguments.summaryBuilder,
        attributes = arguments.attributes;

  const ForwardMessagesView({
    required this.message,
    required this.enableAppBar,
    this.appBar,
    this.title,
    this.attributes,
    this.summaryBuilder,
    this.viewObserver,
    super.key,
  });

  final Message message;
  final bool enableAppBar;
  final ChatUIKitAppBar? appBar;
  final String? title;
  final String? attributes;
  final String? Function(BuildContext context, Message message)? summaryBuilder;
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<ForwardMessagesView> createState() => _ForwardMessagesViewState();
}

class _ForwardMessagesViewState extends State<ForwardMessagesView>
    with ChatObserver {
  late Message message;
  List<Message> messages = [];
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    widget.viewObserver?.addListener(() => setState(() {}));
    message = widget.message;
    downloadMessage();
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  void downloadMessage() async {
    try {
      List<Message> fetchedMsgs =
          await ChatUIKit.instance.fetchCombineMessageDetail(message: message);
      messages.addAll(fetchedMsgs);
    } catch (e) {
      debugPrint('downloadMessage error: $e');
    } finally {
      ChatUIKit.instance
          .loadMessage(messageId: widget.message.msgId)
          .then((value) {
        if (value != null) {
          message = value;
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    CombineMessageBody body = message.body as CombineMessageBody;
    Widget? content;
    if (body.fileStatus == DownloadStatus.DOWNLOADING) {
      content = Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.color.isDark
                ? theme.color.neutralColor4
                : theme.color.neutralColor7,
          ),
        ),
      );
    } else if (body.fileStatus == DownloadStatus.SUCCESS) {
      content = historyWidget(theme);
    } else {
      content = const Center(
        child: Text('下载失败'),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.enableAppBar
          ? widget.appBar ??
              ChatUIKitAppBar(
                centerTitle: false,
                title: widget.title ?? '聊天记录',
              )
          : null,
      body: content,
    );
  }

  Widget historyWidget(ChatUIKitTheme theme) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return item(messages[index], theme);
      },
      separatorBuilder: (context, index) {
        return Divider(
          indent: 58,
          endIndent: 0,
          height: .5,
          thickness: .5,
          color: theme.color.isDark
              ? theme.color.neutralColor3
              : theme.color.neutralColor9,
        );
      },
      itemCount: messages.length,
    );
  }

  Widget item(Message fetchedMsg, ChatUIKitTheme theme) {
    Widget content;
    switch (fetchedMsg.body.type) {
      case MessageType.TXT:
        content = textWidget(fetchedMsg, theme);
        break;
      case MessageType.IMAGE:
        content = imageWidget(fetchedMsg, theme);
        break;
      case MessageType.VIDEO:
        content = videoWidget(fetchedMsg, theme);
        break;
      case MessageType.VOICE:
        content = voiceWidget(fetchedMsg, theme);
        break;
      case MessageType.LOCATION:
        content = locationWidget(fetchedMsg, theme);
        break;
      case MessageType.COMBINE:
        content = combineWidget(fetchedMsg, theme);
        break;
      case MessageType.FILE:
        content = fileWidget(fetchedMsg, theme);
        break;
      case MessageType.CUSTOM:
        if (fetchedMsg.isCardMessage) {
          content = cardWidget(fetchedMsg, theme);
        } else {
          content = const SizedBox();
        }
        break;
      default:
        content = const SizedBox();
    }

    Widget titleRow = Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            fetchedMsg.nickname ?? fetchedMsg.from!,
            textScaler: TextScaler.noScaling,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: theme.color.isDark
                  ? theme.color.neutralSpecialColor6
                  : theme.color.neutralSpecialColor5,
              fontSize: theme.font.titleSmall.fontSize,
              fontWeight: theme.font.titleSmall.fontWeight,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          ChatUIKitTimeFormatter.instance.formatterHandler?.call(context,
                  ChatUIKitTimeType.conversation, fetchedMsg.serverTime) ??
              ChatUIKitTimeTool.getChatTimeStr(fetchedMsg.serverTime),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor6
                : theme.color.neutralColor5,
            fontSize: theme.font.bodySmall.fontSize,
            fontWeight: theme.font.bodySmall.fontWeight,
          ),
        ),
      ],
    );

    content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        ChatUIKitAvatar(avatarUrl: fetchedMsg.avatarUrl),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleRow,
              content,
            ],
          ),
        )
      ],
    );

    content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: content,
    );

    return content;
  }

  Widget textWidget(Message message, ChatUIKitTheme theme) {
    final body = message.body as TextMessageBody;
    return SelectableText(
      body.content,
      style: TextStyle(
        fontWeight: theme.font.bodyMedium.fontWeight,
        fontSize: theme.font.bodyMedium.fontSize,
      ),
    );
  }

  Widget imageWidget(Message message, ChatUIKitTheme theme) {
    return InkWell(
      onTap: () {
        ChatUIKitRoute.pushOrPushNamed(
            context,
            ChatUIKitRouteNames.showImageView,
            ShowImageViewArguments(
              message: message,
            ));
      },
      child: ChatUIKitImageMessageWidget(message: message),
    );
  }

  Widget voiceWidget(Message message, ChatUIKitTheme theme) {
    final body = message.body as VoiceMessageBody;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${[ChatUIKitLocal.messageCellCombineVoice.getString(context)]}",
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        ),
        Text(
          " ${body.duration}'",
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        )
      ],
    );
  }

  Widget videoWidget(Message message, ChatUIKitTheme theme) {
    return InkWell(
      onTap: () {
        ChatUIKitRoute.pushOrPushNamed(
            context,
            ChatUIKitRouteNames.showVideoView,
            ShowVideoViewArguments(
              message: message,
            ));
      },
      child: ChatUIKitVideoMessageWidget(message: message),
    );
  }

  Widget locationWidget(Message message, ChatUIKitTheme theme) {
    final body = message.body as LocationMessageBody;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${[ChatUIKitLocal.messageCellCombineLocation.getString(context)]}",
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        ),
        Text(
          " ${body.address ?? ''}'",
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        )
      ],
    );
  }

  Widget cardWidget(Message message, ChatUIKitTheme theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${[ChatUIKitLocal.messageCellCombineContact.getString(context)]}",
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        ),
        Text(
          " ${message.cardUserNickname ?? message.cardUserId ?? ''}",
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        )
      ],
    );
  }

  Widget combineWidget(Message message, ChatUIKitTheme theme) {
    return Text(
      "${[ChatUIKitLocal.messageCellCombineCombine.getString(context)]}",
      textScaler: TextScaler.noScaling,
      style: TextStyle(
        textBaseline: TextBaseline.alphabetic,
        fontWeight: theme.font.bodyMedium.fontWeight,
        fontSize: theme.font.bodyMedium.fontSize,
      ),
    );
  }

  Widget fileWidget(Message message, ChatUIKitTheme theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${[ChatUIKitLocal.messageCellCombineFile.getString(context)]}",
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        ),
        Text(
          " ${message.displayName}",
          textScaler: TextScaler.noScaling,
          style: TextStyle(
            textBaseline: TextBaseline.alphabetic,
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
          ),
        )
      ],
    );
  }
}
