import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/home_page.dart';
import 'package:em_chat_uikit_example/login_page.dart';
import 'package:em_chat_uikit_example/notifications/app_settings_notification.dart';
import 'package:em_chat_uikit_example/pages/me/personal/change_avatar_page.dart';
import 'package:em_chat_uikit_example/pages/me/personal/personal_info_page.dart';
import 'package:em_chat_uikit_example/pages/me/settings/general_page.dart';
import 'package:em_chat_uikit_example/pages/me/settings/language_page.dart';
import 'package:em_chat_uikit_example/pages/me/settings/translate_page.dart';
import 'package:em_chat_uikit_example/tool/chat_route_filter.dart';
import 'package:em_chat_uikit_example/tool/user_data_store.dart';
import 'package:em_chat_uikit_example/welcome_page.dart';

import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

const appKey = 'easemob#easeim';

void main() async {
  await UserDataStore().init();
  await ChatUIKit.instance.init(
    options: Options(
      appKey: appKey,
      deleteMessagesAsExitGroup: false,
    ),
  );
  return runApp(const MyApp());
  // return SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //     .then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ChatUIKitLocalizations _localization = ChatUIKitLocalizations();

  @override
  void initState() {
    super.initState();
    _localization.translate(UserDataStore().getLanguage());
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is AppSettingsNotification) {
          setState(() {});
        }
        return false;
      },
      child: MaterialApp(
        supportedLocales: _localization.supportedLocales,
        localizationsDelegates: _localization.localizationsDelegates,
        localeResolutionCallback: _localization.localeResolutionCallback,
        locale: ChatUIKitLocalizations().currentLocale,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        builder: EasyLoading.init(
          builder: (context, child) {
            return ChatUIKitTheme(
              color: AppSettingsNotification.isLight
                  ? ChatUIKitColor.light()
                  : ChatUIKitColor.dark(),
              child: child!,
            );
          },
        ),
        home: const WelcomePage(),
        onGenerateRoute: (settings) {
          RouteSettings newSettings =
              ChatRouteFilter.chatRouteSettings(settings);
          return ChatUIKitRoute().generateRoute(newSettings) ??
              MaterialPageRoute(
                builder: (context) {
                  if (settings.name == '/home') {
                    return const HomePage();
                  } else if (settings.name == '/login') {
                    return const LoginPage();
                  } else if (settings.name == '/personal_info') {
                    return const PersonalInfoPage();
                  } else if (settings.name == '/change_avatar') {
                    return const ChangeAvatarPage();
                  } else if (settings.name == '/general_page') {
                    return const GeneralPage();
                  } else if (settings.name == '/language_page') {
                    return const LanguagePage();
                  } else if (settings.name == '/translate_page') {
                    return const TranslatePage();
                  } else {
                    return const WelcomePage();
                  }
                },
              );
        },
      ),
    );
  }
}
