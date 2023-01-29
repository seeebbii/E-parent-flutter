import 'dart:core';
import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phone_number/phone_number.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_theme.dart';

class BaseHelper {
  static var emailValidate = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  static void showSnackBar(String message) {
    if (!Get.isSnackbarOpen) {
      Get.showSnackbar(
        GetSnackBar(
          message: message,
          isDismissible: true,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  static void openDialPad(String phoneNumber) async {
    if (!await launch("tel:$phoneNumber")) {
      throw 'Could not launch $phoneNumber';
    }
  }

  static void launchUrl(String url) async {
    if (!await launch(url)) {
      throw 'Could not launch $url';
    }
  }

  // CACHE NETWORK WIDGET HERE
  static Widget loadNetworkImage(String url, BoxFit fit, {double? height}) {
    return CachedNetworkImage(
      imageUrl: url,
      fadeInCurve: Curves.easeIn,
      fit: fit,
      height: height,
      fadeInDuration: const Duration(milliseconds: 500),
      placeholder: (st_, str) {
        return Container(
          height: 0.5.sh,
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage(Assets.logo), fit: BoxFit.contain),
          ),
        );
      },
      errorWidget: (context, url, error) =>
      const Center(
          child: Icon(
            Icons.error,
            color: Colors.black,
          )),
    );
  }

  static Widget loadProfilePictureOnPost(String url,
      {double? height = 36.0, double? width = 36.0}) {
    return CachedNetworkImage(
      imageUrl: url ?? '',
      fadeInDuration: const Duration(milliseconds: 500),
      fadeInCurve: Curves.easeIn,
      imageBuilder: (context, imageProvider) =>
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
      errorWidget: (context, url, error) =>
      const Center(
          child: Icon(
            Icons.error,
            color: Colors.black,
          )),
    );
  }

  static CachedNetworkImageProvider loadNetworkImageObject(String url,) {
    return CachedNetworkImageProvider(url, errorListener: () {
      debugPrint("ERROR LOADING IMAGE");
    });
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat.yMd().format(dateTime);
  }

  static String formatDateWithMonth(DateTime dateTime) {
    return DateFormat.yMMMd().format(dateTime);
  }

  static String appFormatDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  static Future<bool> isPhoneNoValid(String number, String code, String name,
      String prefix) async {
    PhoneNumberUtil plugin = PhoneNumberUtil();
    String springFieldUSASimpleNoRegion = number;
    RegionInfo region = RegionInfo(
        code: code, name: 'United States', prefix: int.parse(prefix));
    bool isValid =
    await plugin.validate(springFieldUSASimpleNoRegion, region.code);
    return isValid;
  }

  static RegExp numberFormatterRegEx = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  static String Function(Match) mathFunc = (Match match) => '${match[1]},';

  static String formatNumber({required String number}) {
    return number.replaceAllMapped(numberFormatterRegEx, mathFunc);
  }

  static AlertDialog confirmationDialog({required BuildContext context,
    required VoidCallback onConfirm, required String alertText}) {
    return AlertDialog(
      title: Text(alertText, style: Theme.of(context).textTheme.displaySmall,),
      actions: [
      TextButton(
          style: TextButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            foregroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color:  AppTheme.primaryColor,
                  width: 0.5,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8)
            ),
          ),
          onPressed: () => navigationController.goBack(),
          child: Text(
            "Cancel",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.primaryColor),
          ),
        ),
        ElevatedButton(onPressed: onConfirm, child: Text('Confirm', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.whiteColor),),),
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
    );
  }
}
