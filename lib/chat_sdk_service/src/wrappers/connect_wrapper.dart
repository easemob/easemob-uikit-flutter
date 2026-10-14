import '../../chat_sdk_service.dart';
import 'package:flutter/foundation.dart';

mixin ConnectWrapper on ChatUIKitServiceBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.addConnectionEventHandler(
      sdkEventKey,
      ConnectionEventHandler(
        onConnected: onConnected,
        onDisconnected: onDisconnected,
        onTokenWillExpire: onTokenWillExpire,
        onTokenDidExpire: onTokenDidExpire,
        onDataSyncStart: onDataSyncStart,
        onDataSyncFinish: onDataSyncFinish,
      ),
    );
  }

  @override
  void removeListeners() {
    super.removeListeners();
    Client.getInstance.removeConnectionEventHandler(sdkEventKey);
  }

  @protected
  void onConnected() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onConnected();
      }
    }
  }

  @protected
  void onDisconnected(int? errorCode, LoginExtensionInfo? info) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onDisconnected(errorCode, info);
      }
    }
  }

  @protected
  void onTokenWillExpire() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onTokenWillExpire();
      }
    }
  }

  @protected
  void onTokenDidExpire() {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onTokenDidExpire();
      }
    }
  }

  @protected
  void onDataSyncStart(int type) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onDataSyncStart(type);
      }
    }
  }

  @protected
  void onDataSyncFinish(int type, ChatError? error) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ConnectObserver) {
        observer.onDataSyncFinish(type, error);
      }
    }
  }
}
