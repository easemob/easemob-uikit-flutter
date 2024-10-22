import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class InputBarPage extends StatefulWidget {
  const InputBarPage({super.key});

  @override
  State<InputBarPage> createState() => _InputBarPageState();
}

class _InputBarPageState extends State<InputBarPage> with ChatUIKitThemeMixin {
  ChatUIKitPopupMenuController popupMenuController =
      ChatUIKitPopupMenuController();
  ChatUIKitKeyboardPanelType currentPanelType = ChatUIKitKeyboardPanelType.none;
  late ChatUIKitKeyboardPanelController keyboardPanelController;
  @override
  void initState() {
    super.initState();
    keyboardPanelController = ChatUIKitKeyboardPanelController(
        inputTextEditingController: CustomTextEditingController());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = ListView(
      reverse: true,
      children: List.generate(
        20,
        (index) => Container(
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.color.isDark
                ? theme.color.neutralColor5
                : theme.color.neutralColor3,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Message $index',
            style: TextStyle(
              color: theme.color.isDark
                  ? theme.color.neutralColor98
                  : theme.color.neutralColor0,
            ),
          ),
        ),
      ),
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
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        appBar: AppBar(
          title: Text('Custom Input Bar',
              style: TextStyle(
                fontSize: theme.font.titleLarge.fontSize,
                fontWeight: theme.font.titleLarge.fontWeight,
                color: theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor0,
              )),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor0),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: theme.color.isDark
              ? theme.color.neutralColor1
              : theme.color.neutralColor98,
          actions: [
            IconButton(
              icon: Icon(Icons.switch_access_shortcut,
                  color: theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor0),
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
                maintainBottomViewPadding: true,
                onPanelChanged: (panelType) {
                  currentPanelType = panelType;
                },
                keyboardPanelController: keyboardPanelController,
                bottomPanels: [
                  inputPanel(),
                  voicePanel(),
                  emojiPanel(),
                  morePanel(),
                ],
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
            ],
          ),
        ));
  }

  ChatUIKitBottomPanelData inputPanel() {
    return const ChatUIKitBottomPanelData(
      height: 0,
      panelType: ChatUIKitKeyboardPanelType.keyboard,
    );
  }

  ChatUIKitBottomPanelData voicePanel() {
    return ChatUIKitBottomPanelData(
      height: 200,
      panelType: ChatUIKitKeyboardPanelType.voice,
      child: RecordBar(
        onRecordFinished: (data) {
          debugPrint('Record Finished: $data');
        },
      ),
    );
  }

  ChatUIKitBottomPanelData emojiPanel() {
    return ChatUIKitBottomPanelData(
        height: 230,
        panelType: ChatUIKitKeyboardPanelType.emoji,
        showCursor: true,
        child: ChatUIKitEmojiPanel(
          deleteOnTap: () {
            if (keyboardPanelController.inputTextEditingController
                is CustomTextEditingController) {
              CustomTextEditingController controller = keyboardPanelController
                  .inputTextEditingController as CustomTextEditingController;
              controller.deleteTextOnCursor();
            }
          },
          emojiClicked: (emoji) {
            if (keyboardPanelController.inputTextEditingController
                is CustomTextEditingController) {
              CustomTextEditingController controller = keyboardPanelController
                  .inputTextEditingController as CustomTextEditingController;
              controller.addText(
                ChatUIKitEmojiData.emojiMap[emoji] ?? emoji,
              );
            }
          },
        ));
  }

  ChatUIKitBottomPanelData morePanel() {
    List<ChatUIKitEventAction> items = [];

    items.add(ChatUIKitEventAction.normal(
      actionType: ChatUIKitActionType.photos,
      label:
          ChatUIKitLocal.messagesViewMoreActionsTitleAlbum.localString(context),
      icon: ChatUIKitImageLoader.messageViewMoreAlbum(
        color: theme.color.isDark
            ? theme.color.primaryColor6
            : theme.color.primaryColor5,
      ),
      onTap: () async {},
    ));
    items.add(ChatUIKitEventAction.normal(
      actionType: ChatUIKitActionType.video,
      label:
          ChatUIKitLocal.messagesViewMoreActionsTitleVideo.localString(context),
      icon: ChatUIKitImageLoader.messageViewMoreVideo(
        color: theme.color.isDark
            ? theme.color.primaryColor6
            : theme.color.primaryColor5,
      ),
      onTap: () async {},
    ));
    items.add(ChatUIKitEventAction.normal(
      actionType: ChatUIKitActionType.camera,
      label: ChatUIKitLocal.messagesViewMoreActionsTitleCamera
          .localString(context),
      icon: ChatUIKitImageLoader.messageViewMoreCamera(
        color: theme.color.isDark
            ? theme.color.primaryColor6
            : theme.color.primaryColor5,
      ),
      onTap: () async {},
    ));
    items.add(ChatUIKitEventAction.normal(
      actionType: ChatUIKitActionType.file,
      label:
          ChatUIKitLocal.messagesViewMoreActionsTitleFile.localString(context),
      icon: ChatUIKitImageLoader.messageViewMoreFile(
        color: theme.color.isDark
            ? theme.color.primaryColor6
            : theme.color.primaryColor5,
      ),
      onTap: () async {},
    ));
    items.add(ChatUIKitEventAction.normal(
      actionType: ChatUIKitActionType.contactCard,
      label: ChatUIKitLocal.messagesViewMoreActionsTitleContact
          .localString(context),
      icon: ChatUIKitImageLoader.messageViewMoreCard(
        color: theme.color.isDark
            ? theme.color.primaryColor6
            : theme.color.primaryColor5,
      ),
      onTap: () async {},
    ));

    return ChatUIKitBottomPanelData(
      height: 254,
      panelType: ChatUIKitKeyboardPanelType.more,
      child: ChatUIKitMessageViewBottomMenu(
        eventActionsHandler: () => items,
      ),
    );
  }
}
