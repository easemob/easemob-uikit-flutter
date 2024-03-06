import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/widgets/list_item.dart';
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
      appBar: ChatUIKitAppBar(
        showBackButton: false,
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
      ),
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
      textScaler: TextScaler.noScaling,
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
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Text('设置', textScaler: TextScaler.noScaling),
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
          onTap: generalSettings,
          child: ListItem(
            imageWidget: Image.asset('assets/images/settings.png'),
            title: '通用',
            enableArrow: true,
          ),
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
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: InkWell(
            onTap: () {
              logout();
            },
            child: Text(
              '退出登录',
              textScaler: TextScaler.noScaling,
              style: TextStyle(
                fontWeight: theme.font.titleMedium.fontWeight,
                fontSize: theme.font.titleMedium.fontSize,
                color: theme.color.isDark
                    ? theme.color.primaryColor6
                    : theme.color.primaryColor5,
              ),
            ),
          ),
        ),
      ],
    );

    return content;
  }

  void pushToPersonalInfoPage() {
    Navigator.of(context).pushNamed('/personal_info').then(
      (value) {
        setState(() {});
      },
    );
  }

  void generalSettings() {
    Navigator.of(context).pushNamed('/general_page').then(
      (value) {
        setState(() {});
      },
    );
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
