
import 'package:em_chat_uikit/sdk_wrapper/chat_sdk_wrapper.dart';

abstract mixin class ContactObserver implements ChatUIKitObserverBase {
  void onContactAdded(String userId) {}
  void onContactDeleted(String userId) {}
  void onContactRequestReceived(String userId, String? reason) {}
  void onFriendRequestAccepted(String userId) {}
  void onFriendRequestDeclined(String userId) {}
}
