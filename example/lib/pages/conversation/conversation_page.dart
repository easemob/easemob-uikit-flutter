import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({super.key});
  @override
  Widget build(BuildContext context) {
    debugPrint('ConversationPage build');
    return const ConversationsView();
  }
}
