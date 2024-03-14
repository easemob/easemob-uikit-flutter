import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/tool/remote_avatars.dart';
import 'package:em_chat_uikit_example/tool/user_data_store.dart';
import 'package:flutter/material.dart';

class ChangeAvatarPage extends StatefulWidget {
  const ChangeAvatarPage({super.key});

  @override
  State<ChangeAvatarPage> createState() => _ChangeAvatarPageState();
}

class _ChangeAvatarPageState extends State<ChangeAvatarPage> {
  int _selected = -1;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        title: '修改头像',
        titleTextStyle: TextStyle(
          fontSize: theme.font.titleMedium.fontSize,
          fontWeight: theme.font.titleMedium.fontWeight,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: GridView.custom(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          childrenDelegate: SliverChildBuilderDelegate((context, position) {
            return InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (_selected == position) {
                  _selected = -1;
                } else {
                  _selected = position;
                  ChatUIKitProfile? data =
                      ChatUIKitProvider.instance.currentUserProfile;
                  if (data == null) {
                    data = ChatUIKitProfile.contact(
                      id: ChatUIKit.instance.currentUserId!,
                      avatarUrl: RemoteAvatars.avatars[position],
                    );
                  } else {
                    data = data.copyWith(
                        avatarUrl: RemoteAvatars.avatars[position]);
                  }
                  ChatUIKitProvider.instance.addProfiles([data]);
                  UserDataStore().saveUserData(data);
                }
                setState(() {});
              },
              child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    )),
                    margin: const EdgeInsets.all(10),
                    child: ChatUIKitAvatar(
                        avatarUrl: RemoteAvatars.avatars[position], size: 300),
                  ),
                  Positioned.fill(
                    child: Offstage(
                      offstage: _selected != position,
                      child: Image.asset(
                        'assets/images/avatar_selected.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                ],
              ),
            );
          }, childCount: RemoteAvatars.avatars.length),
        ),
      ),
    );
  }
}
