import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/material.dart';

class SmallElevatedIconButton extends StatelessWidget {
  final double width;
  final double buttonHeight;
  final VoidCallback? onPressed;
  final Color buttonColor;
  final double borderRadius;
  final Widget widget;
  bool? showElevation = false;

  SmallElevatedIconButton(
      {this.width = double.infinity,
      this.buttonHeight = 35,
      this.onPressed,
      this.buttonColor = AppTheme.primaryColor,
      this.borderRadius = 5,
      this.widget = const SizedBox.shrink(),
      this.showElevation});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            child: widget));
  }
}
