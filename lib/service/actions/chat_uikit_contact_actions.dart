import 'package:em_chat_uikit/chat_uikit.dart';

mixin ChatUIKitContactActions on ChatSDKWrapper {
  @override
  Future<void> acceptContactRequest({required String userId}) async {
    await super.acceptContactRequest(userId: userId);
    ChatUIKitContext.instance.removeRequest(userId);
  }

  @override
  Future<void> declineContactRequest({required String userId}) async {
    await super.declineContactRequest(userId: userId);
    ChatUIKitContext.instance.removeRequest(userId);
  }

  @override
  Future<List<String>> getAllContacts() async {
    List<String> ret = await super.getAllContacts();
    ChatUIKitContext.instance.removeRequests(ret);
    return ret;
  }

  @override
  Future<List<String>> fetchAllContactIds() async {
    List<String> ret = await super.fetchAllContactIds();
    for (var userId in ret) {
      ChatUIKitContext.instance.removeRequest(userId);
    }
    return ret;
  }
}
