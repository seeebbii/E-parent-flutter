import 'dart:async';

import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';


class OTPTextField extends StatelessWidget {
  final StreamController<ErrorAnimationType> errorAnimationController;
  final TextEditingController otpController;
  const OTPTextField({Key? key, required this.errorAnimationController, required this.otpController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: PinCodeTextField(
        appContext: context,
        pastedTextStyle: TextStyle(
          color: Colors.green.shade600,
          fontWeight: FontWeight.bold,
        ),
        length: 6,
        validator: (str) {
          if (str!.length < 6) {
            return "Invalid OTP";
          } else {
            return null;
          }
        },
        obscureText: false,
        obscuringCharacter: '*',
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
        useExternalAutoFillGroup: true,
        pinTheme: PinTheme(
          borderRadius: BorderRadius.circular(10),
          selectedColor: AppTheme.primaryColor,
          shape: PinCodeFieldShape.box,
        ),
        cursorColor: AppTheme.primaryColor,
        animationDuration: const Duration(milliseconds: 300),
        errorAnimationController: errorAnimationController,
        controller: otpController,
        keyboardType: TextInputType.number,
        textStyle: Theme.of(context)
            .textTheme
            .displaySmall
            ?.copyWith(fontWeight: FontWeight.bold),
        onCompleted: (v) {
          debugPrint("Completed");
        },
        // onTap: () {
        //   print("Pressed");
        // },
        onChanged: (value) {
          debugPrint(value);
        },
        beforeTextPaste: (text) {
          debugPrint("Allowing to paste $text");
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return true;
        },
      ),
    );
  }
}

