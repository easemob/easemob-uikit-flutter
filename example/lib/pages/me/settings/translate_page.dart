import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/widgets/list_item.dart';
import 'package:flutter/material.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  String? translate;

  @override
  void initState() {
    super.initState();
    translate = ChatUIKitSettings.translateLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    Widget content = ListView(
      children: [
        InkWell(
          onTap: () {
            translate = 'zh-Hans';
            ChatUIKitSettings.translateLanguage = 'zh-Hans';
            setState(() {});
          },
          child: ListItem(
            title: '简体中文',
            trailingWidget: translate == 'zh-Hans'
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
            translate = 'en';
            ChatUIKitSettings.translateLanguage = 'en';
            setState(() {});
          },
          child: ListItem(
            title: 'English',
            trailingWidget: translate == 'en'
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
