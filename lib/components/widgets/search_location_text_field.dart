import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/material.dart';


class SearchLocationTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int minLength;
  final int maxLength;
  final IconData prefixIcon;
  final Function(String) onChange;

  const SearchLocationTextField(
      {Key? key,
      required this.controller,
      this.hintText = '',
      this.minLength = 1,
      this.maxLength = 1,
      required this.prefixIcon,
      required this.onChange,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.whiteColor,
      child: TextField(
        controller: controller,
        decoration:  InputDecoration(border: const OutlineInputBorder(),
          prefixIcon: Icon(prefixIcon,color: Colors.grey,),
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          fillColor: AppTheme.fieldTextColor,
        ),
        onChanged: onChange,

      ),
    );
  }
}
