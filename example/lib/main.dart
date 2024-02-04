import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/home_page.dart';
import 'package:em_chat_uikit_example/login_page.dart';
import 'package:em_chat_uikit_example/notifications/theme_notification.dart';
import 'package:em_chat_uikit_example/pages/me/personal/change_avatar_page.dart';
import 'package:em_chat_uikit_example/pages/me/personal/personal_info_page.dart';
import 'package:em_chat_uikit_example/pages/me/settings/general_page.dart';
import 'package:em_chat_uikit_example/tool/chat_route_filter.dart';
import 'package:em_chat_uikit_example/welcome_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

const appKey = 'easemob#easeim';

void main() async {
  await ChatUIKit.instance.init(
    options: Options(
      appKey: appKey,
      deleteMessagesAsExitGroup: false,
    ),
  );
  return SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ChatUIKitLocalizations _localization = ChatUIKitLocalizations();
  bool isLight = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: _localization.supportedLocales,
      localizationsDelegates: _localization.localizationsDelegates,
      localeResolutionCallback: _localization.localeResolutionCallback,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      builder: EasyLoading.init(
        builder: (context, child) {
          return NotificationListener(
            onNotification: (notification) {
              if (notification is ThemeNotification) {
                setState(() {});
              }
              return false;
            },
            child: ChatUIKitTheme(
              color: ThemeNotification.isLight
                  ? ChatUIKitColor.light()
                  : ChatUIKitColor.dark(),
              child: child!,
            ),
          );
        },
      ),
      home: const WelcomePage(),
      onGenerateRoute: (settings) {
        RouteSettings newSettings = ChatRouteFilter.chatRouteSettings(settings);
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
                } else {
                  return const WelcomePage();
                }
              },
            );
      },
    );
  }
}
