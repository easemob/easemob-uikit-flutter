import '../../chat_sdk_service.dart';

abstract mixin class ConnectObserver implements ChatUIKitObserverBase {
  void onConnected() {}
  void onDisconnected(int? errorCode, LoginExtensionInfo? info) {}
  void onTokenWillExpire() {}
  void onTokenDidExpire() {}
  void onDataSyncStart(int type) {}
  void onDataSyncFinish(int type, ChatError? error) {}
}
