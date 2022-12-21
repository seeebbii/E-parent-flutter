import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  static NavigationController instance = Get.find();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  Future<dynamic>? navigateToNamed(String routeName) {
    return Get.toNamed(routeName);
  }

  Future<dynamic>? navigateToNamedWithArg(String routeName, dynamic arg) {
    return Get.toNamed(routeName, arguments: arg);
  }

  Future<dynamic>? getOffAll(String routeName) {
    return Get.offAllNamed(routeName);
  }

  Future<dynamic>? getOffAllWithArguments(String routeName, dynamic arg) {
    return Get.offAllNamed(routeName, arguments: arg);
  }

  Future<dynamic>? getOff(String routeName) {
    return Get.offNamed(routeName);
  }

  Future<dynamic>? getOffWithArguments(String routeName, dynamic arg) {
    return Get.offNamed(routeName, arguments: arg);
  }

  goBack() => Get.back();
}
