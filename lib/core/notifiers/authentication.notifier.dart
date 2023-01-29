import 'dart:developer';
import 'dart:io';

import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/core/api/api_paths.dart';
import 'package:e_parent_kit/core/api/api_service.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/authentication/authentication.model.dart';
import 'package:e_parent_kit/core/models/notification/notifications.model.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/utils/hive_database.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationNotifier extends ChangeNotifier {

  AuthenticationModel authModel = AuthenticationModel();
  NotificationsModel notificationsModel = NotificationsModel();

  Role get currentRoleLoggedIn => authModel.user!.authRole!;

  /// GENERATE FCM TOKEN
  Future<String> firebaseToken() async {
    FirebaseMessaging fcm = FirebaseMessaging.instance;
    String? token = await fcm.getToken();
    if (token != '') {
      return token ?? "Failed";
    } else {
      return "Failed";
    }
  }

  Future<void> fetchProfile() async {
    var response = await ApiService.request(
      ApiPaths.profile,
      method: RequestMethod.GET,
    );
    // log("$response");
    if (response != null) {
      authModel = AuthenticationModel.fromJson(response);
      notifyListeners();
      log("User Profile: ${authModel.toJson()}");
    }
  }
  
  Future<void> afterAuthHandler(BuildContext context) async {
    // Check if the auth data is not null
    if(authModel.user?.sId != null){
      // Check if the user is teacher or parent
      if(authModel.user?.authRole == Role.Parent){
        log("Parent Role");
        // Check if the parent has selected their children
        if(authModel.parentData?.students == null || authModel.parentData!.students!.isEmpty){
          navigationController.getOffAll(RouteGenerator.addStudentsScreen);
        }else{
          navigationController.getOffAll(RouteGenerator.rootScreen);
        }
        return;
      }

      if(authModel.user?.authRole == Role.Teacher){
        log("Teacher Role");
        // Check if the teacher has selected the courses they teaches
        if(authModel.teacherData?.courseTeaches == null || authModel.teacherData!.courseTeaches!.isEmpty){
          navigationController.getOffAll(RouteGenerator.addCoursesScreen);
        }else{
          navigationController.getOffAll(RouteGenerator.rootScreen);
        }
        return;
      }
      // The user is admin
      navigationController.getOffAll(RouteGenerator.rootScreen);
      return;

    }else{
      logout(context);
    }
  }

  Future<void> login(
      {required String phone,
      required String password,
      required bool rememberMe, required BuildContext context}) async {
    String fcmToken = await firebaseToken();

    var data = {"phone": phone, "password": password, "fcm_token": fcmToken};

    var response = await ApiService.request(ApiPaths.login,
        method: RequestMethod.POST, data: data);

    if (response != null) {
      if (response['status'] == 200) {
        // Logged in
        HiveDatabase.storeValue(HiveDatabase.loginCheck, rememberMe);
        HiveDatabase.storeValue(
            HiveDatabase.authToken, "Bearer ${response['token']}");

        await fetchProfile();

        // Navigate to root screen
        BaseHelper.showSnackBar(response['message']);
        afterAuthHandler(context);
      } else if (response['status'] == 400) {
        // Account Not Verified
        BaseHelper.showSnackBar(response['message']);
        navigationController.navigateToNamedWithArg(
            RouteGenerator.otpScreen, {'isVerification': true});
      } else {
        // Invalid credentials
        BaseHelper.showSnackBar(response['message']);
      }
    }
  }

  Future<void> register(
      {required bool isParent,
      required String fullName,
      required String email,
      required String password,
      required String phone,
      required String countryCode, required bool adminRights}) async {

    var data = {
      "admin": isParent ? false : adminRights,
      "role": 2,
      "full_name": fullName,
      "email": email,
      "password": password,
      "country_code": countryCode,
      "phone": phone,
      "verified": false,
    };

    var response = await ApiService.request(ApiPaths.register, method: RequestMethod.POST, data: data);

    if(response != null){

      if(response['status'] == 200){
        // Register successful
        BaseHelper.showSnackBar(response['message']);

        navigationController.navigateToNamedWithArg(RouteGenerator.otpScreen, {'isVerification' :true});

      }else{

        if(response['message'] == 'Please verify your account'){
          navigationController.navigateToNamedWithArg(RouteGenerator.otpScreen, {'isVerification' :true});
        }

        BaseHelper.showSnackBar(response['message']);
      }

    }

  }


  Future<void> fetchNotifications() async {

    var data = {
      "user_id" : authModel.user!.sId
    };

    var response = await ApiService.request(
      ApiPaths.userNotifications,
      method: RequestMethod.POST,
        data: data
    );

    if (response != null) {
      notificationsModel = NotificationsModel.fromJson(response);
      notifyListeners();
    }
  }

  Future<void> readNotification(String notificationId) async {
    var data = {
      "notification_id" : notificationId
    };

    var response = await ApiService.request(
        ApiPaths.updateNotificationStatus,
        method: RequestMethod.POST,
        data: data
    );

  }

  Future<void> verifyOtp(String completePhone, String code) async {
    var data = {
      "complete_phone" : completePhone,
      "code" : code,
    };

    var response = await ApiService.request(
        ApiPaths.verifyOtp,
        method: RequestMethod.POST,
        data: data
    );

    if(response != null){
      if(response['status'] == true){
        navigationController.getOffAll(RouteGenerator.loginScreen);
        BaseHelper.showSnackBar(response['message']);
      }else{
        BaseHelper.showSnackBar(response['message']);
      }
    }

  }

  Future<void> logout(BuildContext context) async {
    context.read<BottomNavBarVM>().advancedDrawerController.hideDrawer();
    context.read<BottomNavBarVM>().bottomNavBarController.index = 0;
    HiveDatabase.storeValue(HiveDatabase.authToken, null);
    HiveDatabase.storeValue(HiveDatabase.loginCheck, false);
    navigationController.getOffAll(RouteGenerator.loginScreen);
  }


}
