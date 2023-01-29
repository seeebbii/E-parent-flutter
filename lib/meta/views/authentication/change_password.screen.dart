import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../components/widgets/app_phone_textfield.dart';
import '../../../components/widgets/app_simple_text_field.dart';
import '../../../core/view_models/authentication_VM.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {


  void _trySubmit() async {
    AuthenticationScreenVM authVM = Provider.of(context, listen: false);
    final isValid = context
        .read<AuthenticationScreenVM>()
        .signupFormKey
        .currentState!
        .validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      EasyLoading.show();

      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationScreenVM authenticationScreenVM = context.watch<
        AuthenticationScreenVM>();
    return Scaffold(
      appBar: AppAppbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
          child: Form(
            key: authenticationScreenVM.signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.logo,
                      height: 60,
                    )
                  ],
                ),
                SizedBox(
                  height: 0.02.sh,
                ),
                Text(
                  "Change Password",
                  style: Theme
                      .of(context)
                      .textTheme
                      .displayLarge,
                ),
                SizedBox(
                  height: 0.05.sh,
                ),
                AppSimpleTextField(
                  controller: authenticationScreenVM.passwordController,
                  keyboard: TextInputType.text,
                  hintText: 'Enter your password',
                  validationMsg: 'Please enter your password',
                  isPass: true,
                  isOptional: false,
                  onChange: (str) {},
                  prefixIcon: CupertinoIcons.lock,
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                AppSimpleTextField(
                  controller: authenticationScreenVM.rePasswordController,
                  keyboard: TextInputType.text,
                  hintText: 'Re-Enter your password',
                  validationMsg: 'Please enter your password',
                  isPass: true,
                  isRePass: true,
                  isOptional: false,
                  onChange: (str) {},
                  prefixIcon: CupertinoIcons.lock,
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                Center(
                  child: AppElevatedButton(
                      width: 0.85.sw,
                      borderRadius: 22,
                      onPressed: _trySubmit,
                      buttonText: "Change Password",
                      textColor: AppTheme.whiteColor,
                      buttonColor: AppTheme.primaryColor),
                ),
                SizedBox(
                  height: 0.02.sh,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}