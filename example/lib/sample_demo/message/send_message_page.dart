import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class SendMessagePage extends StatefulWidget {
  const SendMessagePage({super.key});

  @override
  State<SendMessagePage> createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  late final MessagesViewController messagesViewController;
  late final ChatUIKitProfile profile;

  @override
  void initState() {
    super.initState();
    profile = ChatUIKitProfile.contact(id: 'du001');
    messagesViewController = MessagesViewController(profile: profile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            messagesViewController.sendTextMessage('asd');
          },
          child: const Text('Send Message'),
        ),
        Expanded(
          child: MessagesView(
            profile: profile,
            controller: messagesViewController,
          ),
        )
      ],
    );
  }
}
