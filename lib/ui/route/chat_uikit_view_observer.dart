import 'package:flutter/foundation.dart';

class ChatUIKitViewObserver extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}
