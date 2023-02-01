import 'dart:async';

import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/components/widgets/otp_text_fields.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  // if the purpose of screen is to change password or verify user
  final bool isVerification;

  const OtpScreen({Key? key, required this.isVerification}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType> otpErrorController =
      StreamController<ErrorAnimationType>();

  void _trySubmit() async {
    final isValid = context
        .read<AuthenticationScreenVM>()
        .otpFormKey
        .currentState!
        .validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      // Verify OTP request
      EasyLoading.show();

      await context.read<AuthenticationNotifier>().verifyOtp(
          "${context.read<AuthenticationScreenVM>().countryCode}${context.read<AuthenticationScreenVM>().phoneNumberWithoutCountryCode}",
          otpController.text.trim(), widget.isVerification);

      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationScreenVM authVm = context.watch<AuthenticationScreenVM>();
    return Scaffold(
      appBar: AppAppbar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  /// enter OTP text
                  Align(
                    alignment: FractionalOffset.topLeft,
                    child: Text(
                      'OTP Verification',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),

                  SizedBox(
                    height: 0.03.sh,
                  ),

                  Align(
                    alignment: FractionalOffset.topLeft,
                    child: Text(
                      'Please enter the 6 digit code sent to your phone number',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),

                  SizedBox(
                    height: 0.05.sh,
                  ),

                  Form(
                      key: authVm.otpFormKey,
                      child: OTPTextField(
                        otpController: otpController,
                        errorAnimationController: otpErrorController,
                      )),

                  SizedBox(
                    height: 0.03.sh,
                  ),

                  Center(
                    child: AppElevatedButton(
                        width: 0.85.sw,
                        borderRadius: 22,
                        onPressed: _trySubmit,
                        buttonText: "Verify OTP",
                        textColor: AppTheme.whiteColor,
                        buttonColor: AppTheme.primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
