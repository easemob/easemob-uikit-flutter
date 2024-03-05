import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/notifications/app_settings_notification.dart';
import 'package:em_chat_uikit_example/tool/user_data_store.dart';
import 'package:em_chat_uikit_example/widgets/list_item.dart';
import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String? currentLanguage;
  @override
  void initState() {
    super.initState();
    currentLanguage = ChatUIKitLocalizations().currentLocale?.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = ListView(
      children: [
        InkWell(
          onTap: () {
            currentLanguage = 'zh';
            UserDataStore().languageChange(language: currentLanguage!);
            ChatUIKitLocalizations().translate(currentLanguage!);
            AppSettingsNotification().dispatch(context);
            setState(() {});
          },
          child: ListItem(
            title: '中文',
            trailingWidget: currentLanguage == 'zh'
                ? Icon(
                    Icons.check_box,
                    size: 28,
                    color: theme.color.isDark
                        ? theme.color.primaryColor6
                        : theme.color.primaryColor5,
                  )
                : Icon(
                    Icons.check_box_outline_blank,
                    size: 28,
                    color: theme.color.isDark
                        ? theme.color.neutralColor4
                        : theme.color.neutralColor7,
                  ),
          ),
        ),
        InkWell(
          onTap: () {
            currentLanguage = 'en';
            UserDataStore().languageChange(language: currentLanguage!);
            ChatUIKitLocalizations().translate(currentLanguage!);
            AppSettingsNotification().dispatch(context);
            setState(() {});
          },
          child: ListItem(
            title: 'English',
            trailingWidget: currentLanguage == 'en'
                ? Icon(
                    Icons.check_box,
                    size: 28,
                    color: theme.color.isDark
                        ? theme.color.primaryColor6
                        : theme.color.primaryColor5,
                  )
                : Icon(
                    Icons.check_box_outline_blank,
                    size: 28,
                    color: theme.color.isDark
                        ? theme.color.neutralColor4
                        : theme.color.neutralColor7,
                  ),
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
        title: '将文字翻译为',
        centerTitle: false,
      ),
      body: content,
    );

    return content;
  }
}
