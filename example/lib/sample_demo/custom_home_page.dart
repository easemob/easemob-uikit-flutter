import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/demo/home_page.dart';
import 'package:em_chat_uikit_example/sample_demo/contact/contact_depth_custom_page.dart';
import 'package:em_chat_uikit_example/sample_demo/contact/contact_page_custom1.dart';
import 'package:em_chat_uikit_example/sample_demo/conversation/merge_conversation_page.dart';
import 'package:em_chat_uikit_example/sample_demo/group/group_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../demo/pages/contact/contact_page.dart';
import '../demo/pages/conversation/conversation_page.dart';

class CustomHomePage extends StatefulWidget {
  const CustomHomePage({super.key});

  @override
  State<CustomHomePage> createState() => _CustomHomePageState();
}

class _CustomHomePageState extends State<CustomHomePage> {
  @override
  void initState() {
    super.initState();
  }

  bool isLightTheme = true;
  List<String> fontSizeList = ['0', '1', '2', '3'];
  String fontSize = '1';
  ChatUIKitFontSize size = ChatUIKitFontSize.normal;
  @override
  Widget build(BuildContext context) {
    Widget content = Scaffold(
      appBar: AppBar(
        title: const Text('Sample Demo'),
      ),
      body: ListView(
        children: [
          itemWidget(
            name: '默认会话列表(Default Conversation list)',
            title: 'ConversationPage',
            widget: ChatUIKitTheme(
              font: ChatUIKitFont.fontSize(fontSize: size),
              color:
                  isLightTheme ? ChatUIKitColor.light() : ChatUIKitColor.dark(),
              child: const ConversationPage(),
            ),
          ),
          itemWidget(
            name: '合并会话列表(Merge Conversation list)',
            title: 'MergeConversationPage',
            widget: ChatUIKitTheme(
              font: ChatUIKitFont.fontSize(fontSize: size),
              color:
                  isLightTheme ? ChatUIKitColor.light() : ChatUIKitColor.dark(),
              child: const MergeConversationPage(),
            ),
          ),
          itemWidget(
            name: '默认通讯录列表(Default Contact list)',
            title: 'ContactPage',
            widget: ChatUIKitTheme(
              font: ChatUIKitFont.fontSize(fontSize: size),
              color:
                  isLightTheme ? ChatUIKitColor.light() : ChatUIKitColor.dark(),
              child: const ContactPage(),
            ),
          ),
          itemWidget(
            name: '通讯录和群列表(Contact list and group list)',
            title: 'ContactAndGroupPage',
            widget: ChatUIKitTheme(
              font: ChatUIKitFont.fontSize(fontSize: size),
              color:
                  isLightTheme ? ChatUIKitColor.light() : ChatUIKitColor.dark(),
              child: const ContactAndGroupPage(),
            ),
          ),
          itemWidget(
            name: '通讯录自定义AppBar(custom contacts app bar)',
            title: 'CustomContactAppBarPage',
            widget: ChatUIKitTheme(
              font: ChatUIKitFont.fontSize(fontSize: size),
              color:
                  isLightTheme ? ChatUIKitColor.light() : ChatUIKitColor.dark(),
              child: const CustomContactAppBarPage(),
            ),
          ),
          itemWidget(
            name: '通讯录深度自定义(depth custom contacts)',
            title: 'ContactDepthCustomPage',
            widget: ChatUIKitTheme(
              font: ChatUIKitFont.fontSize(fontSize: size),
              color:
                  isLightTheme ? ChatUIKitColor.light() : ChatUIKitColor.dark(),
              child: const ContactDepthCustomPage(),
            ),
          ),
          itemWidget(
            name: '默认群组列表(Default group list)',
            title: 'Groups View',
            widget: ChatUIKitTheme(
                font: ChatUIKitFont.fontSize(fontSize: size),
                color: isLightTheme
                    ? ChatUIKitColor.light()
                    : ChatUIKitColor.dark(),
                child: const GroupPage()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '修改主题颜色(Switch theme color): ${(isLightTheme ? 'Light' : 'Dark')}',
              ),
              CupertinoSwitch(
                value: isLightTheme,
                onChanged: (value) {
                  isLightTheme = value;
                  setState(() {});
                },
              ),
            ],
          ),
          fontSizeSettingsWidget(),
          itemWidget(
            name: '演示Demo',
            title: 'Demo',
            widget: ChatUIKitTheme(
              font: ChatUIKitFont.fontSize(fontSize: size),
              color:
                  isLightTheme ? ChatUIKitColor.light() : ChatUIKitColor.dark(),
              child: const HomePage(),
            ),
          ),
        ],
      ),
    );

    return content;
  }

  Widget itemWidget({
    required String name,
    required String title,
    required Widget widget,
  }) {
    return Column(
      children: [
        Text(name),
        Container(
          color: Colors.grey,
          height: 44,
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return Scaffold(
                    appBar: AppBar(title: Text(title)), body: widget);
              }),
            ),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget fontSizeSettingsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('修改字号(Switch font size) ${() {
          switch (size) {
            case ChatUIKitFontSize.small:
              return 'small';
            case ChatUIKitFontSize.normal:
              return 'normal';
            case ChatUIKitFontSize.large:
              return 'large';
            case ChatUIKitFontSize.superLarge:
              return 'superLarge';
          }
        }()}'),
        SizedBox(
          width: 150,
          child: Slider(
            value: double.parse(fontSize).toInt().toDouble(),
            min: 0,
            max: 3,
            // 设置分割数量
            divisions: 3,
            // 设置标签
            label: () {
              ChatUIKitFontSize size =
                  ChatUIKitFontSize.values[double.parse(fontSize).toInt()];
              switch (size) {
                case ChatUIKitFontSize.small:
                  return 'small';
                case ChatUIKitFontSize.normal:
                  return 'normal';
                case ChatUIKitFontSize.large:
                  return 'large';
                case ChatUIKitFontSize.superLarge:
                  return 'superLarge';
              }
            }(),
            onChanged: (value) {
              fontSize = value.toString();
              size = ChatUIKitFontSize.values[double.parse(fontSize).toInt()];
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
