import 'dart:developer';

import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class FirebaseDeepLinkHandler{
  FirebaseDynamicLinks firebaseDynamicLinks = FirebaseDynamicLinks.instance;

  void initDynamicLinks() async {
    firebaseDynamicLinks.onLink.listen((deepLinkData) {
      final Uri deepLink = deepLinkData.link;
      if(deepLink != null){
        // navigationController.goBack();
        handleDynamicLink(deepLink);
      }
    }, onError: (error){
      debugPrint("ERROR ON initDynamicLinks: $error");
    });
  }

  void handleDynamicLink(Uri uri){
    List<String> pathSegments = uri.pathSegments;
    log("Uri content: $uri");
    // Future.delayed(const Duration(seconds: 2), (){
    //   navigationController.navigateToNamedWithArg("/single-ad-screen", {'postId': int.parse(pathSegments[1].toString()),});
    // });
  }

  static Future<void> shortUrlGenerator({required String screenPath, required int postId,
    String? imagePath, required String title}) async{
    String url = "https://e_parent_kit.page.link";
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("$url$screenPath/$postId"),
      uriPrefix: url,
      androidParameters: const AndroidParameters(
        packageName: "com.e_parent_kit",
        minimumVersion: 0,
      ),
      // iosParameters: const IOSParameters(
      //   bundleId: "com.e_parent_kit",
      //   appStoreId: "123456789",
      //   minimumVersion: "0",
      // ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        imageUrl: imagePath != null ? Uri.parse(imagePath) : null,
      ),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    debugPrint("Dynamic url: ${dynamicLink.shortUrl}");
    Share.share("${dynamicLink.shortUrl}",);
  }

}