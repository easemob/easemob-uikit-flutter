import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/demo_localizations.dart';
import 'package:em_chat_uikit_example/tool/app_server_helper.dart';
import 'package:em_chat_uikit_example/tool/user_data_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> with ChatUIKitProviderObserver {
  ChatUIKitProfile? _userData;

  @override
  void initState() {
    super.initState();
    ChatUIKitProvider.instance.addObserver(this);
    _userData = ChatUIKitProvider.instance.currentUserProfile;
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onProfilesUpdate(
    Map<String, ChatUIKitProfile> map,
  ) {
    if (map.keys.contains(ChatUIKit.instance.currentUserId)) {
      ChatUIKitProfile? userData = map[ChatUIKit.instance.currentUserId];
      setState(() {
        _userData = userData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark ? theme.color.neutralColor1 : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        title: DemoLocalizations.personalInfo.localString(context),
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
              title: DemoLocalizations.avatar.localString(context),
              imageWidget: ChatUIKitAvatar.current(
                avatarUrl: _userData?.avatarUrl,
                size: 40,
              ),
              onTap: changeAvatar,
            ),
            PersonalInfoItem(
              title: DemoLocalizations.nickname.localString(context),
              trailing: _userData?.showName ?? ChatUIKit.instance.currentUserId ?? '',
              onTap: pushChangeNicknamePage,
              enableArrow: true,
            ),
          ],
        ),
      ),
    );
  }

  void changeAvatar() {
    List<ChatUIKitBottomSheetItem> items = [
      ChatUIKitBottomSheetItem.normal(
        actionType: ChatUIKitActionType.custom,
        label: DemoLocalizations.changeAvatarCamera.localString(context),
        onTap: () async {
          Navigator.of(context).pop();
          takePhoto();
        },
      ),
      ChatUIKitBottomSheetItem.normal(
        actionType: ChatUIKitActionType.custom,
        label: DemoLocalizations.changeAvatarGallery.localString(context),
        onTap: () async {
          Navigator.of(context).pop();
          selectPhoto();
        },
      ),
    ];

    showChatUIKitBottomSheet(
      context: context,
      items: items,
    );
  }

  void takePhoto() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 50,
      );
      if (image != null) {
        cropImage(image.path);
      }
    } catch (e) {
      ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.noCameraPermission);
    }
  }

  void selectPhoto() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 50,
      );
      if (image != null) {
        cropImage(image.path);
      }
    } catch (e) {
      ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.noCameraPermission);
    }
  }

  Future<void> cropImage(String imagePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: true,
        ),
        IOSUiSettings(
          rectX: 0,
          rectY: 0,
          rectWidth: 10000,
          rectHeight: 10000,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );

    if (croppedFile != null) {
      uploadAvatar(croppedFile.path);
    }
  }

  void uploadAvatar(String path) async {
    try {
      EasyLoading.show(status: 'Updating...');
      String url = await AppServerHelper.uploadAvatar(ChatUIKit.instance.currentUserId!, path);
      ChatUIKitProfile? data = ChatUIKitProvider.instance.currentUserProfile;
      if (data == null) {
        data = ChatUIKitProfile.contact(id: ChatUIKit.instance.currentUserId!, avatarUrl: url);
      } else {
        data = data.copyWith(avatarUrl: url);
      }
      await updateUserInfo(data);
    } catch (e) {
      debugPrint('upload avatar error: $e');
      EasyLoading.showError('Update failed');
    }
  }

  void pushChangeNicknamePage() {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.changeInfoView,
      ChangeInfoViewArguments(
        title: DemoLocalizations.changeNickname.localString(context),
        inputTextCallback: () {
          return Future(
            () {
              return ChatUIKitProvider.instance.currentUserProfile?.showName ?? ChatUIKit.instance.currentUserId ?? '';
            },
          );
        },
      ),
    ).then(
      (value) {
        if (value is String) {
          ChatUIKitProfile? data = ChatUIKitProvider.instance.currentUserProfile;
          if (data == null) {
            data = ChatUIKitProfile.contact(id: ChatUIKit.instance.currentUserId!, nickname: value);
          } else {
            data = data.copyWith(name: value);
          }
          return data;
        }
      },
    ).then((value) {
      if (value != null) {
        return updateUserInfo(value);
      }
    }).then((value) {
      setState(() {});
    }).catchError((e) {
      debugPrint('change nickname error: $e');
      EasyLoading.showError('Update failed');
    });
  }

  Future<void> updateUserInfo(ChatUIKitProfile data) async {
    EasyLoading.show(status: 'Updating...');
    try {
      await ChatUIKit.instance.updateUserInfo(nickname: data.name, avatarUrl: data.avatarUrl);
      UserDataStore().saveUserData(data);
      ChatUIKitProvider.instance.addProfiles([data]);
    } catch (e) {
      rethrow;
    } finally {
      EasyLoading.dismiss();
    }
  }
}

class PersonalInfoItem extends StatelessWidget {
  const PersonalInfoItem(
      {required this.title, this.trailing, this.imageWidget, this.enableArrow = false, this.onTap, super.key});

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
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              fontSize: theme.font.titleMedium.fontSize,
              fontWeight: theme.font.titleMedium.fontWeight,
              color: theme.color.isDark ? theme.color.neutralColor100 : theme.color.neutralColor1,
            ),
          ),
          Expanded(
            child: Text(
              trailing ?? '',
              textScaler: TextScaler.noScaling,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: theme.font.labelLarge.fontSize,
                fontWeight: theme.font.labelLarge.fontWeight,
                color: theme.color.isDark ? theme.color.neutralColor7 : theme.color.neutralColor5,
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

    content = Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: content);

    content = Column(
      children: [
        content,
        Divider(
          height: 0.5,
          indent: 16,
          color: theme.color.isDark ? theme.color.neutralColor2 : theme.color.neutralColor9,
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
