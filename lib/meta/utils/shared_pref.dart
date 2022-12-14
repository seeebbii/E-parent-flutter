import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {

  SharedPref._();
  static final SharedPref _instance = SharedPref._();
  factory SharedPref() => _instance;
  SharedPreferences? _pref;
  SharedPreferences get pref => _pref!;

  static const String languageCode = 'languageCode';
  static const String countryCode = 'countryCode';

  static Future<void> init() async {
    _instance._pref = await SharedPreferences.getInstance();
  }

}