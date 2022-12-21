import 'dart:convert';
import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase{

  static String loginCheck = 'loginCheck';
  static String authToken = 'authToken';
  static String userId = 'userId';
  static String loginPlatform = 'loginPlatform';
  static String feedBox = 'feedBox';
  static String appBox = 'app';

  static String currentLang = 'currentLang';

  HiveDatabase._();
  static final HiveDatabase _instance = HiveDatabase._();
  factory HiveDatabase() => _instance;

  Box? _box;
  Box get box => _box!;

  Box? _feedBox;
  Box get fedBox => _feedBox!;

  static Future<void> init() async {
    await Hive.initFlutter();
    _instance._box = await Hive.openBox(appBox);
    log('AppBox Open: ${_instance._box?.isOpen}');

    // Initializing Feed Box
    // await initFeedBox();
  }

  static Future<void> initFeedBox() async {
    _instance._feedBox = await Hive.openBox(feedBox);
    log('FeedBox Open: ${_instance._feedBox?.isOpen}');
  }

  static void storeValue(String key, dynamic value) async {
    _instance._box!.put(key, value);
  }

  static dynamic getValue(String key){
    return _instance._box?.get(key);
  }


}