import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppDobTextField extends StatelessWidget {
  String text;
  bool attendance;
  bool diary;
  bool leave;
  AppDobTextField({Key? key, this.text = 'dob', this.attendance = false, this.diary = false, this.leave = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationScreenVM authenticationScreenVM =
    context.watch<AuthenticationScreenVM>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      child: TextFormField(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _showDatePicker(context, authenticationScreenVM, attendance, diary, leave);
        },
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.blackColor,
            ),
        controller: authenticationScreenVM.dobController,
        cursorWidth: 1,
        textInputAction: TextInputAction.done,
        onChanged: (str) {

        },
        decoration: InputDecoration(
          labelText: "*${"$text".tr}",
          hintText: "DD-MM-YYYY",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppTheme.primaryColor),
          floatingLabelStyle: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppTheme.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide:
            BorderSide(color: AppTheme.fieldOutlineColor, width: 1.5),
          ),
          hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
          suffixIcon: InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());

                _showDatePicker(context, authenticationScreenVM, attendance, diary, leave);
              },
              child: const Icon(
                Icons.calendar_today,
                color: AppTheme.blackColor,
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide:
            BorderSide(color: AppTheme.fieldOutlineColor, width: 1.5),
          ),
        ),
        obscureText: false,
        cursorColor: Colors.red.shade400,
        validator: (str) {},
      ),
    );
  }

  void _showDatePicker(BuildContext context, AuthenticationScreenVM authenticationScreenVM, bool attendance, bool diary, bool leave) {
    DatePicker.showDatePicker(
      context,
      maxTime: diary ?  DateTime.now().add(const Duration(days: 7)) : leave ? DateTime.now().add(const Duration(days: 30)) : DateTime.now(),
      currentTime: authenticationScreenVM.currentDob,
      minTime: diary ? DateTime.now().subtract(const Duration(days: 3))  : leave ? DateTime.now(): DateTime(1980, 1, 1),
      showTitleActions: true,
      // pickerModel: CustomPicker(currentTime: dob.toUtc(), locale: LocaleType.en, maxTime: DateTime.now(), minTime:  DateTime(1970, 1, 1)),
      theme: DatePickerTheme(
        doneStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: AppTheme.primaryColor),
      ),
      onChanged: (date) {
        authenticationScreenVM.updateDob(
            DateFormat("MM/dd/yyyy").format(date), date);
      },
      onConfirm: (date) {
        authenticationScreenVM.updateDob(DateFormat("MM/dd/yyyy").format(date), date);
        if(attendance){
          // Call Api
          context.read<ClassNotifier>().loadAttendanceFromDate(context);
        }
        if(diary){
          context.read<ClassNotifier>().viewDiaryByDate(context);
        }
      },
      // locale: Languages.getLocaleType(),
    );
  }
}
