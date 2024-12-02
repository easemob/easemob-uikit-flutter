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
            final msg = Message.createCustomSendMessage(
              targetId: profile.id,
              event: 'custom_event',
              chatType: profile.type == ChatUIKitProfileType.group
                  ? ChatType.GroupChat
                  : ChatType.Chat,
            );
            messagesViewController.sendMessage(msg);
          },
          child: const Text('Send Message'),
        ),
        Expanded(
          child: MessagesView(
            profile: profile,
            controller: messagesViewController,
            bubbleBuilder: (context, child, model) {
              if (model.message.body is CustomMessageBody) {
                CustomMessageBody customMessageBody =
                    model.message.body as CustomMessageBody;
                if (customMessageBody.event == 'custom_event') {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('我是自定义消息'),
                  );
                }
              }
              return null;
            },
          ),
        )
      ],
    );
  }
}
