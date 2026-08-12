## 2.3.2
- Upgrade: Dependency SDK to 4.19.3.
- Fix: Import conflict of same-named types such as `MessageType` when integrated in the same project as `im_flutter_sdk`.
- Docs: Update the Android minimum version note in the README to minSDKVersion 24.
- Refactor: Use neutral native plugin names to support cross-repository sync.

## 2.3.1
- Fix: The input text selection background does not follow the light/dark theme.
- Fix: The voice message bubble style cannot be changed.
- Fix: The search icon on the contact details page is not displayed correctly.
- Feature: The text input hint can now be configured.
- Remove: Android permission MANAGE_EXTERNAL_STORAGE.
- Update: Some UIKit dependency components.
- Fix: Using a deprecated parameter when calling the SDK method joinChatRoom.

## 2.3.0
- Upgrade: Dependency SDK to 4.15.2.
- Merge the chatroom uikit and fully localize it.
- Fix: Blurry thumbnail display.
- Fix: Setting an empty conversation does not take effect.
- Fix: @ message does not work properly.
- Fix: Read ack is not sent when `itemBuilder` is null in a custom `MessagesView`.
- Fix: The emoji panel is not fully covered after the keyboard pops up.
- Fix: Some plugin dependency issues.

## 2.2.0

- Upgrade: Dependency SDK to 4.13.0.
- Upgrade third-party libraries.
- Change the message recall callback.
- Change the default group avatar setting.
- Fix: Messages are not marked when a conversation receipt is received.
- Fix: The message list background cannot be clicked.

## 2.1.0+5

- Upgrade: Dependency imsdk to 4.10.0.
- Fix: Inaccurate do-not-disturb status.

## 2.1.0+4

- Add recording format configuration.

## 2.1.0+3

- Fix: The message sending callback occasionally does not execute.

## 2.1.0+2

- Improve the message long-press menu display.
- Change `ChatUIKitSetting.messageLongPressType` to `ChatUIKitSetting.messageLongPressMenuStyle`.
- Change `ChatUIKitSetting.messageMoreActionType` to `ChatUIKitSetting.messageAttachmentMenuStyle`.
- Change `ChatUIKitMessageLongPressType` to `ChatUIKitMessageLongPressMenuStyle`.
- Change `ChatUIKitMessageMoreActionType` to `ChatUIKitMessageAttachmentMenuStyle`.

## 2.1.0+1

- Fix: The example cannot run on Android.
- Change Android minSDKVersion to 24.

## 2.1.0

- Change the custom list item name.
- Change the theme switching method.
- Change the `im_flutter_sdk` dependency version to `4.8.2`.
- Change `ChatUIKitBottomSheetItem` to `ChatUIKitEventAction`.
- Change the Flutter dependency version to `flutter: '>=3.19.0'`.

## 2.0.3

- Improve the conversation list display logic.
- Improve message loading.

## 2.0.2

- Add the blocklist component blockListView.
- Change the custom content implementation on the contact details and group details pages.
- Remove the message long-press listItem callback; use `onItemLongPressHandler` uniformly to modify and add message long-press events.

## 2.0.1

### fix

- Add a placeholder image for when a message image expires or fails to download.

## 2.0.0

#### New features

- Add ChangeInfoView;
- Add ContactDetailsView;
- Add ContactsView;
- Add CreateGroupView;
- Add CurrentUserInfoView;
- Add ForwardMessageSelectView;
- Add ForwardMessagesView;
- Add GroupAddMembersView;
- Add GroupChangeOwnerView;
- Add GroupDeleteMembersView;
- Add GroupDetailsView;
- Add GroupMembersView;
- Add GroupMentionView;
- Add GroupsView;
- Add NewRequestDetailsView
- Add NewRequestsView;
- Add ReportMessageView;
- Add SearchGroupMembersView;
- Add SearchHistoryView;
- Add SearchView;
- Add SelectContactView;
- Add ShowImageView;
- Add ShowVideoView;
- Add ThreadMembersView;
- Add ThreadMessagesView;
- Add ThreadsView;
- Add ChatUIKitRoute;
- Add ChatUIKitSettings;
- Add ChatUIKitLocal;
- Add EmojiData;

#### Improvements

- Change `ChatConversationsView` to `ConversationsView`;
- Change `ChatMessagesView` to `MessagesView`;

## 1.0.0

- Add ChatConversationsView;
- Add ChatMessagesView;
