import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ChatUIKitAvatar extends StatefulWidget {
  ChatUIKitAvatar.current({
    this.size = 32,
    this.cornerRadius,
    this.avatarUrl,
    super.key,
  }) {
    isCurrent = true;
  }

  ChatUIKitAvatar({
    this.avatarUrl,
    this.size = 32,
    this.cornerRadius,
    ValueKey? key,
  }) : super(key: key ?? ValueKey(avatarUrl)) {
    isCurrent = false;
  }
  final double size;
  final CornerRadius? cornerRadius;
  final String? avatarUrl;
  late final bool isCurrent;

  @override
  State<ChatUIKitAvatar> createState() => _ChatUIKitAvatarState();
}

class _ChatUIKitAvatarState extends State<ChatUIKitAvatar>
    with ChatUIKitProviderObserver {
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    if (widget.isCurrent) {
      ChatUIKitProvider.instance.addObserver(this);
    }

    avatarUrl = widget.avatarUrl;
  }

  @override
  void didUpdateWidget(covariant ChatUIKitAvatar oldWidget) {
    if (oldWidget.avatarUrl != avatarUrl) {
      avatarUrl = widget.avatarUrl;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.isCurrent) {
      ChatUIKitProvider.instance.removeObserver(this);
    }
    super.dispose();
  }

  @override
  void onCurrentUserDataUpdate(UserData? userData) {
    if (userData?.avatarUrl?.isNotEmpty == true &&
        avatarUrl != userData?.avatarUrl) {
      setState(() {
        avatarUrl = userData?.avatarUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? placeholder = ChatUIKitSettings.avatarPlaceholder;
    Widget content = Container(
        width: widget.size,
        height: widget.size,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            CornerRadiusHelper.avatarRadius(
              widget.size,
              cornerRadius: widget.cornerRadius,
            ),
          ),
        ),
        child: avatarUrl?.isNotEmpty == true
            ? ChatUIKitImageLoader.networkImage(
                size: widget.size,
                image: avatarUrl!,
                placeholder: placeholder ??
                    AssetImage('assets/images/avatar.png',
                        package: ChatUIKitImageLoader.packageName),
                placeholderWidget: ChatUIKitImageLoader.defaultAvatar(
                  height: widget.size,
                  width: widget.size,
                ),
              )
            : ChatUIKitImageLoader.defaultAvatar(
                height: widget.size,
                width: widget.size,
              ));
    return content;
  }
}
