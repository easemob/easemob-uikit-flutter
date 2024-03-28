import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/demo_localizations.dart';
import 'package:em_chat_uikit_example/tool/settings_data_store.dart';
import 'package:em_chat_uikit_example/widgets/list_item.dart';
import 'package:flutter/material.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  ValueNotifier<int> themeIndex =
      ValueNotifier<int>(SettingsDataStore().currentThemeIndex);
  @override
  void initState() {
    super.initState();
    themeIndex.addListener(() async {
      await SettingsDataStore().saveTheme(themeIndex.value);
      debugPrint('themeIndex: ${SettingsDataStore().currentThemeIndex}');
    });
  }

  @override
  void dispose() {
    themeIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = ValueListenableBuilder(
      valueListenable: themeIndex,
      builder: (context, value, child) {
        return ListView(
          children: [
            InkWell(
              onTap: () {
                themeIndex.value = 0;
              },
              child: ListItem(
                title: DemoLocalizations.switchThemeClassic.getString(context),
                trailingWidget: themeIndex.value == 0
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
                themeIndex.value = 1;
              },
              child: ListItem(
                title: DemoLocalizations.switchThemeSmart.getString(context),
                trailingWidget: themeIndex.value == 1
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
      },
    );

    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: ChatUIKitAppBar(
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        title: DemoLocalizations.switchTheme.getString(context),
        centerTitle: false,
      ),
      body: SafeArea(child: content),
    );

    return content;
  }
}
