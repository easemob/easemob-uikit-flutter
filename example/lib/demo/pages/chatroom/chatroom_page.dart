import 'dart:convert';

import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage(this.room, {super.key});

  final ChatRoom room;
  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> with ChatUIKitThemeMixin {
  ChatRoomInputBarController inputBarController = ChatRoomInputBarController();

  // 发送礼物列表 使用
  List<ChatroomGiftPageController> controllers = [];
  String get roomId => widget.room.roomId;
  bool isOwner = false;
  @override
  void initState() {
    super.initState();
    analysisGiftList();
    setup();
    isOwner = widget.room.owner == ChatUIKit.instance.currentUserId;
  }

  void setup() async {
    // 先获取自己的信息，之后再加入聊天室
    await setupMyInfo();
    joinChatRoom();
  }

  // 加入聊天室
  void joinChatRoom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChatRoomUIKit.instance.joinChatRoom(roomId: roomId).then((_) {
        debugPrint('join chat room');
      }).catchError((e) {
        debugPrint('join chat room error: $e');
      });
    });
  }

  // 解析礼物列表
  Future<void> analysisGiftList() async {
    String giftJson = await rootBundle.loadString('assets/Gifts.json');
    Map<String, dynamic> map = json.decode(giftJson);
    for (var element in map.keys.toList()) {
      final controller = ChatroomGiftPageController(
        title: element,
        gifts: () {
          List<ChatRoomGift> list = [];
          map[element].forEach((element) {
            ChatRoomGift gift = ChatRoomGift.fromJson(element);
            list.add(gift);
          });
          return list;
        }(),
      );
      controllers.add(controller);
    }
  }

  // 设置自己在聊天室中的信息
  Future<void> setupMyInfo() async {
    ChatUIKitProfile profile = ChatRoomUserInfo.createUserProfile(
      userId: ChatRoomUIKit.instance.currentUserId!,
      nickname: '在 ${widget.room.name ?? roomId} 中的昵称',
    );
    ChatUIKitProvider.instance.addProfiles([profile], roomId);
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              inputBarController.hiddenInputBar();
            },
            child: Image.asset(
              theme.color.isDark
                  ? 'assets/room/dark_bg.png'
                  : 'assets/room/light_bg.png',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).viewInsets.top + 10,
          left: 0,
          right: 0,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20, child: ChatRoomGlobalMessageView()),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          height: 84,
          bottom: 300,
          child: ChatRoomShowGiftView(roomId: roomId),
        ),
        Positioned(
          left: 16,
          right: 78,
          height: 204,
          bottom: 90,
          child: ChatRoomMessagesView(
            roomId: roomId,
            onTap: (context, msg) {
              debugPrint('onTap: $msg');
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 40,
          child: ChatRoomInputBar(
            bottomDistance: 40,
            controller: inputBarController,
            onSend: (msg) {
              if (msg.trim().isEmpty) {
                return;
              }
              ChatRoomUIKit.instance.sendMessage(
                message: ChatRoomMessage.roomMessage(roomId, msg),
              );
            },
            actions: [
              InkWell(
                onTap: () async {
                  ChatRoomGift? gift = await chatroomShowGiftsView(
                    context,
                    giftControllers: controllers,
                  );
                  if (gift != null) {
                    ChatRoomUIKit.instance.sendMessage(
                      message: ChatRoomMessage.giftMessage(roomId, gift),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Image.asset('assets/room/send_gift.png'),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    content = Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: ChatUIKitAppBar(
        backgroundColor: Colors.transparent,
        trailingActions: [
          ChatUIKitAppBarAction(
              child: IconButton(
            onPressed: () {
              chatroomShowMembersView(context,
                  roomId: roomId,
                  membersControllers: [
                    ChatRoomUIKitMembersController('聊天室成员'),
                    if (isOwner) ChatRoomUIKitMutesController('禁言列表')
                  ]);
            },
            icon: Icon(
              Icons.group,
              color: theme.color.isDark ? Colors.white38 : Colors.white70,
            ),
          )),
          ChatUIKitAppBarAction(
            child: Switch(
              thumbIcon: WidgetStatePropertyAll(
                Icon(
                  ChatUIKitTheme.instance.color.isDark
                      ? Icons.bedtime
                      : Icons.sunny,
                  color: Colors.white,
                ),
              ),
              trackOutlineColor:
                  const WidgetStatePropertyAll(Colors.transparent),
              activeTrackColor: theme.color.neutralColor4,
              inactiveThumbColor: Colors.blue,
              activeColor: Colors.blue,
              value: !ChatUIKitTheme.instance.color.isDark,
              onChanged: (value) {
                setState(() {
                  ChatUIKitTheme.instance.setColor(
                    value ? ChatUIKitColor.light() : ChatUIKitColor.dark(),
                  );
                });
              },
            ),
          )
        ],
      ),
      body: content,
    );

    content = PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        ChatRoomUIKit.instance.leaveChatRoom(roomId).then((_) {
          debugPrint('leave chat room');
        }).catchError((e) {
          debugPrint('leave chat room error: $e');
        });
      },
      child: content,
    );

    return content;
  }
}
