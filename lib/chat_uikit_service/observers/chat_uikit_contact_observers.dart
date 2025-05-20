import '../../chat_uikit.dart';
import '../../universal/inner_headers.dart';

mixin ChatUIKitContactObservers on ChatSDKService {
  @override
  void onContactRequestReceived(String userId, String? reason) {
    // 回调好友通知之前需要先存储好友请求数据
    if (ChatSDKContext.instance.addRequest(userId, reason)) {
      super.onContactRequestReceived(userId, reason);
    }
  }

  @override
  void onContactAdded(String userId) async {
    await ChatUIKitInsertTools.insertAddContactMessage(userId);
    ChatSDKContext.instance.removeRequest(userId);
    super.onContactAdded(userId);
  }
}
