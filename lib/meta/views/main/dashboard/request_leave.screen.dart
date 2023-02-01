import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_dob_textfield.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/class/class.model.dart';
import 'package:e_parent_kit/core/models/teacherr/all_teachers.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/meta/utils/app_sizes.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/create_class.screen.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/manage_class.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RequestLeaveScreen extends StatefulWidget {
  const RequestLeaveScreen({Key? key}) : super(key: key);

  @override
  State<RequestLeaveScreen> createState() => _RequestLeaveScreenState();
}

class _RequestLeaveScreenState extends State<RequestLeaveScreen> {
  final TextEditingController reasonController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(
        const Duration(
          milliseconds: 500,
        ), () {
      context.read<ClassNotifier>().resetDate(context);
    });
    super.initState();
  }

  void _trySubmit() async {
    ClassNotifier classNotifier =
        Provider.of<ClassNotifier>(context, listen: false);
    AuthenticationNotifier authenticationNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);
    ParentNotifier parentNotifier =
        Provider.of<ParentNotifier>(context, listen: false);

    if (context
        .read<AuthenticationScreenVM>()
        .dobController
        .text
        .trim()
        .isEmpty) {
      return BaseHelper.showSnackBar("Please select leave date");
    }

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      EasyLoading.show();

      await context.read<ParentNotifier>().requestLeave(
          parentId: authenticationNotifier.authModel.user!.sId!,
          teacherId: parentNotifier
              .selectedStudentProfile!.classModel!.classTeacher!.sId!,
          studentId: parentNotifier.selectedStudentProfile!.sId!,
          classId: parentNotifier.selectedStudentProfile!.classModel!.sId!,
          reason: reasonController.text.trim(),
          context: context);

      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    ParentNotifier parentNotifier = context.watch<ParentNotifier>();
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
                    Text('Select date of leave',
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
                          leave: true
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
                    maxLines: 8,
                    maxLength: 150,
                    controller: reasonController,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontSize: 17.sp),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: AppSizes.height10,
                          horizontal: AppSizes.width8),
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
                      labelText: "Reason of leave",
                      hintText: 'Your reason of leave for ${parentNotifier.selectedStudentProfile?.fullName} here...',
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .headline2
                          ?.copyWith(
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
                    buttonText: "Request a leave",
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
