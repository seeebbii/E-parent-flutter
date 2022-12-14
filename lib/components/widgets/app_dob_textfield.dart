import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppDobTextField extends StatelessWidget {
  const AppDobTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationScreenVM authenticationScreenVM =
        context.watch<AuthenticationScreenVM>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      child: TextFormField(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _showDatePicker(context, authenticationScreenVM);
        },
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: AppTheme.blackColor,
            ),
        controller: authenticationScreenVM.dobController,
        cursorWidth: 1,
        textInputAction: TextInputAction.done,
        onChanged: (str) {},
        decoration: InputDecoration(
          labelText: "*${"dob".tr}",
          hintText: "DD-MM-YYYY",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: AppTheme.primaryColor),
          floatingLabelStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: AppTheme.primaryColor),
          border: InputBorder.none,
          hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
          suffixIcon: InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());

                _showDatePicker(context, authenticationScreenVM);
              },
              child: const Icon(
                Icons.calendar_today,
                color: AppTheme.blackColor,
              )),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.0.sp),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppTheme.errorColor, width: 1.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: AppTheme.textFieldUnderline, width: 1.0.sp),
          ),
        ),
        obscureText: false,
        cursorColor: Colors.red.shade400,
        validator: (str) {},
      ),
    );
  }

  void _showDatePicker(context, AuthenticationScreenVM authenticationScreenVM) {
    DatePicker.showDatePicker(
      context,
      maxTime: DateTime.now(),
      currentTime: authenticationScreenVM.currentDob,
      minTime: DateTime(1980, 1, 1),
      showTitleActions: true,
      // pickerModel: CustomPicker(currentTime: dob.toUtc(), locale: LocaleType.en, maxTime: DateTime.now(), minTime:  DateTime(1970, 1, 1)),
      theme: DatePickerTheme(
        doneStyle: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: AppTheme.primaryColor),
      ),
      onChanged: (date) {
        authenticationScreenVM.updateDob(
            DateFormat("dd-MM-yyyy").format(date), date);
      },
      onConfirm: (date) {
        authenticationScreenVM.updateDob(
            DateFormat("dd-MM-yyyy").format(date), date);
      },
      // locale: Languages.getLocaleType(),
    );
  }
}
