import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppElevatedButton extends StatelessWidget {
  final double width;
  double buttonHeight;
  final VoidCallback? onPressed;
  final String buttonText;
  final Color textColor;
  final Color buttonColor;
  final double borderRadius;
  bool? showElevation = false;

  AppElevatedButton(
      {Key? key,
      this.width = double.infinity,
      this.buttonHeight = 45,
      required this.onPressed,
      required this.buttonText,
      required this.textColor,
      required this.buttonColor,
      this.borderRadius = 12,
      this.showElevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: buttonHeight,
        child: ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  backgroundColor: MaterialStateProperty.all(buttonColor),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius))),
                  shadowColor:
                      MaterialStateProperty.all<Color>(AppTheme.primaryColor),
                  elevation: showElevation ?? false
                      ? MaterialStateProperty.all(5)
                      : null,
                ),
            onPressed: onPressed,
            child: Text(
              buttonText.tr,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp),
            )));
  }
}
