import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrentUserInfoView extends StatefulWidget {
  CurrentUserInfoView.arguments(CurrentUserInfoViewArguments arguments,
      {super.key})
      : profile = arguments.profile,
        appBar = arguments.appBar,
        enableAppBar = arguments.enableAppBar,
        attributes = arguments.attributes;

  const CurrentUserInfoView({
    required this.profile,
    this.appBar,
    this.enableAppBar = true,
    this.attributes,
    super.key,
  });
  final ChatUIKitProfile profile;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final String? attributes;

  @override
  State<CurrentUserInfoView> createState() => _CurrentUserInfoViewState();
}

class _CurrentUserInfoViewState extends State<CurrentUserInfoView> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        appBar: !widget.enableAppBar
            ? null
            : widget.appBar ??
                const ChatUIKitAppBar(
                  showBackButton: true,
                ),
        body: _buildContent());

    return content;
  }

  Widget _buildContent() {
    final theme = ChatUIKitTheme.of(context);
    Widget avatar = ChatUIKitAvatar(
      avatarUrl: ChatUIKitProvider.instance.currentUserData?.avatarUrl,
      size: 100,
    );

    Widget name = Text(
      ChatUIKitProvider.instance.currentUserData?.nickname ??
          ChatUIKit.instance.currentUserId ??
          '',
      overflow: TextOverflow.ellipsis,
      textScaler: TextScaler.noScaling,
      maxLines: 1,
      style: TextStyle(
        fontSize: theme.font.headlineLarge.fontSize,
        fontWeight: theme.font.headlineLarge.fontWeight,
        color: theme.color.isDark
            ? theme.color.neutralColor100
            : theme.color.neutralColor1,
      ),
    );

    Widget easeId = Text(
      'ID: ${widget.profile.id}',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textScaler: TextScaler.noScaling,
      style: TextStyle(
        fontSize: theme.font.bodySmall.fontSize,
        fontWeight: theme.font.bodySmall.fontWeight,
        color: theme.color.isDark
            ? theme.color.neutralColor5
            : theme.color.neutralColor7,
      ),
    );

    Widget row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        easeId,
        const SizedBox(width: 2),
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Clipboard.setData(ClipboardData(text: widget.profile.id));
            ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.userIdCopied);
          },
          child: Icon(
            Icons.file_copy_sharp,
            size: 16,
            color: theme.color.isDark
                ? theme.color.neutralColor5
                : theme.color.neutralColor7,
          ),
        ),
      ],
    );

    Widget content = Column(
      children: [
        const SizedBox(height: 20),
        avatar,
        const SizedBox(height: 12),
        name,
        const SizedBox(height: 4),
        row,
        const SizedBox(height: 20),
      ],
    );

    return content;
  }
}
