typedef AlphabetSortHandler = String Function(String showName);

class ChatUIKitAlphabetSortHelper {
  static ChatUIKitAlphabetSortHelper? _instance;
  static ChatUIKitAlphabetSortHelper get instance {
    _instance ??= ChatUIKitAlphabetSortHelper._internal();
    return _instance!;
  }

  AlphabetSortHandler? sortHandler;

  ChatUIKitAlphabetSortHelper._internal();
}
