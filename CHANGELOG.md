## 2.2.0

- 升级 依赖sdk为 4.13.0
- 升级 第三方库；
- 修改 撤回消息回调；
- 修改 群默认头像设置；
- 修复 收到会话回执没有标记消息的问题；
- 修复 消息列表背景无法点击；


## 2.1.0+5

- 升级依赖 imsdk 为 4.10.0
- 修复 免打扰状态不准；

## 2.1.0+4

- 增加录音格式配置。

## 2.1.0+3

- 修复发消息回调偶尔不执行的问题；

## 2.1.0+2

- 优化消息长按菜单显示;
- 修改 `ChatUIKitSetting.messageLongPressType` 为 `ChatUIKitSetting.messageLongPressMenuStyle`;
- 修改 `ChatUIKitSetting.messageMoreActionType` 为 `ChatUIKitSetting.messageAttachmentMenuStyle`;
- 修改 `ChatUIKitMessageLongPressType` 为 `ChatUIKitMessageLongPressMenuStyle`;
- 修改 `ChatUIKitMessageMoreActionType` 为 `ChatUIKitMessageAttachmentMenuStyle`;

## 2.1.0+1

- 修复 安卓环境下 example 无法运行；
- 修改 安卓 minSDKVersion 为 24；

## 2.1.0

- 修改列表自定义项名称；
- 修改主题切换方式；
- 依赖 `im_flutter_sdk` 版本改为 `4.8.2`;
- 修改 `ChatUIKitBottomSheetItem` 为 `ChatUIKitEventAction`;
- 修改依赖flutter版本为 `flutter: '>=3.19.0'`;

## 2.0.3

- 优化会话列表展示逻辑；
- 优化消息加载；

## 2.0.2

- 添加黑名单列表组件 blockListView;
- 修改联系人详情，群组详情页自定义内容实现；
- 移除消息中长按listItem的回调，统一使用 `onItemLongPressHandler` 修改和添加消息长按事件；

## 2.0.1

### fix

- 添加消息图片过期或者下载失败时的占位图

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