import 'package:em_chat_uikit/sdk_wrapper/chat_sdk_wrapper.dart';

abstract mixin class ChatSDKEventsObserver implements ChatUIKitObserverBase {
  void onChatSDKEventBegin(ChatSDKEvent event) {}

  void onChatSDKEventEnd(ChatSDKEvent event, ChatError? error) {}
}
