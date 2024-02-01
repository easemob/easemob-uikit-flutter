import 'package:em_chat_uikit/sdk_wrapper/chat_sdk_wrapper.dart';

mixin ContactActions on ContactWrapper {
  Future<List<String>> getAllContacts() {
    return checkResult(ChatSDKEvent.getAllContacts, () {
      return Client.getInstance.contactManager.getAllContactIds();
    });
  }

  Future<void> sendContactRequest({required String userId, String? reason}) {
    return checkResult(ChatSDKEvent.sendContactRequest, () {
      return Client.getInstance.contactManager
          .addContact(userId, reason: reason);
    });
  }

  Future<void> acceptContactRequest({required String userId}) {
    return checkResult(ChatSDKEvent.acceptContactRequest, () {
      return Client.getInstance.contactManager.acceptInvitation(userId);
    });
  }

  Future<void> declineContactRequest({required String userId}) {
    return checkResult(ChatSDKEvent.declineContactRequest, () {
      return Client.getInstance.contactManager.declineInvitation(userId);
    });
  }

  Future<void> deleteContact({required String userId}) {
    return checkResult(ChatSDKEvent.deleteContact, () {
      return Client.getInstance.contactManager.deleteContact(userId);
    });
  }

  Future<List<String>> fetchAllContactIds() {
    return checkResult(ChatSDKEvent.fetchAllContacts, () {
      return Client.getInstance.contactManager.fetchAllContactIds();
    });
  }

  Future<List<String>> fetchAllBlockedContacts() {
    return checkResult(ChatSDKEvent.fetchAllBlockedContacts, () {
      return Client.getInstance.contactManager.fetchBlockIds();
    });
  }

  Future<void> addBlockedContact({required String userId}) {
    return checkResult(ChatSDKEvent.addBlockedContact, () {
      return Client.getInstance.contactManager.addUserToBlockList(userId);
    });
  }

  Future<void> deleteBlockedContact({required String userId}) {
    return checkResult(ChatSDKEvent.deleteBlockedContact, () {
      return Client.getInstance.contactManager.removeUserFromBlockList(userId);
    });
  }
}
