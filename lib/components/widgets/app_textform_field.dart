import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextFormField extends StatefulWidget {
  final TextEditingController controller;
  String? hintText;

  bool obSecureText;
  dynamic validator;
  dynamic onChanged;
  TextInputAction action;
  TextInputType keyType;

  Widget suffixIcon;
  List<TextInputFormatter>? formatter;

  AutovalidateMode? validateMode = AutovalidateMode.always;

  AppTextFormField({
    Key? key,
    required this.controller,
    required this.obSecureText,
    required this.validator,
    required this.onChanged,
    required this.action,
    required this.keyType,
    this.suffixIcon = const SizedBox.shrink(),
    this.hintText,
    this.formatter = const [],
    this.validateMode = AutovalidateMode.disabled,
  }) : super(key: key);

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyText1?.copyWith(color: AppTheme.blackColor,  textBaseline: TextBaseline.alphabetic),
        controller: widget.controller,
        cursorWidth: 1,
        textInputAction: widget.action,
        keyboardType: widget.keyType,
        autovalidateMode: widget.validateMode,
        inputFormatters: widget.formatter,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.hintText,
          hintText: widget.hintText,
          labelStyle: Theme.of(context).textTheme.bodyText1,
          floatingLabelStyle: Theme.of(context).textTheme.bodyText1?.copyWith(color: AppTheme.primaryColor),
          border: InputBorder.none,
          hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
          suffixIcon: widget.suffixIcon,
          focusedBorder:  UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.0.sp),
          ),
          errorBorder:  const UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.errorColor, width: 1.0),
          ),
          enabledBorder:  UnderlineInputBorder(
            borderSide: BorderSide(color:  AppTheme.textFieldUnderline, width: 1.0.sp),
          ),
        ),
        obscureText: widget.obSecureText,
        cursorColor: Colors.red.shade400,
        validator: widget.validator,
      ),
    );
  }
}
