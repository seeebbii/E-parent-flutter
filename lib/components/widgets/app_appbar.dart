import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/constants/controller.constant.dart';

class AppAppbar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  bool isTitleText;
  Widget titleWidget;
  bool leading;
  bool centerTitle;
  Color bgColor;
  List<Widget> actions;
  Widget flexibleSpace;
  final double toolbarHeight;
  double elevation;

  AppAppbar(
      {Key? key,
      this.title,
      this.bgColor = AppTheme.whiteColor,
      this.leading = true,
      this.centerTitle = false,
      this.actions = const <Widget>[],
      this.isTitleText = true,
      this.titleWidget = const SizedBox.shrink(),
      this.toolbarHeight = kToolbarHeight,
      this.flexibleSpace = const SizedBox.shrink(),
      this.elevation = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: AppTheme.blackColor,
      ),
      elevation: elevation,
      automaticallyImplyLeading: leading,
      centerTitle: centerTitle,
      backgroundColor: bgColor,
      toolbarHeight: toolbarHeight,
      flexibleSpace: flexibleSpace,
      title: title != null && isTitleText
          ? Text("$title",
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  ?.copyWith(fontWeight: FontWeight.bold))
          : titleWidget,
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
