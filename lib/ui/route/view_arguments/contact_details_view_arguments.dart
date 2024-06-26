import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/widgets.dart';

class ContactDetailsViewArguments implements ChatUIKitViewArguments {
  ContactDetailsViewArguments({
    required this.profile,
    this.actionsBuilder,
    this.onMessageDidClear,
    this.appBar,
    this.viewObserver,
    this.contentWidgetBuilder,
    this.attributes,
    this.appBarTrailingActionsBuilder,
    this.onContactDeleted,
    this.enableAppBar = true,
  });

  final ChatUIKitProfile profile;
  final ChatUIKitModelActionsBuilder? actionsBuilder;
  final VoidCallback? onMessageDidClear;
  final ChatUIKitAppBar? appBar;
  final WidgetBuilder? contentWidgetBuilder;
  final VoidCallback? onContactDeleted;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder;
  final bool enableAppBar;

  ContactDetailsViewArguments copyWith({
    ChatUIKitProfile? profile,
    ChatUIKitModelActionsBuilder? actionsBuilder,
    VoidCallback? onMessageDidClear,
    ChatUIKitAppBar? appBar,
    ChatUIKitViewObserver? viewObserver,
    VoidCallback? onContactDeleted,
    String? attributes,
    WidgetBuilder? contentWidgetBuilder,
    ChatUIKitAppBarTrailingActionsBuilder? appBarTrailingActionsBuilder,
    bool? enableAppBar,
  }) {
    return ContactDetailsViewArguments(
      profile: profile ?? this.profile,
      actionsBuilder: actionsBuilder ?? this.actionsBuilder,
      onMessageDidClear: onMessageDidClear ?? this.onMessageDidClear,
      appBar: appBar ?? this.appBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
      contentWidgetBuilder: contentWidgetBuilder ?? this.contentWidgetBuilder,
      appBarTrailingActionsBuilder:
          appBarTrailingActionsBuilder ?? this.appBarTrailingActionsBuilder,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      onContactDeleted: onContactDeleted ?? this.onContactDeleted,
    );
  }
}
