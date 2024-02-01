// ignore_for_file: deprecated_member_use

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/notifications/theme_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with ChatUIKitProviderObserver {
  UserData? _userData;
  bool isLight = true;
  @override
  void initState() {
    super.initState();
    ChatUIKitProvider.instance.addObserver(this);
    _userData = ChatUIKitProvider.instance.currentUserData;
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onCurrentUserDataUpdate(UserData? userData) {
    setState(() {
      _userData = userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      body: SafeArea(
        top: false,
        bottom: false,
        child: _buildContent(),
      ),
    );

    return content;
  }

  Widget _buildContent() {
    final theme = ChatUIKitTheme.of(context);
    Widget avatar = ChatUIKitAvatar.current(
      avatarUrl: _userData?.avatarUrl,
      size: 100,
    );

    Widget name = Text(
      _userData?.nickname ?? ChatUIKit.instance.currentUserId ?? '',
      textScaleFactor: 1.0,
      overflow: TextOverflow.ellipsis,
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
      'ID: ${ChatUIKit.instance.currentUserId}',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textScaleFactor: 1.0,
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
          onTap: () {
            Clipboard.setData(
                ClipboardData(text: ChatUIKit.instance.currentUserId ?? ''));
            ChatUIKit.instance.sendChatUIKitEvent(
              ChatUIKitEvent.userIdCopied,
            );
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
      ],
    );

    content = ListView(
      children: [
        content,
        const SizedBox(height: 20),
        const Text(
          '设置',
          textScaleFactor: 1.0,
        ),
        InkWell(
          onTap: nonsupport,
          child: ListItem(
            imageWidget: Image.asset('assets/images/online.png'),
            title: '在线状态',
          ),
        ),
        InkWell(
          onTap: pushToPersonalInfoPage,
          child: ListItem(
            imageWidget: Image.asset('assets/images/personal.png'),
            title: '个人信息',
            enableArrow: true,
          ),
        ),
        InkWell(
          onTap: nonsupport,
          child: ListItem(
            imageWidget: Image.asset('assets/images/settings.png'),
            title: '通用',
          ),
        ),
        ListItem(
          imageWidget: Image.asset('assets/images/settings.png'),
          title: '切换主题',
          trailingWidget: CupertinoSwitch(
              value: ThemeNotification.isLight,
              onChanged: (value) {
                ThemeNotification.isLight = !ThemeNotification.isLight;
                ThemeNotification().dispatch(context);
                setState(() {});
              }),
        ),
        InkWell(
          onTap: nonsupport,
          child: ListItem(
            imageWidget: Image.asset('assets/images/notifications.png'),
            title: '消息通知',
          ),
        ),
        InkWell(
          onTap: nonsupport,
          child: ListItem(
            imageWidget: Image.asset('assets/images/secret.png'),
            title: '隐私',
          ),
        ),
        InkWell(
          onTap: nonsupport,
          child: ListItem(
            imageWidget: Image.asset('assets/images/info.png'),
            title: '关于',
            trailingString: 'Easemob UIKit v2.0.0',
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            logout();
          },
          child: Text(
            '退出登录',
            textScaleFactor: 1.0,
            style: TextStyle(
              fontWeight: theme.font.titleMedium.fontWeight,
              fontSize: theme.font.titleMedium.fontSize,
              color: theme.color.isDark
                  ? theme.color.primaryColor6
                  : theme.color.primaryColor5,
            ),
          ),
        ),
      ],
    );

    content = Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 60, bottom: 10),
      child: content,
    );

    return content;
  }

  void pushToPersonalInfoPage() {
    Navigator.of(context)
        .pushNamed('/personal_info')
        .then((value) => setState(() {}));
  }

  void nonsupport() {
    showChatUIKitDialog(
      title: '暂不支持',
      context: context,
      items: [
        ChatUIKitDialogItem.confirm(
          label: '确定',
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void logout() {
    showChatUIKitDialog(
      title: '退出登录',
      context: context,
      items: [
        ChatUIKitDialogItem.cancel(
          label: '取消',
          onTap: () async {
            Navigator.of(context).pop();
          },
        ),
        ChatUIKitDialogItem.confirm(
          label: '退出',
          onTap: () async {
            Navigator.of(context).pop();
            ChatUIKit.instance.logout().then((value) {
              Navigator.of(context).popAndPushNamed('/login');
            });
          },
        ),
      ],
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    required this.imageWidget,
    required this.title,
    this.trailingString,
    this.trailingWidget,
    this.enableArrow = false,
    super.key,
  });

  final Widget imageWidget;
  final String title;
  final String? trailingString;
  final Widget? trailingWidget;
  final bool enableArrow;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = SizedBox(
      height: 54,
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: imageWidget,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            textScaleFactor: 1.0,
            style: TextStyle(
              fontSize: theme.font.titleMedium.fontSize,
              fontWeight: theme.font.titleMedium.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor100
                  : theme.color.neutralColor1,
            ),
          ),
          Expanded(child: Container()),
          if (trailingWidget != null) trailingWidget!,
          if (trailingWidget == null)
            Text(
              trailingString ?? '',
              textAlign: TextAlign.right,
              textScaleFactor: 1.0,
              style: TextStyle(
                fontSize: theme.font.labelMedium.fontSize,
                fontWeight: theme.font.labelMedium.fontWeight,
                color: theme.color.isDark
                    ? theme.color.neutralColor7
                    : theme.color.neutralColor5,
              ),
            ),
          if (enableArrow) const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );

    content = Column(
      children: [
        content,
        Divider(
          height: 0.5,
          indent: 36,
          color: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor9,
        )
      ],
    );

    return content;
  }
}
