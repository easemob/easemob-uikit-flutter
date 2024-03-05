import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/notifications/app_settings_notification.dart';

import 'package:em_chat_uikit_example/widgets/list_item.dart';
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
          title: '显示输入状态',
          trailingWidget: CupertinoSwitch(
              value: ChatUIKitSettings.enableInputStatus,
              onChanged: (value) {
                ChatUIKitSettings.enableInputStatus =
                    !ChatUIKitSettings.enableInputStatus;
                setState(() {});
              }),
        ),
        Container(
          padding:
              const EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
          color: theme.color.isDark
              ? theme.color.neutralColor3
              : theme.color.neutralColor95,
          child: Text(
            '开启后，对方将看见你的输入状态',
            textAlign: TextAlign.right,
            // ignore: deprecated_member_use
            textScaleFactor: 1.0,
            style: TextStyle(
              height: 0.9,
              fontSize: theme.font.bodyMedium.fontSize,
              fontWeight: theme.font.bodyMedium.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor7
                  : theme.color.neutralColor5,
            ),
          ),
        ),
        ListItem(
          title: '暗黑模式',
          trailingWidget: CupertinoSwitch(
              value: !AppSettingsNotification.isLight,
              onChanged: (value) {
                AppSettingsNotification.isLight =
                    !AppSettingsNotification.isLight;
                AppSettingsNotification().dispatch(context);
                setState(() {});
              }),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/language_page').then((value) {
              setState(() {});
            });
          },
          child: ListItem(
            title: '语言设置',
            trailingString:
                ChatUIKitLocalizations().currentLocale?.languageCode == 'zh'
                    ? '中文'
                    : 'English',
            trailingStyle: TextStyle(
              fontSize: theme.font.labelMedium.fontSize,
              fontWeight: theme.font.labelMedium.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor7
                  : theme.color.neutralColor5,
            ),
            enableArrow: true,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/translate_page').then((value) {
              setState(() {});
            });
          },
          child: ListItem(
            title: '翻译目标语言',
            trailingString: ChatUIKitSettings.translateLanguage == 'zh-Hans'
                ? '简体中文'
                : 'English',
            trailingStyle: TextStyle(
              fontSize: theme.font.labelMedium.fontSize,
              fontWeight: theme.font.labelMedium.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor7
                  : theme.color.neutralColor5,
            ),
            enableArrow: true,
          ),
        ),
      ],
    );

    content = SafeArea(child: content);
    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        title: '通用',
        centerTitle: false,
      ),
      body: content,
    );

    return content;
  }
}
