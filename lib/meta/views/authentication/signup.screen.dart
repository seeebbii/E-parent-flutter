import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_divider.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../components/widgets/app_phone_textfield.dart';
import '../../../components/widgets/app_simple_text_field.dart';

class SignupScreen extends StatefulWidget {
  final bool isParent;

  const SignupScreen({Key? key, this.isParent = true}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

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
      print(authVM.phoneNumberWithoutCountryCode);

      await context.read<AuthenticationNotifier>().register(isParent: widget.isParent,
          fullName: authVM.nameController.text.trim(),
          email: authVM.emailController.text.trim(),
          password: authVM.passwordController.text.trim(),
          phone: authVM.phoneNumberWithoutCountryCode,
          countryCode: authVM.countryCode,
          adminRights: authVM.adminRights);

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
                  widget.isParent
                      ? "Register as a Parent"
                      : "Register as a Teacher",
                  style: Theme
                      .of(context)
                      .textTheme
                      .displayLarge,
                ),
                SizedBox(
                  height: 0.05.sh,
                ),
                AppSimpleTextField(
                  controller: authenticationScreenVM.emailController,
                  keyboard: TextInputType.text,
                  hintText: 'Enter your email',
                  validationMsg: 'Please enter your email',
                  isEmail: true,
                  isOptional: false,
                  onChange: (str) {},
                  prefixIcon: CupertinoIcons.mail,
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                AppSimpleTextField(
                  controller: authenticationScreenVM.nameController,
                  keyboard: TextInputType.text,
                  hintText: 'Enter your full name',
                  validationMsg: 'Please enter your full name',
                  isName: true,
                  isEmail: false,
                  isOptional: false,
                  onChange: (str) {},
                  prefixIcon: CupertinoIcons.person,

                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                  ],
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                const AppPhoneTextField(),
                SizedBox(
                  height: 0.01.sh,
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
                  validationMsg: 'Password does not match',
                  isPass: true,
                  isRePass: true,
                  isOptional: false,
                  onChange: (str) {},
                  prefixIcon: CupertinoIcons.lock,
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                widget.isParent ? const SizedBox.shrink() : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.02.sw),
                  child: CheckboxListTile(
                    checkboxShape: const CircleBorder(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Admin Rights".tr,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppTheme.blackColor),
                    ),
                    value: authenticationScreenVM.adminRights,
                    checkColor: AppTheme.whiteColor,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (bool? newValue) {
                      authenticationScreenVM.updateAdminRights(
                          newValue ?? false);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                Center(
                  child: AppElevatedButton(
                      width: 0.85.sw,
                      borderRadius: 22,
                      onPressed: _trySubmit,
                      buttonText: "Register",
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
      bottomNavigationBar: SizedBox(
        height: 0.05.sh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: RichText(
                text: TextSpan(
                    text: 'Already have an account?',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppTheme.blackColor),
                    children: [
                      TextSpan(
                          text: ' Login',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              navigationController.goBack();
                            })
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
