import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage>
    with ChatUIKitThemeMixin, MessageObserver {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    return ConversationsView(
      itemBuilder: (context, model) {
        if (model.lastMessage?.isAlertCustomMessage == true) {
          return ChatUIKitConversationListViewItem(
            model,
            subTitleLabel:
                model.lastMessage?.customBodyParams?['alert'] ?? '默认提醒消息内容',
          );
        }
        return null;
      },
    );
  }
}
