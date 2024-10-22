import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage>
    with ChatUIKitThemeMixin {
  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    return Container(
      color: Colors.red,
      child: ConversationsView(
        itemBuilder: (context, model) {
          return ChatUIKitConversationListViewItem(model);
        },
      ),
    );
  }
}
