import 'package:em_chat_uikit/chat_uikit.dart';

abstract mixin class ChatUIKitProviderObserver {
  void onProfilesUpdate(
    Map<String, ChatUIKitProfile> map,
  ) {}

  void onCurrentUserDataUpdate(
    UserData? userData,
  ) {}
}

typedef ChatUIKitProviderProfileHandler = List<ChatUIKitProfile>? Function(
  List<ChatUIKitProfile> profiles,
);

class ChatUIKitProvider {
  static ChatUIKitProvider? _instance;
  static ChatUIKitProvider get instance {
    _instance ??= ChatUIKitProvider._internal();
    return _instance!;
  }

  ChatUIKitProvider._internal();

  ChatUIKitProviderProfileHandler? profilesHandler;

  // 缓存 profile, 不需要存；
  final Map<String, ChatUIKitProfile> profilesCache = {};

  final List<ChatUIKitProviderObserver> _observers = [];

  UserData? _currentUserData;

  set currentUserData(UserData? userData) {
    _currentUserData = userData;
    for (var observer in _observers) {
      observer.onCurrentUserDataUpdate(userData);
    }
  }

  UserData? get currentUserData {
    return _currentUserData;
  }

  void addObserver(ChatUIKitProviderObserver observer) {
    _observers.add(observer);
  }

  void removeObserver(ChatUIKitProviderObserver observer) {
    _observers.remove(observer);
  }

  void clearAllObservers() {
    _observers.clear();
  }

  void clearProfilesCache() {
    profilesCache.clear();
  }

  void clearAllCache() {
    profilesCache.clear();
  }

  Map<String, ChatUIKitProfile> getProfiles(List<ChatUIKitProfile> profiles) {
    List<ChatUIKitProfile> ret = [];
    List<ChatUIKitProfile> needProviders = [];

    for (var profile in profiles) {
      ChatUIKitProfile? cachedProfile = profilesCache[profile.id];
      if (cachedProfile == null) {
        needProviders.add(profile);
      } else {
        ret.add(cachedProfile);
      }
    }

    if (needProviders.isNotEmpty) {
      List<ChatUIKitProfile>? tmp = profilesHandler?.call(needProviders);
      if (tmp?.isNotEmpty == true) {
        needProviders.removeWhere(
            (element) => tmp!.map((e) => e.id).contains(element.id));
        var result = {for (var element in tmp!) element.id: element};
        addProfiles(result.values.toList());
        ret.removeWhere((element) => result.keys.contains(element.id));
        ret.addAll(result.values);
      }
      ret.addAll(needProviders);
    }

    return {for (var element in ret) element.id: element};
  }

  ChatUIKitProfile getProfile(ChatUIKitProfile profile) {
    return getProfiles([profile])[profile.id]!;
  }

  void addProfiles(List<ChatUIKitProfile> list) {
    var result = {for (var element in list) element.id: element};
    profilesCache.addAll(result);

    for (var observer in _observers) {
      observer.onProfilesUpdate(result);
    }
  }
}
