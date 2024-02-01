import 'package:em_chat_uikit/sdk_wrapper/chat_sdk_wrapper.dart';

abstract mixin class PresenceObserver implements ChatUIKitObserverBase {
  void onPresenceStatusChanged(List<Presence> list) {}
}
