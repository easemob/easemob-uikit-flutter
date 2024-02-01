import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ChatUIKitRouteNames {
  static const String changeInfoView = '/ChangeInfoView';
  static const String contactDetailsView = '/ContactDetailsView';
  static const String contactsView = '/ContactsView';
  static const String conversationsView = '/ConversationsView';
  static const String createGroupView = '/CreateGroupView';
  static const String groupChangeOwnerView = '/GroupChangeOwnerView';
  static const String groupDetailsView = '/GroupDetailsView';
  static const String groupsView = '/GroupsView';
  static const String groupMembersView = '/GroupMembersView';
  static const String selectContactsView = '/SelectContactsView';
  static const String newRequestDetailsView = '/NewRequestDetailsView';
  static const String newRequestsView = '/NewRequestsView';
  static const String searchUsersView = '/SearchUsersView';
  static const String searchGroupMembersView = '/SearchGroupMembersView';
  static const String groupDeleteMembersView = '/GroupDeleteMembersView';
  static const String groupAddMembersView = '/GroupAddMembersView';
  static const String messagesView = '/MessagesView';
  static const String showImageView = '/ShowImageView';
  static const String showVideoView = '/ShowVideoView';
  static const String currentUserInfoView = '/CurrentUserInfoView';
  static const String groupMentionView = '/GroupMentionView';
  static const String reportMessageView = '/ReportMessageView';

  static Widget getWidthFromName(String name, ChatUIKitViewArguments arguments) {
    switch (name) {
      case ChatUIKitRouteNames.changeInfoView:
        return ChangeInfoView.arguments(
          arguments as ChangeInfoViewArguments,
        );
      case ChatUIKitRouteNames.contactDetailsView:
        return ContactDetailsView.arguments(
          arguments as ContactDetailsViewArguments,
        );
      case ChatUIKitRouteNames.contactsView:
        return ContactsView.arguments(
          arguments as ContactsViewArguments,
        );
      case ChatUIKitRouteNames.conversationsView:
        return ConversationsView.arguments(
          arguments as ConversationsViewArguments,
        );
      case ChatUIKitRouteNames.createGroupView:
        return CreateGroupView.arguments(
          arguments as CreateGroupViewArguments,
        );
      case ChatUIKitRouteNames.groupChangeOwnerView:
        return GroupChangeOwnerView.arguments(
          arguments as GroupChangeOwnerViewArguments,
        );
      case ChatUIKitRouteNames.groupDetailsView:
        return GroupDetailsView.arguments(
          arguments as GroupDetailsViewArguments,
        );
      case ChatUIKitRouteNames.groupsView:
        return GroupsView.arguments(
          arguments as GroupsViewArguments,
        );
      case ChatUIKitRouteNames.groupMembersView:
        return GroupMembersView.arguments(
          arguments as GroupMembersViewArguments,
        );
      case ChatUIKitRouteNames.selectContactsView:
        return SelectContactView.arguments(
          arguments as SelectContactViewArguments,
        );
      case ChatUIKitRouteNames.newRequestDetailsView:
        return NewRequestDetailsView.arguments(
          arguments as NewRequestDetailsViewArguments,
        );
      case ChatUIKitRouteNames.newRequestsView:
        return NewRequestsView.arguments(
          arguments as NewRequestsViewArguments,
        );
      case ChatUIKitRouteNames.searchUsersView:
        return SearchUsersView.arguments(
          arguments as SearchUsersViewArguments,
        );
      case ChatUIKitRouteNames.searchGroupMembersView:
        return SearchGroupMembersView.arguments(
          arguments as SearchGroupMembersViewArguments,
        );
      case ChatUIKitRouteNames.groupDeleteMembersView:
        return GroupDeleteMembersView.arguments(
          arguments as GroupDeleteMembersViewArguments,
        );
      case ChatUIKitRouteNames.groupAddMembersView:
        return GroupAddMembersView.arguments(
          arguments as GroupAddMembersViewArguments,
        );
      case ChatUIKitRouteNames.messagesView:
        return MessagesView.arguments(
          arguments as MessagesViewArguments,
        );
      case ChatUIKitRouteNames.showImageView:
        return ShowImageView.arguments(
          arguments as ShowImageViewArguments,
        );
      case ChatUIKitRouteNames.showVideoView:
        return ShowVideoView.arguments(
          arguments as ShowVideoViewArguments,
        );
      case ChatUIKitRouteNames.currentUserInfoView:
        return CurrentUserInfoView.arguments(
          arguments as CurrentUserInfoViewArguments,
        );
      case ChatUIKitRouteNames.groupMentionView:
        return GroupMentionView.arguments(
          arguments as GroupMentionViewArguments,
        );
      case ChatUIKitRouteNames.reportMessageView:
        return ReportMessageView.arguments(
          arguments as ReportMessageViewArguments,
        );
    }
    return const SizedBox();
  }
}
