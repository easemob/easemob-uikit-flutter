import 'package:em_chat_uikit/chat_uikit.dart';

mixin ChatUIKitEventsActions on ChatSDKWrapper {
  void sendChatUIKitEvent(ChatUIKitEvent event) {
    for (var element in observers) {
      if (element is ChatUIKitEventsObservers) {
        element.onChatUIKitEventsReceived(event);
      }
    }
  }
}
