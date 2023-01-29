import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GridviewItemWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String imagePath;
  final String text;
  final Color color;
  const GridviewItemWidget({Key? key, required this.onTap, required this.imagePath, required this.text, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
        ),
        elevation: 10,
        color: color,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, height: 80,),
              SizedBox(
                height: 0.01.sh,
              ),
              Text(text, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}
