import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

typedef ChatUIKitWidgetBuilder = Widget Function(
  BuildContext context,
  Object? arguments,
);

enum ChatUIKitRouteBackType { add, remove, update }

class ChatUIKitRouteBackModel {
  ChatUIKitRouteBackModel.update(this.profileId)
      : type = ChatUIKitRouteBackType.update;

  ChatUIKitRouteBackModel.add(this.profileId)
      : type = ChatUIKitRouteBackType.add;

  ChatUIKitRouteBackModel.remove(this.profileId)
      : type = ChatUIKitRouteBackType.remove;

  const ChatUIKitRouteBackModel({
    required this.type,
    required this.profileId,
  });

  ChatUIKitRouteBackModel copy() {
    return ChatUIKitRouteBackModel(
      type: type,
      profileId: profileId,
    );
  }

  final ChatUIKitRouteBackType type;
  final String profileId;
}

class ChatUIKitRoute {
  static ChatUIKitRoute? _instance;
  static bool hasInit = false;
  static ChatUIKitRouteBackModel? _lastBackModel;
  static ChatUIKitRoute get instance => _instance ??= ChatUIKitRoute._();
  factory ChatUIKitRoute() => _instance ??= ChatUIKitRoute._();

  ChatUIKitRoute._() {
    hasInit = true;
  }

  final Map<String, ChatUIKitWidgetBuilder> _uikitRoutes =
      <String, ChatUIKitWidgetBuilder>{
    ChatUIKitRouteNames.changeInfoView: (context, arguments) {
      return ChangeInfoView.arguments(
        arguments as ChangeInfoViewArguments,
      );
    },
    ChatUIKitRouteNames.contactDetailsView: (context, arguments) {
      return ContactDetailsView.arguments(
        arguments as ContactDetailsViewArguments,
      );
    },
    ChatUIKitRouteNames.contactsView: (context, arguments) {
      return ContactsView.arguments(
        arguments as ContactsViewArguments,
      );
    },
    ChatUIKitRouteNames.groupChangeOwnerView: (context, arguments) {
      return GroupChangeOwnerView.arguments(
        arguments as GroupChangeOwnerViewArguments,
      );
    },
    ChatUIKitRouteNames.groupDetailsView: (context, arguments) {
      return GroupDetailsView.arguments(
        arguments as GroupDetailsViewArguments,
      );
    },
    ChatUIKitRouteNames.newRequestsView: (context, arguments) {
      return NewRequestsView.arguments(
        arguments as NewRequestsViewArguments,
      );
    },
    ChatUIKitRouteNames.groupsView: (context, arguments) {
      return GroupsView.arguments(
        arguments as GroupsViewArguments,
      );
    },
    ChatUIKitRouteNames.selectContactsView: (context, arguments) {
      return SelectContactView.arguments(
        arguments as SelectContactViewArguments,
      );
    },
    ChatUIKitRouteNames.newRequestDetailsView: (context, arguments) {
      return NewRequestDetailsView.arguments(
        arguments as NewRequestDetailsViewArguments,
      );
    },
    ChatUIKitRouteNames.searchUsersView: (context, arguments) {
      return SearchUsersView.arguments(
        arguments as SearchUsersViewArguments,
      );
    },
    ChatUIKitRouteNames.groupMembersView: (context, arguments) {
      return GroupMembersView.arguments(
        arguments as GroupMembersViewArguments,
      );
    },
    ChatUIKitRouteNames.groupAddMembersView: (context, arguments) {
      return GroupAddMembersView.arguments(
        arguments as GroupAddMembersViewArguments,
      );
    },
    ChatUIKitRouteNames.groupDeleteMembersView: (context, arguments) {
      return GroupDeleteMembersView.arguments(
        arguments as GroupDeleteMembersViewArguments,
      );
    },
    ChatUIKitRouteNames.searchGroupMembersView: (context, arguments) {
      return SearchGroupMembersView.arguments(
        arguments as SearchGroupMembersViewArguments,
      );
    },
    ChatUIKitRouteNames.messagesView: (context, arguments) {
      return MessagesView.arguments(
        arguments as MessagesViewArguments,
      );
    },
    ChatUIKitRouteNames.conversationsView: (context, arguments) {
      return ConversationsView.arguments(
        arguments as ConversationsViewArguments,
      );
    },
    ChatUIKitRouteNames.showImageView: (context, arguments) {
      return ShowImageView.arguments(
        arguments as ShowImageViewArguments,
      );
    },
    ChatUIKitRouteNames.showVideoView: (context, arguments) {
      return ShowVideoView.arguments(
        arguments as ShowVideoViewArguments,
      );
    },
    ChatUIKitRouteNames.currentUserInfoView: (context, arguments) {
      return CurrentUserInfoView.arguments(
        arguments as CurrentUserInfoViewArguments,
      );
    },
    ChatUIKitRouteNames.createGroupView: (context, arguments) {
      return CreateGroupView.arguments(
        arguments as CreateGroupViewArguments,
      );
    },
    ChatUIKitRouteNames.groupMentionView: (context, arguments) {
      return GroupMentionView.arguments(
        arguments as GroupMentionViewArguments,
      );
    },
    ChatUIKitRouteNames.reportMessageView: ((context, arguments) {
      return ReportMessageView.arguments(
        arguments as ReportMessageViewArguments,
      );
    }),
  };

  static ChatUIKitRouteBackModel? get lastModel {
    ChatUIKitRouteBackModel? ret = _lastBackModel?.copy();
    _lastBackModel = null;
    return ret;
  }

  static popToRoot(
    BuildContext context, {
    ChatUIKitRouteBackModel? model,
  }) {
    _lastBackModel = model;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  static popToGroupsView(
    BuildContext context, {
    ChatUIKitRouteBackModel? model,
  }) {
    _lastBackModel = model;
    Navigator.of(context).popUntil((route) {
      return route.settings.name == ChatUIKitRouteNames.groupsView ||
          route.isFirst;
    });
  }

  static popToContactsView(
    BuildContext context, {
    ChatUIKitRouteBackModel? model,
  }) {
    _lastBackModel = model;
    Navigator.of(context).popUntil((route) {
      return route.settings.name == ChatUIKitRouteNames.contactsView ||
          route.isFirst;
    });
  }

  Route? generateRoute<T extends Object>(RouteSettings settings) {
    if (settings.arguments is ChatUIKitViewArguments) {
      ChatUIKitWidgetBuilder? builder = _uikitRoutes[settings.name];
      if (builder != null) {
        final route = MaterialPageRoute(
          builder: (context) {
            return builder(context, settings.arguments);
          },
          settings: settings,
        );

        return route;
      }
      return null;
    } else {
      return null;
    }
  }

  static Future<T?> pushOrPushNamed<T extends Object?>(
    BuildContext context,
    String pushNamed,
    ChatUIKitViewArguments arguments,
  ) {
    if (hasInit) {
      return Navigator.of(context).pushNamed(
        pushNamed,
        arguments: arguments,
      );
    } else {
      return Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ChatUIKitRouteNames.getWidthFromName(
              pushNamed,
              arguments,
            );
          },
        ),
      );
    }
  }
}
