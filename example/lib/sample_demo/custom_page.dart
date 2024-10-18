import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class InputBarPage extends StatefulWidget {
  const InputBarPage({super.key});

  @override
  State<InputBarPage> createState() => _InputBarPageState();
}

class _InputBarPageState extends State<InputBarPage> with ChatUIKitThemeMixin {
  final FocusNode _inputPanelFocusNode = FocusNode();
  late final ChatUIKitKeyboardPanelController keyboardPanelController;
  ChatUIKitKeyboardPanelType currentPanelType = ChatUIKitKeyboardPanelType.none;
  ChatUIKitPopupMenuController popupMenuController =
      ChatUIKitPopupMenuController();
  @override
  void initState() {
    super.initState();
    keyboardPanelController = ChatUIKitKeyboardPanelController(
      inputPanelFocusNode: _inputPanelFocusNode,
    );
  }

  @override
  void dispose() {
    popupMenuController.dispose();
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = ListView(
      reverse: true,
      children: () {
        List<Widget> ret = [];
        for (var i = 0; i < 100; i++) {
          ret.add(
            Align(
              alignment:
                  i % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.all(8),
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.color.isDark
                        ? theme.color.neutralColor5
                        : theme.color.neutralColor3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ChatUIKitPositionWidget(
                  onLongPressPositionHandler: (rect) {
                    popupMenuController.showMenu(
                      null,
                      rect,
                      [
                        ChatUIKitEventAction.normal(
                          label: 'Copy',
                          icon: const Icon(Icons.copy),
                          onTap: () {
                            debugPrint('Copy');
                          },
                        ),
                        ChatUIKitEventAction.normal(
                          label: 'Copy',
                          icon: const Icon(Icons.copy),
                          onTap: () {
                            debugPrint('Copy');
                          },
                        ),
                        ChatUIKitEventAction.normal(
                          label: 'Copy',
                          icon: const Icon(Icons.copy),
                          onTap: () {
                            debugPrint('Copy');
                          },
                        ),
                        ChatUIKitEventAction.normal(
                          label: 'Copy',
                          icon: const Icon(Icons.copy),
                          onTap: () {
                            debugPrint('Copy');
                          },
                        ),
                        ChatUIKitEventAction.normal(
                          label: 'Copy',
                          icon: const Icon(Icons.copy),
                          onTap: () {
                            debugPrint('Copy');
                          },
                        ),
                        ChatUIKitEventAction.normal(
                          label: 'Copy',
                          icon: const Icon(Icons.copy),
                          onTap: () {
                            debugPrint('Copy');
                          },
                        ),
                      ],
                    );
                    debugPrint('onLongPressPositionHandler: $rect');
                  },
                  child: Text(
                    'Item $i',
                    style: TextStyle(
                      color: theme.color.isDark
                          ? theme.color.neutralColor98
                          : theme.color.neutralColor1,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return ret;
      }(),
    );

    content = ChatUIKitPopupMenu(
      controller: popupMenuController,
      style: const ChatUIKitPopupMenuStyle(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      child: content,
    );

    content = GestureDetector(
      onTap: () {
        popupMenuController.hideMenu();
        keyboardPanelController.switchPanel(ChatUIKitKeyboardPanelType.none);
      },
      child: content,
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.switch_access_shortcut),
              onPressed: () {
                ChatUIKitTheme.instance.color.isDark
                    ? ChatUIKitTheme.instance.setColor(ChatUIKitColor.light())
                    : ChatUIKitTheme.instance.setColor(ChatUIKitColor.dark());
              },
            )
          ],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            children: [
              Expanded(child: content),
              ChatUIKitInputBar1(
                focusNode: _inputPanelFocusNode,
                leftItems: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () async {
                        ChatUIKitKeyboardPanelType panelType =
                            currentPanelType == ChatUIKitKeyboardPanelType.voice
                                ? ChatUIKitKeyboardPanelType.none
                                : ChatUIKitKeyboardPanelType.voice;
                        keyboardPanelController.switchPanel(panelType);
                      },
                      child: ChatUIKitImageLoader.voiceKeyboard(
                        color: theme.color.isDark
                            ? theme.color.neutralColor5
                            : theme.color.neutralColor3,
                      ),
                    ),
                  ),
                ],
                rightItems: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        keyboardPanelController.switchPanel(
                            currentPanelType == ChatUIKitKeyboardPanelType.emoji
                                ? ChatUIKitKeyboardPanelType.none
                                : ChatUIKitKeyboardPanelType.emoji);
                      },
                      child: ChatUIKitImageLoader.faceKeyboard(
                        color: theme.color.isDark
                            ? theme.color.neutralColor5
                            : theme.color.neutralColor3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        keyboardPanelController.switchPanel(
                            currentPanelType == ChatUIKitKeyboardPanelType.more
                                ? ChatUIKitKeyboardPanelType.none
                                : ChatUIKitKeyboardPanelType.more);
                      },
                      child: ChatUIKitImageLoader.moreKeyboard(
                        color: theme.color.isDark
                            ? theme.color.neutralColor5
                            : theme.color.neutralColor3,
                      ),
                    ),
                  ),
                ],
              ),
              _keyboardPanel(),
            ],
          ),
        ));
  }

  Widget _keyboardPanel() {
    return ChatUIKitKeyboardPanel(
      maintainBottomViewPadding: true,
      controller: keyboardPanelController,
      bottomPanels: <ChatUIKitBottomPanel>[
        inputPanel(),
        voicePanel(),
        emojiPanel(),
        morePanel(),
      ],
      onPanelChanged: (panelType) {
        currentPanelType = panelType;
        debugPrint('panelType: $panelType');
      },
    );
  }

  ChatUIKitBottomPanel inputPanel() {
    return const ChatUIKitBottomPanel(
      height: 0,
      panelType: ChatUIKitKeyboardPanelType.keyboard,
      child: SizedBox(width: double.infinity),
    );
  }

  ChatUIKitBottomPanel voicePanel() {
    return ChatUIKitBottomPanel(
      height: 200,
      panelType: ChatUIKitKeyboardPanelType.voice,
      child: RecordBar(
        onRecordFinished: (data) {
          debugPrint('Record Finished: $data');
        },
      ),
    );
  }

  ChatUIKitBottomPanel emojiPanel() {
    return ChatUIKitBottomPanel(
      height: 240,
      panelType: ChatUIKitKeyboardPanelType.emoji,
      child: Container(
        color: Colors.blue,
        child: const Center(
          child: Text('Emoji Panel'),
        ),
      ),
    );
  }

  ChatUIKitBottomPanel morePanel() {
    return ChatUIKitBottomPanel(
      height: 280,
      panelType: ChatUIKitKeyboardPanelType.more,
      child: Container(
        color: Colors.red,
        child: const Center(
          child: Text('More Panel'),
        ),
      ),
    );
  }
}
