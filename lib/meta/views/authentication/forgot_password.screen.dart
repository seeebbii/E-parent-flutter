import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:flutter/material.dart';
import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_divider.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../components/widgets/app_phone_textfield.dart';
import '../../../components/widgets/app_simple_text_field.dart';

import '../../utils/app_sizes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  void _trySubmit() async {
    final isValid = context.read<AuthenticationScreenVM>().forgotPassFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(isValid){

    }
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationScreenVM authenticationScreenVM = context.watch<AuthenticationScreenVM>();
    return Scaffold(
      appBar: AppAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: AppSizes.height250,
              child: Image.asset(Assets.forgotPass),
            ),
            SizedBox(
              height: 0.02.sh,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width18),
              child: Form(
                key: authenticationScreenVM.forgotPassFormKey,
                child: Column(
                  children: [

                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text('Forgot password?',
                          style: Theme.of(context).textTheme.headline3),
                    ),

                    SizedBox(
                      height: 0.01.sh,
                    ),
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(
                          'Please enter your username, we will send OTP to your registered number.',
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    SizedBox(
                      height: 0.02.sh,
                    ),

                    const AppPhoneTextField(),
                    SizedBox(
                      height: 0.02.sh,
                    ),
                    Center(
                      child: AppElevatedButton(
                          width: 0.85.sw,
                          borderRadius: 22,
                          onPressed: _trySubmit,
                          buttonText: "Request OTP",
                          textColor: AppTheme.whiteColor,
                          buttonColor: AppTheme.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
