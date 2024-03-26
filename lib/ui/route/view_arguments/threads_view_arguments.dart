import 'package:em_chat_uikit/chat_uikit.dart';

class ThreadsViewArguments implements ChatUIKitViewArguments {
  ThreadsViewArguments({
    required this.profile,
    this.attributes,
    this.viewObserver,
  });

  final ChatUIKitProfile profile;
  @override
  String? attributes;

  @override
  ChatUIKitViewObserver? viewObserver;
}
