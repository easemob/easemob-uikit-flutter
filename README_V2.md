# ChatUIKit for flutter

# 单群聊 UIKit

本产品主要旨在给用户打造一个良好体验的单群聊UIKit。主要为用户解决直接集成SDK繁琐，复杂度高等问题。致力于打造集成简单，自由度高，流程简单，文档说明足够详细的单群聊UIKit产品。

# 单群聊 UIKit 指南

## 简介

本指南介绍了 ChatUIKit 框架在 flutter 开发中的概述和使用示例，并描述了该 UIKit 的各个组件和功能，使开发人员能够很好地了解 UIKit 并有效地使用它。

<!-- ## 目录 
- [ChatUIKit for flutter](#chatuikit-for-flutter)
- [单群聊 UIKit](#单群聊-uikit)
- [单群聊 UIKit 指南](#单群聊-uikit-指南)
  - [简介](#简介)
  - [目录](#目录)
- [前置开发环境要求](#前置开发环境要求)
- [安装](#安装)
- [结构](#结构)
- [快速开始](#快速开始)
- [进阶用法](#进阶用法)
- [自定义](#自定义)
- [设计指南](#设计指南) -->

# 前置开发环境要求

```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.3.0"
```

- ios 13+
- android api 21+

# 安装

```bash
flutter pub add em_chat_uikit
```

# 结构

```bash
.
├── chat_uikit.dart                                             // library
├── chat_uikit_alphabet_sort_helper.dart                        // 联系人首字母排序纠正工具
├── chat_uikit_defines.dart                                     // UIKit handler 定义类
├── chat_uikit_emoji_data.dart                                  // 消息表情数据类
├── chat_uikit_localizations.dart                               // 国际化工具类
├── chat_uikit_service                                          // 对 chat sdk 包装类的二次包装，用于将包装类中不符合的功能再次修改以适配 UIKit 功能
├── chat_uikit_settings.dart                                    // 功能设置类，用于开关和配置某些功能
├── chat_uikit_time_formatter.dart                              // 时间显示格式设置工具
├── provider                                                    // 用户属性工具
│   ├── chat_uikit_profile.dart                                 // 用户属性对象，包括头像，昵称，备注等。
│   └── chat_uikit_provider.dart                                // 用户属性 Provider，需要通过实现 Provider，为 UIKit 中的 Profile 设置数据。
├── sdk_service                                                 // 对 chat sdk 的包装，用于包装 chat sdk 对外接口, UIKit 只与 包装类打交道，不直接调用 chat sdk
├── tools                                                       // 内部的工具类
│   ├── chat_uikit_context.dart                                 // 数据上下文，用于存储一些状态
│   ├── chat_uikit_conversation_extension.dart                  // 会话列表的加工类，用于预加工一些属性
│   ├── chat_uikit_file_size_tool.dart                          // 文件大小显示计算工具
│   ├── chat_uikit_helper.dart                                  // 内部计算圆角类
│   ├── chat_uikit_highlight_tool.dart                          // 计算组件高亮工具类
│   ├── chat_uikit_image_loader.dart                            // 图片加载工具类
│   ├── chat_uikit_message_extension.dart                       // 消息加工类，用于预加工一些属性
│   ├── chat_uikit_time_tool.dart                               // 默认时间格式类
│   ├── chat_uikit_url_helper.dart                              // url preview 工具类
│   └── safe_disposed.dart                                      // 内部对 ChangeNotifier 的加工类
├── ui                                                          // UI 组件
│   ├── components                                              // Components
│   ├── controllers                                             // view / widget 相关的 controllers
│   ├── custom                                                  // ui中重写的部分
│   ├── models                                                  // models
│   ├── route                                                   // uikit 中的路由组件
│   ├── views                                                   // Views
│   └── widgets                                                 // widgets
└── universal                                                   // 内部使用类
```

# 快速开始

1. 创建项目

```bash
flutter create uikit_quick_start --platforms=android,ios
```

2. 添加依赖

```bash
cd uikit_quick_start
flutter pub add em_chat_uikit
flutter pub get
```

3. 添加权限

- iOS: 在 `<project root>/ios/Runner/Info.plist` 中添加以下权限。

```xml
NSPhotoLibraryUsageDescription
NSCameraUsageDescription
NSMicrophoneUsageDescription
```

4. 初始化 UIKit

```dart
import 'package:em_chat_uikit/chat_uikit.dart';
...

void main() {
  ChatUIKit.instance
      .init(options: Options(appKey: <!--Your AppKey-->, autoLogin: false))
      .then((value) {
    runApp(const MyApp());
  });
}

```

5. 登录

```dart
Future<void> login() async {
  try {
    await ChatUIKit.instance.loginWithToken(
        userId: '<!--user id-->',
        token: '<!--user token-->');
  } catch (e) {
    debugPrint('login error: $e');
  }
}
```

6. 创建聊天页面

```dart
class ChatPage extends StatefulWidget {
  const ChatPage({required this.chatterId, super.key});
  final String chatterId;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return MessagesView(
      profile: ChatUIKitProfile.contact(
        id: widget.chatterId,
      ),
    );
  }
}
```

完整代码

```dart
import 'package:flutter/material.dart';
import 'package:em_chat_uikit/chat_uikit.dart';

const String appKey = '';
const String userId = '';
const String token = '';

const String chatterId = '';

void main() {
  ChatUIKit.instance
      .init(options: Options(appKey: appKey, autoLogin: false))
      .then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: chat,
              child: const Text('Chat'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    try {
      await ChatUIKit.instance.loginWithToken(
        userId: userId,
        token: token,
      );
    } catch (e) {
      debugPrint('login error: $e');
    }
  }

  void chat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatPage(
          chatterId: chatterId,
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({required this.chatterId, super.key});
  final String chatterId;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return MessagesView(
      profile: ChatUIKitProfile.contact(
        id: widget.chatterId,
      ),
    );
  }
}
```


# 进阶用法

## Provider

Provider 是一个数据提供者，当需要展示用户或群组信息时 UIKit 会通过 Provider 向你请求数据，你需要将数据返回给 Provider, 当UIKit 得到你传入的数据时会根据你的数据进行刷新和显示。下面是 Provider 的具体实现示例(`example/lib/widgets/user_provider_widget.dart`)。

### 示例

```dart

class UserProviderWidget extends StatefulWidget {
  const UserProviderWidget({required this.child, super.key});

  final Widget child;

  @override
  State<UserProviderWidget> createState() => _UserProviderWidgetState();
}

class _UserProviderWidgetState extends State<UserProviderWidget>
    with GroupObserver {
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    // Open DB
    UserDataStore().init(onOpened: onOpened);
    // Set Provider Handler
    ChatUIKitProvider.instance.profilesHandler = onProfilesRequest;
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void onOpened() async {
    // 1. Fill all stored data into uikit.
    await addAllUserInfoToProvider();
    // 2. Load group information, and check if it has been filled into uikit. If not, fetch data from the server and then fill it into uikit.
    await loadGroupInfos();
    // 2. Load user information, and check if it has been filled into uikit. If not, fetch data from the server and then fill it into uikit.
    await loadUserInfos();
    // 3. etch current user information, then fill it into uikit.
    await fetchCurrentUserInfo();
  }

  Future<void> fetchCurrentUserInfo() async {
    try {
      // Do not retrieve own data from the db, always fetch the latest data from the server.
      Map<String, UserInfo> map = await ChatUIKit.instance
          .fetchUserInfoByIds([ChatUIKit.instance.currentUserId!]);
      ChatUIKitProfile profile = ChatUIKitProfile.contact(
        id: map.values.first.userId,
        nickname: map.values.first.nickName,
        avatarUrl: map.values.first.avatarUrl,
      );
      UserDataStore().saveUserData(profile);
      ChatUIKitProvider.instance.addProfiles([profile]);
    } catch (e) {
      debugPrint('fetchCurrentUserInfo error: $e');
    }
  }

  // This method is called when uikit needs to display user information and the cache does not exist;
  // it requires fetching and storing the information in the db based on user attributes.
  List<ChatUIKitProfile>? onProfilesRequest(List<ChatUIKitProfile> profiles) {
    List<String> userIds = profiles
        .where((e) => e.type == ChatUIKitProfileType.contact)
        .map((e) => e.id)
        .toList();
    if (userIds.isNotEmpty) {
      fetchUserInfos(userIds);
    }

    List<String> groupIds = profiles
        .where((e) => e.type == ChatUIKitProfileType.group)
        .map((e) => e.id)
        .toList();
    updateGroupsProfile(groupIds);
    return profiles;
  }

  // When a group is created by oneself, it is necessary to fill the group information into uikit.
  @override
  void onGroupCreatedByMyself(Group group) async {
    ChatUIKitProfile profile =
        ChatUIKitProfile.group(id: group.groupId, groupName: group.name);

    ChatUIKitProvider.instance.addProfiles([profile]);
    // save to db
    UserDataStore().saveUserData(profile);
  }

  // When the group name is changed by oneself, it is necessary to update the group information in uikit.
  @override
  void onGroupNameChangedByMeSelf(Group group) {
    ChatUIKitProfile? profile =
        ChatUIKitProvider.instance.getProfileById(group.groupId);

    profile = profile?.copyWith(name: group.name) ??
        ChatUIKitProfile.group(
          id: group.groupId,
          groupName: group.name,
        );

    ChatUIKitProvider.instance.addProfiles([profile]);
    // save to db
    UserDataStore().saveUserData(profile);
  }

  // Fill all stored data into uikit.
  Future<void> addAllUserInfoToProvider() async {
    List<ChatUIKitProfile> list = await UserDataStore().loadAllProfiles();
    ChatUIKitProvider.instance.addProfiles(list);
  }

  // Load group information, and check if it has been filled into uikit. If not, fetch data from the server and then fill it into uikit.
  Future<void> loadGroupInfos() async {
    List<Group> groups = await ChatUIKit.instance.getJoinedGroups();
    List<ChatUIKitProfile> profiles = groups
        .map((e) => ChatUIKitProfile.group(id: e.groupId, groupName: e.name))
        .toList();

    if (profiles.isNotEmpty) {
      UserDataStore().saveUserDatas(profiles);
      ChatUIKitProvider.instance.addProfiles(profiles);
    }
  }

  Future<void> updateGroupsProfile(List<String> groupIds) async {
    List<ChatUIKitProfile> list = [];
    for (var groupId in groupIds) {
      try {
        Group group = await ChatUIKit.instance.fetchGroupInfo(groupId: groupId);
        ChatUIKitProfile profile = ChatUIKitProfile.group(
          id: group.groupId,
          groupName: group.name,
          avatarUrl: group.extension,
        );
        list.add(profile);
      } on ChatError catch (e) {
        if (e.code == 600) {
          // 600 indicates the group does not exist, unable to fetch data, providing default data.
          ChatUIKitProfile profile = ChatUIKitProfile.group(id: groupId);
          list.add(profile);
        }
        debugPrint('loadGroupInfo error: $e');
      }
    }
    UserDataStore().saveUserDatas(list);
    ChatUIKitProvider.instance.addProfiles(list);
  }

  // Load user information, and check if it has been filled into uikit. If not, fetch data from the server and then fill it into uikit.
  Future<void> loadUserInfos() async {
    try {
      Map<String, ChatUIKitProfile> map =
          ChatUIKitProvider.instance.profilesCache;
      List<Contact> contacts = await ChatUIKit.instance.getAllContacts();
      contacts.removeWhere((element) => map.keys.contains(element.userId));
      if (contacts.isNotEmpty) {
        List<String> userIds = contacts.map((e) => e.userId).toList();
        fetchUserInfos(userIds);
      }
    } catch (e) {
      debugPrint('loadUserInfos error: $e');
    }
  }

  void fetchUserInfos(List<String> userIds) async {
    try {
      Map<String, UserInfo> map =
          await ChatUIKit.instance.fetchUserInfoByIds(userIds);
      List<ChatUIKitProfile> list = map.values
          .map((e) => ChatUIKitProfile.contact(
              id: e.userId, nickname: e.nickName, avatarUrl: e.avatarUrl))
          .toList();

      if (list.isNotEmpty) {
        UserDataStore().saveUserDatas(list);
        ChatUIKitProvider.instance.addProfiles(list);
      }
    } catch (e) {
      debugPrint('fetchUserInfos error: $e');
    }
  }
}

```

### 用法讲解

`ChatUIKitProvider` 在使用时需要先设置对应的handler `profilesHandler`, 设置之后，当 UIKit 需要展示对应的信息时，会通过 handler 返会给你一个默认的 `ChatUIKitProfile` 对象，之后需要你返回一个 `ChatUIKitProfile` 对象 建议先返回一个占位的 `ChatUIKitProfile` 对象，当你从你的服务器或者数据库中得到准确的 `ChatUIKitProfile` 对象后，再通过 `ChatUIKitProvider.instance.addProfiles(list)` 方法将其传递给 UIKit， UIKit 在收到后会自定进行页面刷新，并缓存你传入的数据，当再次需要展示时，则直接使用缓存数据。 根据以上描述和示例，在使用 ChatUIKitProvider 时，可以使用一下步骤

1. App 启动并完成登录后，设置 `profilesHandler` 。

```dart
    ChatUIKitProvider.instance.profilesHandler = onProfilesRequest;
```

2. 将数据库中的用户和群组数据通过 `ChatUIKitProvider` 设置到 UIKit 中。

```dart
    List<ChatUIKitProfile> list = await UserDataStore().loadAllProfiles();
    ChatUIKitProvider.instance.addProfiles(list);
```

3. 当 `profilesHandler` 执行时，先返回占位 `ChatUIKitProfile`, 之后从服务器获数据，将获取到的数据存到本地，并传递给 UIKit。

```dart
  List<ChatUIKitProfile>? onProfilesRequest(List<ChatUIKitProfile> profiles) {
    List<String> userIds = profiles
        .where((e) => e.type == ChatUIKitProfileType.contact)
        .map((e) => e.id)
        .toList();
    if (userIds.isNotEmpty) {
      fetchUserInfos(userIds);
    }

    List<String> groupIds = profiles
        .where((e) => e.type == ChatUIKitProfileType.group)
        .map((e) => e.id)
        .toList();
    updateGroupsProfile(groupIds);
    return profiles;
  }
```

## 自定义

ChatUIKit 允许通过 ChatUIKitSettings 进行快速的样式自定义。

```dart
import 'chat_uikit.dart';

import 'package:flutter/material.dart';

enum CornerRadius { extraSmall, small, medium, large }

class ChatUIKitSettings {
  /// Specifies the corner radius for the avatars in the uikit.
  static CornerRadius avatarRadius = CornerRadius.medium;

  /// Specifies the corner radius of the search box.
  static CornerRadius searchBarRadius = CornerRadius.small;

  /// Specifies the corner radius of the input box.
  static CornerRadius inputBarRadius = CornerRadius.medium;

  /// Default avatar placeholder image
  static ImageProvider? avatarPlaceholder;

  /// The corner radius for the dialog.
  static ChatUIKitDialogRectangleType dialogRectangleType =
      ChatUIKitDialogRectangleType.filletCorner;

  /// Default display style of message bubbles
  static ChatUIKitMessageListViewBubbleStyle messageBubbleStyle =
      ChatUIKitMessageListViewBubbleStyle.arrow;

  /// Whether to show avatars in the conversation list
  static bool showConversationListAvatar = true;

  /// Whether to show unread message count in the conversation list
  static bool showConversationListUnreadCount = true;

  // Mute icon displayed in the conversation list
  static ImageProvider? conversationListMuteImage;

  /// Message long press menu
  static List<ChatUIKitActionType> msgItemLongPressActions = [
    ChatUIKitActionType.reaction,
    ChatUIKitActionType.copy, // only text message
    ChatUIKitActionType.forward,
    ChatUIKitActionType.thread, // only group message
    ChatUIKitActionType.reply,
    ChatUIKitActionType.recall,
    ChatUIKitActionType.edit, // only text message
    ChatUIKitActionType.multiSelect,
    ChatUIKitActionType.pinMessage,
    ChatUIKitActionType.translate, // only text message
    ChatUIKitActionType.report,
    ChatUIKitActionType.delete,
  ];

  /// Whether to enable the functionality of input status for one-on-one chat messages.
  static bool enableTypingIndicator = false;

  /// Whether to enable the thread feature
  static bool enableMessageThread = false;

  /// Whether to enable message translation feature
  static bool enableMessageTranslation = false;

  /// Message translation target language
  static String translateTargetLanguage = 'zh-Hans';

  /// Whether to enable message reaction feature
  static bool enableMessageReaction = false;

  /// Message emoji reply bottom sheet title display content, this content needs to be included in the emoji list [ChatUIKitEmojiData.emojiList].
  static List<String> favoriteReaction = [
    '\u{1F44D}',
    '\u{2764}',
    '\u{1F609}',
    '\u{1F928}',
    '\u{1F62D}',
    '\u{1F389}',
  ];

  /// Default message URL regular expression
  static RegExp defaultUrlRegExp = RegExp(
    r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
    caseSensitive: false,
  );

  /// Whether to enable the message pinning feature
  static bool enablePinMsg = true;

  /// Whether to enable message quoting feature
  static bool enableMessageReply = true;

  /// Whether to enable message recall feature
  static bool enableMessageRecall = true;

  /// Time limit for message recall, in seconds
  static int recallExpandTime = 120;

  /// Whether to enable message editing feature
  static bool enableMessageEdit = true;

  /// Whether to enable message reporting feature
  static bool enableMessageReport = true;

  /// Message report tags, can be customized. The reasons for reporting should be written in the localization file, and the key for the reason in the localization file should be consistent with the tag. For example, [ChatUIKitLocal.reportTarget1]
  static List<String> reportMessageTags = [
    'tag1',
    'tag2',
    'tag3',
    'tag4',
    'tag5',
    'tag6',
    'tag7',
    'tag8',
    'tag9',
  ];

  /// Whether to enable message multi-select forwarding feature
  static bool enableMessageMultiSelect = true;

  /// Whether to enable message forwarding feature
  static bool enableMessageForward = true;

  /// Contact alphabetical sorting order, if there are Chinese characters, you can redefine the initials using [ChatUIKitAlphabetSortHelper].
  static String sortAlphabetical = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ#';
}

```

# 设计指南
