import 'package:em_chat_uikit/chat_uikit.dart';

import 'package:flutter/widgets.dart';

const String themeKey = 'themeKey';
const String languageKey = 'languageKey';

class SettingsDataStore {
  static SettingsDataStore? _instance;
  SharedPreferences? _sharedPreferences;

  List<String> unNotifyGroupIds = [];

  factory SettingsDataStore() {
    _instance ??= SettingsDataStore._();
    return _instance!;
  }

  SettingsDataStore._();

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _sharedPreferences ??= await SharedPreferences.getInstance();

    ChatUIKitLocalizations().translate(currentLanguage);
  }

  int get currentThemeIndex {
    return _sharedPreferences?.getInt(themeKey) ?? 0;
  }

  Future<void> saveTheme(int index) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _sharedPreferences?.setInt(themeKey, index);
  }

  String get currentLanguage {
    return _sharedPreferences?.getString(languageKey) ?? 'en';
  }

  Future<void> saveLanguage(String language) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _sharedPreferences?.setString(languageKey, language);
  }

  // Future<void> languageChange({String language = 'zh'}) async {
  //   _sharedPreferences ??= await SharedPreferences.getInstance();
  //   _sharedPreferences?.setString(languageKey, language);
  // }

  // String getLanguage() {
  //   return _sharedPreferences?.getString(languageKey) ?? 'en';
  // }
}
