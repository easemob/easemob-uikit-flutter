import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/demo/demo_localizations.dart';
import 'package:em_chat_uikit_example/demo/notifications/app_settings_notification.dart';
import 'package:em_chat_uikit_example/demo/tool/settings_data_store.dart';

import 'package:em_chat_uikit_example/demo/widgets/list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneralPage extends StatefulWidget {
  const GeneralPage({super.key});

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = ListView(
      children: [
        ListItem(
          title: DemoLocalizations.darkMode.localString(context),
          trailingWidget: CupertinoSwitch(
              value: !AppSettingsNotification.isLight,
              onChanged: (value) {
                AppSettingsNotification.isLight =
                    !AppSettingsNotification.isLight;
                AppSettingsNotification().dispatch(context);
                setState(() {});
              }),
        ),
        ListItem(
          title: DemoLocalizations.advancedSettings.localString(context),
          enableArrow: true,
          onTap: () {
            Navigator.of(context).pushNamed('/advanced_page').then((value) {
              setState(() {});
            });
          },
        ),
        ListItem(
          title: DemoLocalizations.languageSettings.localString(context),
          trailingString:
              SettingsDataStore().currentLanguage == 'zh' ? '中文' : 'English',
          trailingStyle: TextStyle(
            fontSize: theme.font.labelMedium.fontSize,
            fontWeight: theme.font.labelMedium.fontWeight,
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor5,
          ),
          enableArrow: true,
          onTap: () {
            Navigator.of(context).pushNamed('/language_page').then((value) {
              setState(() {});
            });
          },
        ),
        ListItem(
          title: DemoLocalizations.translateTargetLanguage.localString(context),
          trailingString:
              SettingsDataStore().translateTargetLanguage == 'zh-Hans'
                  ? DemoLocalizations.translateTargetLanguageChinese
                      .localString(context)
                  : DemoLocalizations.translateTargetLanguageEnglish
                      .localString(context),
          trailingStyle: TextStyle(
            fontSize: theme.font.labelMedium.fontSize,
            fontWeight: theme.font.labelMedium.fontWeight,
            color: theme.color.isDark
                ? theme.color.neutralColor7
                : theme.color.neutralColor5,
          ),
          enableArrow: true,
          onTap: () {
            Navigator.of(context).pushNamed('/translate_page').then((value) {
              setState(() {});
            });
          },
        ),
      ],
    );

    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        title: DemoLocalizations.general.localString(context),
        centerTitle: false,
      ),
      body: SafeArea(child: content),
    );

    return content;
  }
}
