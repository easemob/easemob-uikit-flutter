import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/widgets.dart';

class GroupDetailsViewArguments implements ChatUIKitViewArguments {
  GroupDetailsViewArguments({
    required this.profile,
    required this.actions,
    this.appBar,
    this.enableAppBar = true,
    this.onMessageDidClear,
    this.attributes,
  });
  final ChatUIKitProfile profile;
  final List<ChatUIKitActionModel> actions;
  final ChatUIKitAppBar? appBar;
  final bool enableAppBar;
  final VoidCallback? onMessageDidClear;

  @override
  String? attributes;

  GroupDetailsViewArguments copyWith({
    ChatUIKitProfile? profile,
    List<ChatUIKitActionModel>? actions,
    bool? enableAppBar,
    ChatUIKitAppBar? appBar,
    String? attributes,
  }) {
    return GroupDetailsViewArguments(
      profile: profile ?? this.profile,
      actions: actions ?? this.actions,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBar: appBar ?? this.appBar,
      attributes: attributes ?? this.attributes,
    );
  }
}
