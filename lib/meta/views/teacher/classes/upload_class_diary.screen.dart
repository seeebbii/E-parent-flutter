import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_divider.dart';
import 'package:e_parent_kit/components/widgets/app_dob_textfield.dart';
import 'package:e_parent_kit/components/widgets/app_dropdown.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/components/widgets/app_simple_text_field.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/class/class.model.dart';
import 'package:e_parent_kit/core/models/teacherr/all_teachers.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/meta/utils/app_sizes.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/create_class.screen.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/manage_class.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UploadClassDiaryScreen extends StatefulWidget {
  const UploadClassDiaryScreen({Key? key}) : super(key: key);

  @override
  State<UploadClassDiaryScreen> createState() => _UploadClassDiaryScreenState();
}

class _UploadClassDiaryScreenState extends State<UploadClassDiaryScreen> {

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(
        const Duration(
          milliseconds: 500,
        ), () {
      context.read<ClassNotifier>().setDateAndDiaryController(context);
    });
    super.initState();
  }

  void _trySubmit() async {

    if (context
        .read<AuthenticationScreenVM>()
        .dobController
        .text
        .trim()
        .isEmpty) {
      return BaseHelper.showSnackBar("Please select diary date");
    }

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(isValid){
      EasyLoading.show();

      await context.read<ClassNotifier>().uploadClassDiary(context);

      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    ClassNotifier classNotifier = context.watch<ClassNotifier>();
    return Scaffold(
      appBar: AppAppbar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 0.01.sh,
                ),
                Row(
                  children: [
                    Text('Select Diary date',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 0.02.sw,
                    ),
                    Expanded(
                        child: AppDobTextField(
                      text: "Current Date",
                      diary: true,
                    )),
                  ],
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                TextFormField(
                    validator: (str) {
                      if (str == null || str.isEmpty) {
                        return ("Cannot_be_empty".tr);
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    maxLength: 350,
                    controller: classNotifier.diaryController,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontSize: 17.sp),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: AppSizes.height10, horizontal: AppSizes.width8),
                      fillColor: AppTheme.whiteColor,
                      filled: true,
                      border: const UnderlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      labelText:
                          "Daily Diary: ${classNotifier.selectedClass.grade}${classNotifier.selectedClass.section}",
                      hintText: 'Maths: Quiz of Chapter 1\nUrdu: Assignment due on 6th January, 202\nEnglish: Quiz of Chapter 2 & Chapter 3',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodySmall,
                      labelStyle: Theme.of(context).textTheme.headline2?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold),
                      floatingLabelStyle: Theme.of(context)
                          .textTheme
                          .headline2
                          ?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold),
                      // labelText: fieldNameText,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    )),
                SizedBox(
                  height: 0.03.sh,
                ),
                AppElevatedButton(
                    onPressed: _trySubmit,
                    buttonText: "Upload Diary",
                    textColor: AppTheme.whiteColor,
                    buttonColor: AppTheme.primaryColor)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
