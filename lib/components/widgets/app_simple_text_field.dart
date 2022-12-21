

import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/view_models/authentication_VM.dart';



class AppSimpleTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  // final String fieldNameText;
  final bool isEmail;
  final bool isName;
  final bool isPhone;
  final bool isPass;
  final bool isRePass;
  final bool isReadOnly;
  final bool isOptional;
  final int minLength;
  final int maxLength;
  final IconData prefixIcon;
  final TextInputType keyboard;
  final String validationMsg;
  VoidCallback? onTap;

  AppSimpleTextField(
      {Key? key,
      required this.controller,
      this.hintText = '',
      // required this.fieldNameText,
      this.isEmail = false,
      this.isName = false,
      this.isPhone = false,
      this.isPass = false,
      this.isRePass = false,
      this.isReadOnly = false,
      this.isOptional = false,
      this.minLength = 1,
      this.maxLength = 1,
      required this.prefixIcon,
      required this.keyboard,
        this.onTap,
      this.validationMsg = 'required_field_tr'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loginScreenVM = context.watch<AuthenticationScreenVM>();
    // var forgotPassVM = context.watch<ForgotPassScreenVM>();
    bool isEmailValid(String value) {
      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
      return emailValid;
    }

    return TextFormField(
      onTap: onTap,
        minLines: minLength,
        maxLines: maxLength,
        readOnly: isReadOnly,
        validator: isOptional != true
            ? (value) {
                if (value == null || value.isEmpty) {
                  return validationMsg;
                }
                else if (isEmail) {
                  if (!isEmailValid(value)) {
                    return ('Email is not valid!');
                  }
                }
                else if (isName) {
                  if (value.length < 10) {
                    return ('Name characters should be less then 10');
                  }
                }
                else if (isPass) {
                  if (value.length < 8) {
                    return ('Password should at least 8 characters!');
                  }else if(isRePass){
                    if (loginScreenVM.passwordController.text != loginScreenVM.rePasswordController.text) {
                    return ('Passwords should be same!');
                  }
                  }
                }
                else if (isPhone) {
                  if (value.length != 11) {
                    return ('Phone must be 11 digits!');
                  }
                }
                return null;
              }
            : (value) {
                return null;
              },
        textInputAction: TextInputAction.done,
        keyboardType: keyboard,
        controller: controller,
        obscureText: isPass
            ? loginScreenVM.isPassVisible
            : isRePass
            ? loginScreenVM.isRePassVisible
            : false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          fillColor: AppTheme.whiteColor,
          filled: true,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 1.5),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
            borderSide: BorderSide(color: Colors.black, width: 0.0),
          ),
          hintText: hintText,
          // labelText: fieldNameText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(
              height: 0.7,
              color: Colors.black,
              // fontSize: size.height * 0.022,
              fontWeight: FontWeight.normal),
          prefixIcon: Icon(
            prefixIcon,
            color: AppTheme.black.withOpacity(0.5),
            size: 18,
          ),
          suffixIcon: isPass
              ? IconButton(
                  onPressed: () => loginScreenVM.setPassVisibility(),
                  icon: Icon(
                    loginScreenVM.isPassVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppTheme.black.withOpacity(0.5),
                    size: 18,
                  ),
                )
              : isRePass
              ? IconButton(
              onPressed: () => loginScreenVM.setRePassVisibility(),
              icon: Icon(
                loginScreenVM.isRePassVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppTheme.black.withOpacity(0.5),
                size: 18,
              ))
              : null,
        ));
  }
}
