import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppSearchTextField extends StatelessWidget {
  final TextEditingController searchController;
  final String hintText;
  final dynamic onChange;
  Widget? suffixIcon;
  bool? showPrefix;
  int? maxLines;
  int? length;
  TextInputType? type;
  VoidCallback? onTap = (){};
  dynamic validator;

  AppSearchTextField(
      {Key? key,
      required this.searchController,
      required this.hintText,
      required this.onChange,
      this.suffixIcon = const SizedBox.shrink(),
      this.showPrefix = true,
      this.maxLines,
      this.length,
      this.type = TextInputType.name, this.onTap, this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: maxLines == null ? 50 : null,
      child: TextFormField(
        keyboardType: type,
        onChanged: onChange,
        onTap: onTap,
        maxLines: maxLines,
        maxLength: length,
        controller: searchController,
        style: Theme.of(context).textTheme.bodyText1,
        obscureText: false,
        decoration: InputDecoration(
          isDense: true,
          fillColor: AppTheme.hintColor.withOpacity(0.2),
          filled: true,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyText1,
          prefixIcon: showPrefix!
              ? const Icon(
                  Icons.search,
                  color: AppTheme.blackColor,
                  size: 28,
                )
              : null,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          suffixIcon: suffixIcon,
        ),
        validator: validator ?? (val) {
          if (val!.isEmpty) {
            return 'required'.tr;
          }
          return null;
        },
      ),
    );
  }
}
