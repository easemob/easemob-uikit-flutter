import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

mixin ChatUIKitLocal {
  static const String conversationsViewMenuAddContact =
      'new_chat_button_click_menu_add_contacts';
  static const String conversationsViewMenuCreateGroup =
      'new_chat_button_click_menu_create_group';
  static const String conversationsViewMenuCreateNewChat =
      'new_chat_button_click_menu_create_new_chat';
  static const String conversationsViewMenuSelectContacts =
      'new_chat_button_click_menu_select_contacts';
  static const String conversationsViewMenuCancel =
      'new_chat_button_click_menu_cancel';
  static const String conversationsViewSearchHint =
      'conversations_view_search_hint';

  static const String conversationListLongPressMenuDelete =
      'conversation_list_long_pressed_menu_delete';
  static const String conversationListLongPressMenuPin =
      'conversation_list_long_pressed_menu_pin';
  static const String conversationListLongPressMenuUnPin =
      'conversation_list_long_pressed_menu_unpin';
  static const String conversationListLongPressMenuMute =
      'conversation_list_long_pressed_menu_mute';
  static const String conversationListLongPressMenuUnmute =
      'conversation_list_long_pressed_menu_unmute';
  static const String conversationListLongPressMenuRead =
      'conversation_list_long_pressed_menu_read';
  static const String conversationListLongPressMenuCancel =
      'conversation_list_long_pressed_menu_cancel';

  static const String messageListLongPressMenuCopy =
      'message_list_long_pressed_menu_copy';
  static const String messageListLongPressMenuReply =
      'message_list_long_pressed_menu_reply';
  static const String messageListLongPressMenuEdit =
      'message_list_long_pressed_menu_edit';
  static const String messageListLongPressMenuDelete =
      'message_list_long_pressed_menu_delete';
  static const String messageListLongPressMenuRecall =
      'message_list_long_pressed_menu_recall';

  static const recordBarRecord = 'record_bar_record';
  static const recordBarRecording = 'record_bar_recording';
  static const recordBarPlay = 'record_bar_play';
  static const recordBarPlaying = 'record_bar_playing';
  static const recordBarAutoStop = 'record_bar_auto_stop';

  static const addContactTitle = 'add_contact_title';
  static const addContactSubTitle = 'add_contact_sub_title';
  static const addContactInputHints = 'add_contact_input_hints';
  static const addContactConfirm = 'add_contact_add';
  static const addContactCancel = 'add_contact_cancel';

  static const createGroupViewTitle = 'create_group_view_title';
  static const createGroupViewCreate = 'create_group_view_create';
  static const createGroupViewSearchContact =
      'create_group_view_search_contact';
  static const createGroupViewCancel = 'create_group_view_cancel';

  static const contactsViewNewRequests = 'contacts_view_new_request';
  static const contactsViewGroups = 'contacts_view_groups';
  static const contactsViewSearch = 'contacts_view_search';
  static const contactsAddContactAlertTitle =
      'contacts_add_contact_alert_title';
  static const contactsAddContactAlertSubTitle =
      'contacts_add_contact_alert_sub_title';
  static const contactsAddContactAlertHintText =
      'contacts_add_contact_alert_hint_text';
  static const contactsAddContactAlertButtonConfirm =
      'contacts_add_contact_alert_button_confirm';
  static const contactsAddContactAlertButtonCancel =
      'contacts_add_contact_alert_button_cancel';

  static const contactDetailViewSend = 'contact_detail_view_send';
  static const contactDetailViewRemark = 'contact_detail_view_remark';
  static const contactDetailViewPhone = 'contact_detail_view_phone';
  static const contactDetailViewDoNotDisturb =
      'contact_detail_view_do_not_disturb';
  static const contactDetailViewBlock = 'contact_detail_view_block';
  static const contactDetailViewClearChatHistory =
      'contact_detail_view_clear_chat_history';
  static const contactDetailViewClearChatHistoryAlertTitle =
      'contact_detail_view_clear_chat_history_alert_title';
  static const contactDetailViewClearChatHistoryAlertSubTitle =
      'contact_detail_view_clear_chat_history_alert_sub_title';
  static const contactDetailViewClearChatHistoryAlertButtonConfirm =
      'contact_detail_view_clear_chat_history_alert_button_confirm';
  static const contactDetailViewClearChatHistoryAlertButtonCancel =
      'contact_detail_view_clear_chat_history_alert_button_cancel';
  static const contactDetailViewDelete = 'contact_detail_view_delete';
  static const contactDetailViewCancel = 'contact_detail_view_cancel';
  static const contactDetailViewDeleteAlertTitle =
      'contact_detail_view_delete_alert_title';
  static const contactDetailViewDeleteAlertSubTitle =
      'contact_detail_view_delete_alert_sub_title';
  static const contactDetailViewDeleteAlertButtonConfirm =
      'contact_detail_view_delete_alert_button_confirm';
  static const contactDetailViewDeleteAlertButtonCancel =
      'contact_detail_view_delete_alert_button_cancel';

  static const groupDetailViewSend = 'group_detail_view_send';
  static const groupDetailViewDoNotDisturb = 'group_detail_view_do_not_disturb';
  static const groupDetailViewClearChatHistory =
      'group_detail_view_clear_chat_history';
  static const groupDetailViewClearChatHistoryAlertButtonConfirm =
      'group_detail_view_clear_chat_history_alert_button_confirm';
  static const groupDetailViewClearChatHistoryAlertButtonCancel =
      'group_detail_view_clear_chat_history_alert_button_cancel';
  static const groupDetailViewCancel = 'group_detail_view_cancel';
  static const groupDetailViewMember = 'group_detail_view_group_member';
  static const groupDetailViewGroupName = 'group_detail_view_group_name';
  static const groupDetailViewDescription = 'group_detail_view_description';
  static const groupDetailViewSwitchPublic = 'group_detail_view_switch_public';
  static const groupDetailViewTransferGroup =
      'group_detail_view_transfer_group';
  static const groupDetailViewDisbandGroup = 'group_detail_view_disband_group';
  static const groupDetailViewDisbandAlertTitle =
      'group_detail_view_disband_alert_title';
  static const groupDetailViewDisbandAlertSubTitle =
      'group_detail_view_disband_alert_sub_title';
  static const groupDetailViewDisbandAlertButtonConfirm =
      'group_detail_view_disband_alert_button_confirm';
  static const groupDetailViewDisbandAlertButtonCancel =
      'group_detail_view_disband_alert_button_cancel';
  static const groupDetailViewLeaveGroup = 'group_detail_view_leave_group';
  static const groupDetailViewLeaveAlertTitle =
      'group_detail_view_leave_alert_title';
  static const groupDetailViewLeaveAlertSubTitle =
      'group_detail_view_leave_alert_sub_title';
  static const groupDetailViewLeaveAlertButtonConfirm =
      'group_detail_view_leave_alert_button_confirm';
  static const groupDetailViewLeaveAlertButtonCancel =
      'group_detail_view_leave_alert_button_cancel';
  static const groupDetailChangeGroupName = 'group_detail_change_group_name';
  static const groupDetailChangeGroupDescription =
      'group_detail_change_group_description';

  static const groupMentionViewMentionAll = 'group_mention_view_mention_all';
  static const groupMentionViewTitle = 'group_mention_view_title';
  static const groupMentionViewSearchHint = 'group_mention_view_search_hint';

  static const groupAddMembersViewTitle = 'group_add_member_view_title';
  static const groupAddMembersViewSearchContact =
      'group_add_member_view_search_contact';
  static const groupAddMembersViewAdd = 'group_add_member_view_add';

  static const groupDeleteMembersViewTitle = 'group_delete_member_view_title';
  static const groupDeleteMembersViewSearchMember =
      'group_delete_member_view_search_member';
  static const groupDeleteMembersViewDelete = 'group_delete_member_view_delete';

  static const groupDeleteMembersViewAlertTitle =
      'group_delete_member_view_alert_title';
  static const groupDeleteMembersViewAlertSubTitle =
      'group_delete_member_view_alert_sub_title';
  static const groupDeleteMembersViewAlertButtonConfirm =
      'group_delete_member_view_alert_button_confirm';
  static const groupDeleteMembersViewAlertButtonCancel =
      'group_delete_member_view_alert_button_cancel';
  static const groupMembersViewTitle = 'group_members_view_title';
  static const groupMembersSearch = 'group_members_view_search';
  static const groupChangeOwnerViewTitle = 'group_change_owner_view_title';
  static const groupChangeOwnerViewAlertTitle =
      'group_change_owner_view_alert_title';
  static const groupChangeOwnerViewAlertSubTitle =
      'group_change_owner_view_alert_sub_title';
  static const groupChangeOwnerViewAlertButtonConfirm =
      'group_change_owner_view_alert_button_confirm';
  static const groupChangeOwnerViewAlertButtonCancel =
      'group_change_owner_view_alert_button_cancel';

  static const groupsViewTitle = 'groups_view_title';

  static const changInfoViewSave = 'change_info_view_save';
  static const changInfoViewInputHint = 'change_info_view_input_hint';

  static const messagesViewGroupDestroyInfo =
      'messages_view_group_destroy_info';
  static const messagesViewGroupLeaveInfo = 'messages_view_group_leave_info';
  static const messagesViewGroupKickedInfo = 'messages_view_group_kicked_info';
  static const messagesViewRecallInfo = 'messages_view_recall_info';
  static const messagesViewRecallInfoYou = 'messages_view_recall_info_you';
  static const messagesViewAlertGroupInfoTitle =
      'messages_view_alert_group_info_title';
  static const messagesViewAlertGroupInfoTitleYou =
      'messages_view_alert_group_info_title_you';
  static const messagesViewEditMessageTitle =
      'messages_view_edit_message_title';
  static const messagesViewMoreActionsTitleAlbum =
      'messages_view_more_actions_title_album';
  static const messagesViewMoreActionsTitleCamera =
      'messages_view_more_actions_title_camera';
  static const messagesViewMoreActionsTitleFile =
      'messages_view_more_actions_title_file';
  static const messagesViewMoreActionsTitleLocation =
      'messages_view_more_actions_title_location';
  static const messagesViewMoreActionsTitleVideo =
      'messages_view_more_actions_title_video';
  static const messagesViewMoreActionsTitleVoice =
      'messages_view_more_actions_title_voice';
  static const messagesViewMoreActionsTitleContact =
      'messages_view_more_actions_title_contact';
  static const messagesViewLongPressActionsTitleCopy =
      'messages_view_long_press_actions_title_copy';
  static const messagesViewLongPressActionsTitleRecall =
      'messages_view_long_press_actions_title_recall';
  static const messagesViewLongPressActionsTitleDelete =
      'messages_view_long_press_actions_title_delete';
  static const messagesViewLongPressActionsTitleReply =
      'messages_view_long_press_actions_title_reply';
  static const messagesViewLongPressActionsTitleEdit =
      'messages_view_long_press_actions_title_edit';
  static const messagesViewLongPressActionsTitleReport =
      'messages_view_long_press_actions_title_report';
  static const messagesViewDeleteMessageAlertTitle =
      'messages_view_delete_message_alert_title';
  static const messagesViewDeleteMessageAlertSubTitle =
      'messages_view_delete_message_alert_sub_title';
  static const messagesViewDeleteMessageAlertButtonConfirm =
      'messages_view_delete_message_alert_confirm';
  static const messagesViewDeleteMessageAlertButtonCancel =
      'messages_view_delete_message_alert_cancel';
  static const messagesViewRecallMessageAlertTitle =
      'messages_view_recall_message_alert_title';
  static const messagesViewRecallMessageAlertSubTitle =
      'messages_view_recall_message_alert_sub_title';
  static const messagesViewRecallMessageAlertButtonConfirm =
      'messages_view_recall_message_alert_confirm';
  static const messagesViewRecallMessageAlertButtonCancel =
      'messages_view_recall_message_alert_cancel';
  static const messagesViewSelectContactTitle =
      'messages_view_select_contact_title';
  static const messagesViewSelectContactCancel =
      'messages_view_select_contact_cancel';
  static const messagesViewShareContactAlertTitle =
      'messages_view_share_contact_alert_title';
  static const messagesViewShareContactAlertSubTitle =
      'messages_view_share_contact_alert_sub_title';
  static const messagesViewShareContactAlertButtonConfirm =
      'messages_view_share_contact_alert_confirm';
  static const messagesViewShareContactAlertButtonCancel =
      'messages_view_share_contact_alert_cancel';

  static const newRequestDetailsViewAddContact =
      'new_request_details_view_add_contact';
  static const newRequestsViewTitle = 'new_requests_view_title';

  static const reportMessageViewTitle = 'report_message_view_title';
  static const reportMessageViewReportReasons =
      'report_message_view_report_reasons';
  static const reportMessageViewConfirm = 'report_message_view_confirm';
  static const reportMessageViewCancel = 'report_message_view_cancel';

  static const selectContactViewSearchHint = 'select_contact_view_search_hint';

  static const nonSupportMessage = 'non_support_message';

  static const conversationListItemMention = 'conversation_list_item_mention';

  static const listViewLoadFailed = 'list_view_load_failed';
  static const listViewReload = 'list_view_reload';
  static const quoteWidgetTitleImage = 'quote_widget_title_image';
  static const quoteWidgetTitleVideo = 'quote_widget_title_video';
  static const quoteWidgetTitleVoice = 'quote_widget_title_voice';
  static const quoteWidgetTitleFile = 'quote_widget_title_file';
  static const quoteWidgetTitleContact = 'quote_widget_title_contact';
  static const quoteWidgetTitleUnFind = 'quote_widget_title_un_find';

  static const messageListItemEdited = 'message_list_item_edit';
  static const messageListItemContactCard = 'message_list_item_contact_card';
  static const newRequestItemAdd = 'new_request_item_title';
  static const newRequestItemAddReason = 'new_request_item_add_reason';
  static const searchWidgetCancel = 'search_widget_cancel';

  static const replayBarTitleContact = 'replay_bar_title_contact';
  static const replayBarTitleFile = 'replay_bar_title_file';
  static const replayBarTitleVoice = 'replay_bar_title_voice';
  static const replayBarTitleVideo = 'replay_bar_title_video';
  static const replayBarTitleImage = 'replay_bar_title_image';
  static const replayBarTitle = 'replay_bar_title';

  static const bottomSheetCancel = 'bottom_sheet_cancel';

  static const Map<String, dynamic> zh = {
    conversationsViewMenuAddContact: '添加联系人',
    conversationsViewMenuCreateGroup: '创建群组',
    conversationsViewMenuSelectContacts: '选择联系人',
    conversationsViewMenuCreateNewChat: '发起新会话',
    conversationsViewMenuCancel: '取消',
    conversationsViewSearchHint: '搜索',
    conversationListLongPressMenuDelete: '删除',
    conversationListLongPressMenuPin: '置顶',
    conversationListLongPressMenuUnPin: '取消置顶',
    conversationListLongPressMenuMute: '静音',
    conversationListLongPressMenuUnmute: '取消静音',
    conversationListLongPressMenuRead: '标记为已读',
    conversationListLongPressMenuCancel: '取消',
    messageListLongPressMenuCopy: '复制',
    messageListLongPressMenuReply: '回复',
    messageListLongPressMenuEdit: '编辑',
    messageListLongPressMenuDelete: '删除',
    messageListLongPressMenuRecall: '撤回',
    recordBarRecord: '点击录音',
    recordBarRecording: '正在录音',
    recordBarPlay: '点击播放',
    recordBarPlaying: '播放中',
    recordBarAutoStop: '%a秒后自动停止',
    addContactTitle: '添加联系人',
    addContactSubTitle: '通过用户ID添加联系人',
    addContactInputHints: '输入用户ID',
    addContactConfirm: '添加',
    addContactCancel: '取消',
    createGroupViewTitle: '新群组',
    createGroupViewCreate: '创建',
    createGroupViewSearchContact: '搜索联系人',
    createGroupViewCancel: '取消',
    contactsViewNewRequests: '新请求',
    contactsViewGroups: '群组',
    contactsViewSearch: '搜索联系人',
    contactsAddContactAlertTitle: '添加联系人',
    contactsAddContactAlertSubTitle: '通过用户ID添加联系人',
    contactsAddContactAlertHintText: '输入用户ID',
    contactsAddContactAlertButtonConfirm: '添加',
    contactsAddContactAlertButtonCancel: '取消',
    contactDetailViewSend: '发消息',
    contactDetailViewRemark: '备注',
    contactDetailViewPhone: '电话',
    contactDetailViewDoNotDisturb: '消息免打扰',
    contactDetailViewBlock: '加入黑名单',
    contactDetailViewClearChatHistory: '清空聊天记录',
    contactDetailViewClearChatHistoryAlertTitle: '确认清空聊天记录？',
    contactDetailViewClearChatHistoryAlertSubTitle: '清空聊天记录后，你将无法查看与该联系人的聊天记录。',
    contactDetailViewClearChatHistoryAlertButtonConfirm: '确认',
    contactDetailViewClearChatHistoryAlertButtonCancel: '取消',
    contactDetailViewDelete: '删除联系人',
    contactDetailViewCancel: '取消',
    contactDetailViewDeleteAlertTitle: '确认删除联系人?',
    contactDetailViewDeleteAlertSubTitle: '确定要删除联系人同时删除与该联系人的聊天记录。',
    contactDetailViewDeleteAlertButtonConfirm: '确认',
    contactDetailViewDeleteAlertButtonCancel: '取消',
    groupDetailViewSend: '发消息',
    groupDetailViewDoNotDisturb: '消息免打扰',
    groupDetailViewClearChatHistory: '清空聊天记录',
    groupDetailViewClearChatHistoryAlertButtonConfirm: '确认',
    groupDetailViewClearChatHistoryAlertButtonCancel: '取消',
    groupDetailViewCancel: '取消',
    groupDetailViewMember: '群成员',
    groupDetailViewGroupName: '群名称',
    groupDetailViewDescription: '群描述',
    groupDetailViewSwitchPublic: '公开群组',
    groupDetailViewTransferGroup: '转让群组',
    groupDetailViewDisbandGroup: '解散群组',
    groupDetailViewDisbandAlertTitle: '确认集散群组？',
    groupDetailViewDisbandAlertSubTitle: '确认解散群组，同时删除干群的聊天记录。',
    groupDetailViewDisbandAlertButtonConfirm: '解散',
    groupDetailViewDisbandAlertButtonCancel: '取消',
    groupDetailViewLeaveGroup: '退出群组',
    groupDetailViewLeaveAlertTitle: '确认退出群组？',
    groupDetailViewLeaveAlertSubTitle: '确定退出群组，同时删除与该群的聊天记录。',
    groupDetailViewLeaveAlertButtonConfirm: '退出',
    groupDetailViewLeaveAlertButtonCancel: '取消',
    groupDetailChangeGroupName: '修改群名称',
    groupDetailChangeGroupDescription: '修改群描述',
    groupMentionViewMentionAll: '所有人',
    groupMentionViewTitle: '提及',
    groupMentionViewSearchHint: '搜索',
    groupAddMembersViewTitle: '添加群成员',
    groupAddMembersViewSearchContact: '搜索联系人',
    groupAddMembersViewAdd: '添加',
    groupDeleteMembersViewTitle: '移除群成员',
    groupDeleteMembersViewSearchMember: '搜索',
    groupDeleteMembersViewDelete: '删除',
    groupDeleteMembersViewAlertTitle: '移除群成员',
    groupDeleteMembersViewAlertSubTitle: '你确定要移除该群成员吗？',
    groupDeleteMembersViewAlertButtonConfirm: '移除',
    groupDeleteMembersViewAlertButtonCancel: '取消',
    groupMembersViewTitle: '群成员',
    groupMembersSearch: '搜索群成员',
    groupChangeOwnerViewTitle: '选择新群主',
    groupChangeOwnerViewAlertTitle: '确认将群主身份转让给成员？',
    groupChangeOwnerViewAlertSubTitle: '转让后，对方将变为群主。',
    groupChangeOwnerViewAlertButtonConfirm: '确认',
    groupChangeOwnerViewAlertButtonCancel: '取消',
    groupsViewTitle: '群组',
    changInfoViewSave: '保存',
    changInfoViewInputHint: '请输入',
    messagesViewGroupDestroyInfo: '本群组已被解散',
    messagesViewGroupLeaveInfo: '你已退出本群组',
    messagesViewGroupKickedInfo: '你已被移出本群组',
    messagesViewRecallInfo: '撤回了一条消息',
    messagesViewRecallInfoYou: '你',
    messagesViewAlertGroupInfoTitle: '创建群组',
    messagesViewAlertGroupInfoTitleYou: '你',
    messagesViewEditMessageTitle: '正在编辑',
    messagesViewMoreActionsTitleAlbum: '相册',
    messagesViewMoreActionsTitleCamera: '拍照',
    messagesViewMoreActionsTitleFile: '文件',
    messagesViewMoreActionsTitleLocation: '位置',
    messagesViewMoreActionsTitleVideo: '视频',
    messagesViewMoreActionsTitleVoice: '语音',
    messagesViewMoreActionsTitleContact: '名片',
    messagesViewLongPressActionsTitleCopy: '复制',
    messagesViewLongPressActionsTitleRecall: '撤回',
    messagesViewLongPressActionsTitleDelete: '删除',
    messagesViewLongPressActionsTitleReply: '回复',
    messagesViewLongPressActionsTitleEdit: '编辑',
    messagesViewLongPressActionsTitleReport: '举报',
    messagesViewDeleteMessageAlertTitle: '删除消息',
    messagesViewDeleteMessageAlertSubTitle: '你确定要删除本条消息么?',
    messagesViewDeleteMessageAlertButtonConfirm: '删除',
    messagesViewDeleteMessageAlertButtonCancel: '取消',
    messagesViewRecallMessageAlertTitle: '确定要撤回本条消息？',
    messagesViewRecallMessageAlertSubTitle: '撤回后消息将被删除。',
    messagesViewRecallMessageAlertButtonConfirm: '撤回',
    messagesViewRecallMessageAlertButtonCancel: '取消',
    messagesViewSelectContactTitle: '选择联系人',
    messagesViewSelectContactCancel: '取消',
    messagesViewShareContactAlertTitle: '分享名片',
    messagesViewShareContactAlertSubTitle: '分享名片给对方',
    messagesViewShareContactAlertButtonConfirm: '分享',
    messagesViewShareContactAlertButtonCancel: '取消',
    newRequestDetailsViewAddContact: '添加联系人',
    newRequestsViewTitle: '新请求',
    reportMessageViewTitle: '消息举报',
    reportMessageViewReportReasons: '举报原因',
    reportMessageViewConfirm: '举报',
    reportMessageViewCancel: '取消',
    selectContactViewSearchHint: '搜索联系人',
    nonSupportMessage: '不支持的消息类型',
    conversationListItemMention: '有人@我',
    listViewLoadFailed: '加载失败',
    listViewReload: '重新加载',
    quoteWidgetTitleImage: '图片',
    quoteWidgetTitleVideo: '视频',
    quoteWidgetTitleVoice: '语音 ',
    quoteWidgetTitleFile: '文件 ',
    quoteWidgetTitleContact: '联系人 ',
    quoteWidgetTitleUnFind: '未找到原消息',
    messageListItemEdited: '已编辑',
    messageListItemContactCard: '联系人',
    newRequestItemAdd: '添加',
    newRequestItemAddReason: '请求添加您为好友',
    searchWidgetCancel: '取消',
    replayBarTitleContact: '联系人 ',
    replayBarTitleFile: '附件 ',
    replayBarTitleVoice: '语音 ',
    replayBarTitleVideo: '视频',
    replayBarTitleImage: '图片',
    replayBarTitle: '正在回复 ',
    bottomSheetCancel: '取消',
  };

  static const Map<String, dynamic> en = {
    conversationsViewMenuAddContact: 'Add Contacts',
    conversationsViewMenuCreateGroup: 'Create Group',
    conversationsViewMenuSelectContacts: 'Select Contacts',
    conversationsViewMenuCreateNewChat: 'Create New Chat',
    conversationsViewMenuCancel: 'Cancel',
    conversationsViewSearchHint: 'Search',
    conversationListLongPressMenuDelete: 'Delete',
    conversationListLongPressMenuPin: 'Pin',
    conversationListLongPressMenuUnPin: 'Unpin',
    conversationListLongPressMenuMute: 'Mute',
    conversationListLongPressMenuUnmute: 'Unmute',
    conversationListLongPressMenuRead: 'Read',
    conversationListLongPressMenuCancel: 'Cancel',
    messageListLongPressMenuCopy: 'Copy',
    messageListLongPressMenuReply: 'Reply',
    messageListLongPressMenuEdit: 'Edit',
    messageListLongPressMenuDelete: 'Delete',
    messageListLongPressMenuRecall: 'Recall',
    recordBarRecord: 'Record',
    recordBarRecording: 'Recording',
    recordBarPlay: 'Play',
    recordBarPlaying: 'Playing',
    recordBarAutoStop: 'It stops after %a seconds',
    addContactTitle: 'Add Contacts',
    addContactSubTitle: 'Add Contacts by ID',
    addContactInputHints: 'Input ID',
    addContactConfirm: 'Add',
    addContactCancel: 'Cancel',
    createGroupViewTitle: 'Create Group',
    createGroupViewCreate: 'Create',
    createGroupViewSearchContact: 'Search Contacts',
    createGroupViewCancel: 'Cancel',
    contactsViewNewRequests: 'New Request',
    contactsViewGroups: 'Groups',
    contactsViewSearch: 'Search Contacts',
    contactsAddContactAlertTitle: 'Add Contacts',
    contactsAddContactAlertSubTitle: 'Add Contacts by ID',
    contactsAddContactAlertHintText: 'Input ID',
    contactsAddContactAlertButtonConfirm: 'Add',
    contactsAddContactAlertButtonCancel: 'Cancel',
    contactDetailViewSend: 'Send message',
    contactDetailViewRemark: 'Remark',
    contactDetailViewPhone: 'Phone',
    contactDetailViewDoNotDisturb: 'Do not disturb',
    contactDetailViewBlock: 'Block',
    contactDetailViewClearChatHistory: 'Clear chat history',
    contactDetailViewClearChatHistoryAlertTitle: 'Clear chat history?',
    contactDetailViewClearChatHistoryAlertSubTitle:
        'After clearing the chat history, you will not be able to view the chat history with this contact.',
    contactDetailViewClearChatHistoryAlertButtonConfirm: 'Confirm',
    contactDetailViewClearChatHistoryAlertButtonCancel: 'Cancel',
    contactDetailViewDelete: 'Delete contact',
    contactDetailViewCancel: 'Cancel',
    contactDetailViewDeleteAlertTitle: 'Delete contact',
    contactDetailViewDeleteAlertSubTitle:
        'Deleting a contact will also delete the chat history.',
    contactDetailViewDeleteAlertButtonConfirm: 'Confirm',
    contactDetailViewDeleteAlertButtonCancel: 'Cancel',
    groupDetailViewSend: 'Send message',
    groupDetailViewDoNotDisturb: 'Do not disturb',
    groupDetailViewClearChatHistory: 'Clear chat history',
    groupDetailViewClearChatHistoryAlertButtonConfirm: 'Confirm',
    groupDetailViewClearChatHistoryAlertButtonCancel: 'Cancel',
    groupDetailViewCancel: 'Cancel',
    groupDetailViewMember: 'Group members',
    groupDetailViewGroupName: 'Group name',
    groupDetailViewDescription: 'Group description',
    groupDetailViewSwitchPublic: 'Set public',
    groupDetailViewTransferGroup: 'Transfer owner',
    groupDetailViewDisbandGroup: 'Disband group',
    groupDetailViewDisbandAlertTitle: 'Disband group',
    groupDetailViewDisbandAlertSubTitle:
        'Disbanding the group will remove all members.',
    groupDetailViewDisbandAlertButtonConfirm: 'Confirm',
    groupDetailViewDisbandAlertButtonCancel: 'Cancel',
    groupDetailViewLeaveGroup: 'Leave group',
    groupDetailViewLeaveAlertTitle: 'Leave group',
    groupDetailViewLeaveAlertSubTitle:
        'Leaving a group will also delete the chat history.',
    groupDetailViewLeaveAlertButtonConfirm: 'Confirm',
    groupDetailViewLeaveAlertButtonCancel: 'Cancel',
    groupDetailChangeGroupName: 'Change Group Name',
    groupDetailChangeGroupDescription: 'Change Group Description',
    groupMentionViewMentionAll: 'All',
    groupMentionViewTitle: 'Group Mention',
    groupMentionViewSearchHint: 'Search',
    groupAddMembersViewTitle: 'Add Group Members',
    groupAddMembersViewSearchContact: 'Search Contacts',
    groupAddMembersViewAdd: 'Add',
    groupDeleteMembersViewTitle: 'Remove Group Members',
    groupDeleteMembersViewSearchMember: 'Search Members',
    groupDeleteMembersViewDelete: 'Delete',
    groupDeleteMembersViewAlertTitle: 'Remove Group Members',
    groupDeleteMembersViewAlertSubTitle:
        'Are you sure you want to remove this group member(s)?',
    groupDeleteMembersViewAlertButtonConfirm: 'Confirm',
    groupDeleteMembersViewAlertButtonCancel: 'Cancel',
    groupMembersViewTitle: 'Group Members',
    groupMembersSearch: 'Search Members',
    groupChangeOwnerViewTitle: 'Select new owner',
    groupChangeOwnerViewAlertTitle: 'Transfer ownership to member?',
    groupChangeOwnerViewAlertSubTitle:
        'After the transfer, the other party will become the owner.',
    groupChangeOwnerViewAlertButtonConfirm: 'Confirm',
    groupChangeOwnerViewAlertButtonCancel: 'Cancel',
    groupsViewTitle: 'Groups',
    changInfoViewSave: 'Save',
    changInfoViewInputHint: 'input',
    messagesViewGroupDestroyInfo: 'The group has been disbanded.',
    messagesViewGroupLeaveInfo: 'You have left the group.',
    messagesViewGroupKickedInfo: 'You have been removed from the group.',
    messagesViewRecallInfo: ' recalled a message',
    messagesViewRecallInfoYou: 'You',
    messagesViewAlertGroupInfoTitle: 'created a group',
    messagesViewAlertGroupInfoTitleYou: 'You',
    messagesViewEditMessageTitle: 'Editing',
    messagesViewMoreActionsTitleAlbum: 'Album',
    messagesViewMoreActionsTitleCamera: 'Camera',
    messagesViewMoreActionsTitleFile: 'File',
    messagesViewMoreActionsTitleLocation: 'Location',
    messagesViewMoreActionsTitleVideo: 'Video',
    messagesViewMoreActionsTitleVoice: 'Voice',
    messagesViewMoreActionsTitleContact: 'Contact',
    messagesViewLongPressActionsTitleCopy: 'Copy',
    messagesViewLongPressActionsTitleRecall: 'Recall',
    messagesViewLongPressActionsTitleDelete: 'Delete',
    messagesViewLongPressActionsTitleReply: 'Reply',
    messagesViewLongPressActionsTitleEdit: 'Edit',
    messagesViewLongPressActionsTitleReport: 'Report',
    messagesViewDeleteMessageAlertTitle: 'Delete message',
    messagesViewDeleteMessageAlertSubTitle:
        'Are you sure you want to delete this message?',
    messagesViewDeleteMessageAlertButtonConfirm: 'Confirm',
    messagesViewDeleteMessageAlertButtonCancel: 'Cancel',
    messagesViewRecallMessageAlertTitle:
        'Are you sure you want to recall this message?',
    messagesViewRecallMessageAlertSubTitle:
        'After the recall, the message will be deleted.',
    messagesViewRecallMessageAlertButtonConfirm: 'Recall',
    messagesViewRecallMessageAlertButtonCancel: 'Cancel',
    messagesViewSelectContactTitle: 'Select contact',
    messagesViewSelectContactCancel: 'Cancel',
    messagesViewShareContactAlertTitle: 'Share contact',
    messagesViewShareContactAlertSubTitle: 'Share contact with the other party',
    messagesViewShareContactAlertButtonConfirm: 'Share',
    messagesViewShareContactAlertButtonCancel: 'Cancel',
    newRequestDetailsViewAddContact: 'Add contact',
    newRequestsViewTitle: 'New Requests',
    reportMessageViewTitle: 'Report message',
    reportMessageViewReportReasons: 'Report reasons',
    reportMessageViewConfirm: 'Report',
    reportMessageViewCancel: 'Cancel',
    selectContactViewSearchHint: 'Search contacts',
    nonSupportMessage: 'Unsupported message type',
    conversationListItemMention: 'Mentioned',
    listViewLoadFailed: 'Load failed',
    listViewReload: 'Reload',
    quoteWidgetTitleImage: 'Image',
    quoteWidgetTitleVideo: 'Video',
    quoteWidgetTitleVoice: 'Voice ',
    quoteWidgetTitleFile: 'File ',
    quoteWidgetTitleContact: 'Contact ',
    quoteWidgetTitleUnFind: 'Not found original message',
    messageListItemEdited: 'Have been edited',
    messageListItemContactCard: 'Contact card',
    newRequestItemAdd: 'Add',
    newRequestItemAddReason: 'Request to add you as a friend',
    searchWidgetCancel: 'Cancel',
    replayBarTitleContact: 'Contact ',
    replayBarTitleFile: 'File ',
    replayBarTitleVoice: 'Voice ',
    replayBarTitleVideo: 'Video',
    replayBarTitleImage: 'Image',
    replayBarTitle: 'Replying ',
    bottomSheetCancel: 'Cancel',
  };
}

