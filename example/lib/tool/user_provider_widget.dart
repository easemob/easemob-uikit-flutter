import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:em_chat_uikit_example/tool/remote_avatars.dart';
import 'package:flutter/material.dart';

class UserProviderWidget extends StatefulWidget {
  const UserProviderWidget({required this.child, super.key});

  final Widget child;

  @override
  State<UserProviderWidget> createState() => _UserProviderWidgetState();
}

class _UserProviderWidgetState extends State<UserProviderWidget>
    with GroupObserver {
  late SharedPreferences sharedPreferences;

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    ChatUIKitProvider.instance.profilesHandler = _profilesHandler;
    addDataToChatUIKit();
  }

  @override
  void onGroupCreatedByMyself(Group group) {
    ChatUIKitProvider.instance.addProfiles(
      [ChatUIKitProfile.group(id: group.groupId, name: group.name)],
    );
  }

  @override
  void onGroupNameChangedByMeSelf(Group group) {
    ChatUIKitProvider.instance.addProfiles(
      [ChatUIKitProfile.group(id: group.groupId, name: group.name)],
    );
  }

  void addDataToChatUIKit() async {
    List<Group> groups = await ChatUIKit.instance.getJoinedGroups();
    List<ChatUIKitProfile> profiles = [];
    for (var group in groups) {
      profiles.add(
        ChatUIKitProfile.group(id: group.groupId, name: group.name),
      );
    }
    ChatUIKitProvider.instance.addProfiles(profiles);
  }

  List<ChatUIKitProfile>? _profilesHandler(
    List<ChatUIKitProfile> profiles,
  ) {
    List<ChatUIKitProfile> list = [];

    for (var profile in profiles) {
      if (profile.type == ChatUIKitProfileType.contact) {
        list.add(
          profile.copy(
            name: profile.showName,
            avatarUrl: RemoteAvatars.getRandomAvatar,
          ),
        );
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
