import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppSmallElevatedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String buttonText;
  const AppSmallElevatedButton({Key? key, required this.onTap, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 0.01.sh, vertical: 0.01.sh),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            onPrimary: AppTheme.primaryColor,
            primary: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            )
        ),
        child: Text(
          buttonText.tr,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppTheme.whiteColor),
        ),
      ),
    );
  }
}
