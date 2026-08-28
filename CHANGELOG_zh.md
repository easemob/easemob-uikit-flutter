## 2.3.3
- 升级 依赖 SDK 为 4.22.0；
- 升级 example 的 Android 构建工具链以适配 Flutter 3.47（Gradle 9.3.1 / AGP 9.1.0 / KGP 2.4.0），仅示例工程构建配置。

## 2.3.2
- 升级 依赖sdk为 4.19.3；
- 修复 与 `im_flutter_sdk` 同项目集成时 `MessageType` 等同名类型产生导入冲突的问题；
- 更新 README 中 Android 最低版本说明为 minSDKVersion 24；
- 重构 原生插件使用中性命名，以支持跨仓库同步。

## 2.3.1
- 修复 输入框文字选择背景不随明暗主题变化的问题；
- 修复 语音消息气泡风格无法修改的问题；
- 修复 联系人详情页面搜索图标无法正常显示的问题；
- 支持 文本输入框提示内容可设置；
- 移除 Android权限MANAGE_EXTERNAL_STORAGE；
- 更新 uikit部分依赖组件；
- 修复 调用sdk方法joinChatRoom时使用过期参数的问题；

## 2.3.0
- 升级 依赖sdk为 4.15.2
- 合并 chatroom uikit并完整本地化；
- 修复 缩略图显示模糊问题;
- 修复 设置空会话没有生效的问题;
- 修复 @消息无法正常工作的问题;
- 修复 自定义 `MessagesView` 中 `itemBuilder` null时,不会发已读ack的问题;
- 修复 弹出键盘后emoji面板没有完全遮挡的问题;
- 修复 部分插件依赖问题;

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

#### 新功能

- 新增 ChangeInfoView;
- 新增 ContactDetailsView;
- 新增 ContactsView;
- 新增 CreateGroupView;
- 新增 CurrentUserInfoView;
- 新增 ForwardMessageSelectView;
- 新增 ForwardMessagesView;
- 新增 GroupAddMembersView;
- 新增 GroupChangeOwnerView;
- 新增 GroupDeleteMembersView;
- 新增 GroupDetailsView;
- 新增 GroupMembersView;
- 新增 GroupMentionView;
- 新增 GroupsView;
- 新增 NewRequestDetailsView;
- 新增 NewRequestsView;
- 新增 ReportMessageView;
- 新增 SearchGroupMembersView;
- 新增 SearchHistoryView;
- 新增 SearchView;
- 新增 SelectContactView;
- 新增 ShowImageView;
- 新增 ShowVideoView;
- 新增 ThreadMembersView;
- 新增 ThreadMessagesView;
- 新增 ThreadsView;
- 新增 ChatUIKitRoute;
- 新增 ChatUIKitSettings;
- 新增 ChatUIKitLocal;
- 新增 EmojiData;

#### 优化

- `ChatConversationsView` 更名为 `ConversationsView`;
- `ChatMessagesView` 更名为 `MessagesView`;

## 1.0.0

- 新增 ChatConversationsView;
- 新增 ChatMessagesView;
