import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class AppPhoneTextField extends StatefulWidget {
  final bool isSignup;

  const AppPhoneTextField({Key? key, this.isSignup = false}) : super(key: key);

  @override
  State<AppPhoneTextField> createState() => _AppPhoneTextFieldState();
}

class _AppPhoneTextFieldState extends State<AppPhoneTextField> {
  String phoneText = '';

  @override
  Widget build(BuildContext context) {
    var authenticationScreenVM = context.watch<AuthenticationScreenVM>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntlPhoneField(
          flagsButtonPadding: EdgeInsets.symmetric(horizontal: 0.03.sw),
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: AppTheme.blackColor, textBaseline: TextBaseline.alphabetic),
          onSaved: (phone) {
            authenticationScreenVM.setPhoneNumber(phone);
          },
          invalidNumberMessage: "invalid_number".tr,
          validator: (str) async {
            authenticationScreenVM.setPhoneNumber(str);

            try {
              bool isValid = await BaseHelper.isPhoneNoValid(
                  authenticationScreenVM.phoneNumberWithoutCountryCode,
                  str?.countryISOCode ?? "",
                  "",
                  authenticationScreenVM.countryCode);

              if (authenticationScreenVM.phoneNumberWithoutCountryCode.isEmpty ||
                  authenticationScreenVM.phoneNumberWithoutCountryCode == '') {
                return "invalid_number".tr;
              }
              if (!isValid) {
                return "invalid_number".tr;
              }
              if (authenticationScreenVM.phoneNumberWithoutCountryCode.length ==
                  1) {
                return "invalid_number".tr;
              }
              if (authenticationScreenVM.phoneNumberWithoutCountryCode.trim() ==
                  '') {
                return "invalid_number".tr;
              }
              return null;
            } catch (e) {
              return "invalid_number".tr;
            }
          },
          disableLengthCheck: true,
          controller: authenticationScreenVM.phoneController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            suffixIcon: widget.isSignup
                ? authenticationScreenVM.phoneNumberCheckInProgress
                    ? const Icon(
                        Icons.sync,
                        color: AppTheme.primaryColor,
                      )
                    : const SizedBox.shrink()
                : const SizedBox.shrink(),
            fillColor: AppTheme.whiteColor,
            filled: true,
            labelText: 'phone_number'.tr,
            labelStyle: Theme.of(context).textTheme.bodyText1,
            floatingLabelStyle: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: AppTheme.primaryColor),
            border: const UnderlineInputBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            )),
            focusedBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(color: AppTheme.blackColor, width: 1.5),
            ),
            enabledBorder: UnderlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(color: AppTheme.fieldOutlineColor, width: 0.0),
            ),
          ),
          dropdownIcon: const Icon(
            Icons.expand_more,
            color: AppTheme.blackColor,
          ),
          initialCountryCode: 'IQ',
          onChanged: widget.isSignup
              ? (phone) {
                }
              : (phone) => debugPrint(phone.completeNumber),
          dropdownIconPosition: IconPosition.trailing,
          pickerDialogStyle: PickerDialogStyle(
              countryNameStyle: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(fontWeight: FontWeight.w500, fontSize: 14.sp),
              searchFieldInputDecoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.bodyText1,
                floatingLabelStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: AppTheme.primaryColor),
                hintText: "search_country".tr,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                )),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  borderSide: BorderSide(color: AppTheme.blackColor, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  borderSide:
                      BorderSide(color: AppTheme.fieldOutlineColor, width: 0.0),
                ),
              )),
        ),
        widget.isSignup && phoneText != '' ? const SizedBox(height: 2,) : const SizedBox.shrink(),
        widget.isSignup ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.sw),
          child: Text(phoneText.tr, style: Theme.of(context).textTheme.bodyText2?.copyWith(color: authenticationScreenVM.phoneNumberAvailable ? AppTheme.green : AppTheme.red),),
        ) : const SizedBox.shrink(),
      ],
    );
  }
}
