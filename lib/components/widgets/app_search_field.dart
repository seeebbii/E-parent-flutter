import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<TextInputFormatter>? inputFormatters;
  VoidCallback? onTap = () {};
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
      this.type = TextInputType.name,
      this.onTap,
      this.inputFormatters,
      this.validator})
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
        style: Theme.of(context).textTheme.bodyLarge,
        obscureText: false,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          isDense: true,
          fillColor: AppTheme.textFieldFillColor,
          filled: true,
          hintText: hintText,
          hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
          prefixIcon: showPrefix!
              ? const Icon(
                  CupertinoIcons.search,
                  color: AppTheme.blackColor,
                  size: 28,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide:
                BorderSide(color: AppTheme.fieldOutlineColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide:
                BorderSide(color: AppTheme.fieldOutlineColor, width: 1.5),
          ),
          suffixIcon: suffixIcon,
        ),
        validator: validator ??
            (val) {
              if (val!.isEmpty) {
                return 'required'.tr;
              }
              return null;
            },
      ),
    );
  }
}