class ChatUIKitLocalizations {
  final defaultLocale = [
    const MapLocale('zh', ChatUIKitLocal.zh),
    const MapLocale('en', ChatUIKitLocal.en),
  ];

  static final ChatUIKitLocalizations _instance = ChatUIKitLocalizations._();
  factory ChatUIKitLocalizations() => _instance;
  final FlutterLocalization _localization = FlutterLocalization.instance;
  ChatUIKitLocalizations._() {
    WidgetsFlutterBinding.ensureInitialized();
    _localization.init(
      mapLocales: defaultLocale,
      initLanguageCode: 'en',
    );
  }

  Iterable<Locale> get supportedLocales => _localization.supportedLocales;
  Iterable<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      _localization.localizationsDelegates;

  void addLocales({required List<MapLocale> locales}) {
    _localization.init(
      mapLocales: defaultLocale + locales,
      initLanguageCode: 'en',
    );
  }

  Locale displayLanguageWhenNotSupported = const Locale('en');

  Locale? localeResolutionCallback(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    Locale? ret;
    int index = supportedLocales.toList().lastIndexWhere(
        (element) => element.languageCode == locale?.languageCode);
    if (index == -1) {
      ret = displayLanguageWhenNotSupported;
    } else {
      ret = supportedLocales.elementAt(index);
    }

    return ret;
  }
}
