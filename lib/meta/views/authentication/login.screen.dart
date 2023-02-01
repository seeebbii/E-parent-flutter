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
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../components/widgets/app_phone_textfield.dart';
import '../../../components/widgets/app_simple_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _trySubmit() async {

    print(DateTime.now().toIso8601String());
    AuthenticationScreenVM authVm =
        Provider.of<AuthenticationScreenVM>(context, listen: false);

    final isValid = context
        .read<AuthenticationScreenVM>()
        .loginFormKey
        .currentState!
        .validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      EasyLoading.show();

      await context.read<AuthenticationNotifier>().login(
          phone: authVm.countryCode + authVm.phoneController.text.trim(),
          password: authVm.passwordController.text.trim(),
          rememberMe: authVm.keepLoggedIn, context: context);

      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationScreenVM authenticationScreenVM =
        context.watch<AuthenticationScreenVM>();
    return Scaffold(
      appBar: AppAppbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
          child: Form(
            key: authenticationScreenVM.loginFormKey,
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
                  "E Parent School Kit",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(
                  height: 0.05.sh,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.02.sw),
                  child: CheckboxListTile(
                    checkboxShape: const CircleBorder(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "keep_logged_in".tr,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppTheme.blackColor),
                    ),
                    value: authenticationScreenVM.keepLoggedIn,
                    checkColor: AppTheme.whiteColor,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (bool? newValue) {
                      authenticationScreenVM
                          .updateKeepLoggedIn(newValue ?? false);
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
                      buttonText: "Login",
                      textColor: AppTheme.whiteColor,
                      buttonColor: AppTheme.primaryColor),
                ),
                SizedBox(
                  height: 0.02.sh,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => navigationController.navigateToNamed(
                      RouteGenerator.forgotPasswordScreen,
                    ),
                    child: Text(
                      "forgot_password".tr,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppTheme.primaryColor),
                    ),
                  ),
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
                    text: 'dont_have_an_account'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppTheme.blackColor),
                    children: [
                      TextSpan(
                          text: 'signup'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              navigationController.navigateToNamedWithArg(
                                  RouteGenerator.signupScreen,
                                  {'isParent': true});
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
