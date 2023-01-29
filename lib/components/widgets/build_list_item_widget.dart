import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildListItemWidget extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  Widget? subtitle;
  BuildListItemWidget({Key? key, required this.onTap, required this.text, this.subtitle}) : super(key: key);

  @override
  State<BuildListItemWidget> createState() => _BuildListItemWidgetState();
}

class _BuildListItemWidgetState extends State<BuildListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.01.sh),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
        ),
        tileColor: Colors.grey.shade200,
        onTap: widget.onTap,
        title: Text(widget.text,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(),),
        subtitle: widget.subtitle,
        trailing: Icon(CupertinoIcons.arrow_right_circle, color: AppTheme.primaryColor,),
      ),
    );
  }
}
