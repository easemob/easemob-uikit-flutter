// ignore_for_file: deprecated_member_use

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/tool/user_data_store.dart';
import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage>
    with ChatUIKitProviderObserver {
  UserData? _userData;

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        title: '个人信息',
        titleTextStyle: TextStyle(
          fontSize: theme.font.titleMedium.fontSize,
          fontWeight: theme.font.titleMedium.fontWeight,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            PersonalInfoItem(
              title: '头像',
              imageWidget: ChatUIKitAvatar.current(
                avatarUrl: _userData?.avatarUrl,
                size: 40,
              ),
              onTap: pushChangeAvatarPage,
            ),
            PersonalInfoItem(
              title: '昵称',
              trailing:
                  _userData?.nickname ?? ChatUIKit.instance.currentUserId ?? '',
              onTap: pushChangeNicknamePage,
              enableArrow: true,
            ),
          ],
        ),
      ),
    );
  }

  void pushChangeAvatarPage() {
    Navigator.of(context).pushNamed('/change_avatar').then((value) {
      setState(() {});
    });
  }

  void pushChangeNicknamePage() {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.changeInfoView,
      ChangeInfoViewArguments(
        title: '修改昵称',
        inputTextCallback: () {
          return Future(
            () {
              return ChatUIKitProvider.instance.currentUserData?.nickname ??
                  ChatUIKit.instance.currentUserId ??
                  '';
            },
          );
        },
      ),
    ).then(
      (value) {
        if (value is String) {
          UserData? data = ChatUIKitProvider.instance.currentUserData;
          if (data == null) {
            data = UserData(nickname: value);
          } else {
            data = data.copyWith(nickname: value);
          }
          ChatUIKitProvider.instance.currentUserData = data;
          UserDataStore().saveUserData(data);
          setState(() {});
        }
      },
    );
  }
}

class PersonalInfoItem extends StatelessWidget {
  const PersonalInfoItem(
      {required this.title,
      this.trailing,
      this.imageWidget,
      this.enableArrow = false,
      this.onTap,
      super.key});

  final String title;
  final String? trailing;
  final Widget? imageWidget;
  final bool enableArrow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = SizedBox(
      height: 54,
      child: Row(
        children: [
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
          Expanded(
            child: Text(
              trailing ?? '',
              textScaleFactor: 1.0,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: theme.font.labelLarge.fontSize,
                fontWeight: theme.font.labelLarge.fontWeight,
                color: theme.color.isDark
                    ? theme.color.neutralColor7
                    : theme.color.neutralColor5,
              ),
            ),
          ),
          if (imageWidget != null)
            SizedBox(
              width: 40,
              height: 40,
              child: imageWidget,
            ),
          const SizedBox(width: 8),
          if (enableArrow) const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );

    content = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16), child: content);

    content = Column(
      children: [
        content,
        Divider(
          height: 0.5,
          indent: 16,
          color: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor9,
        )
      ],
    );

    content = InkWell(
      onTap: onTap,
      child: content,
    );

    return content;
  }
}
