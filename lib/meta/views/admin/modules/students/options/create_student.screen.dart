import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/components/widgets/app_dob_textfield.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/components/widgets/app_phone_textfield.dart';
import 'package:e_parent_kit/components/widgets/app_simple_text_field.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
import 'package:e_parent_kit/core/models/course/select_course.model.dart';
import 'package:e_parent_kit/core/models/notification/notifications.model.dart';
import 'package:e_parent_kit/core/models/student/select_student.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/notifiers/student.notifier.dart';
import 'package:e_parent_kit/core/notifiers/teacher.notifier.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/utils/time_ago.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'view_all_classes.screen.dart';

class CreateStudentScreen extends StatefulWidget {
  const CreateStudentScreen({Key? key}) : super(key: key);

  @override
  State<CreateStudentScreen> createState() => _CreateStudentScreenState();
}

class _CreateStudentScreenState extends State<CreateStudentScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _trySubmit() async {
    StudentNotifier studentNotifier =
        Provider.of<StudentNotifier>(context, listen: false);
    AuthenticationScreenVM authVm =
        Provider.of<AuthenticationScreenVM>(context, listen: false);
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(context.read<ClassNotifier>().selectedClass.sId == null){
      BaseHelper.showSnackBar("Please select student's class");
      return;
    }

    if(authVm.dobController.text.trim().isEmpty){
      BaseHelper.showSnackBar("DOB Missing");
      return;
    }


    if (isValid) {
      EasyLoading.show();
      await studentNotifier.createStudent(
        fullName: fullNameController.text.trim(),
        phone: "${authVm.countryCode}${authVm.phoneNumberWithoutCountryCode}",
        dob: authVm.dobController.text.trim(),
        classId: context.read<ClassNotifier>().selectedClass.sId!
      );
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    ClassNotifier classNotifier = context.watch<ClassNotifier>();
    return Scaffold(
      appBar: AppAppbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 0.01.sh,
                ),
                Text(
                  "Create Student",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                AppSimpleTextField(
                  controller: fullNameController,
                  keyboard: TextInputType.text,
                  hintText: 'Enter full name',
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
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: (){
                    Get.to(() => ViewAllClassesScreen());
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: AppSimpleTextField(
                          enabled: false,
                          controller: classNotifier.selectedClass.grade != null ? TextEditingController(text: classNotifier.selectedClass.grade.toString()) : TextEditingController(text:''),
                          keyboard: TextInputType.phone,
                          hintText: 'Enter Grade',
                          validationMsg: 'Please enter Grade',
                          maxLength: 2,
                          isPhone: false,
                          isOptional: false,
                          onChange: (str) {},
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[1-9]")),
                          ],
                          prefixIcon: CupertinoIcons.book,
                        ),
                      ),
                      SizedBox(
                        width: 0.03.sw,
                      ),
                      Expanded(
                        child: AppSimpleTextField(
                          enabled: false,
                          controller:  classNotifier.selectedClass.section != null ? TextEditingController(text: classNotifier.selectedClass.section.toString()) : TextEditingController(text:''),
                          textInputAction: TextInputAction.done,
                          keyboard: TextInputType.text,
                          hintText: 'Enter Section',
                          validationMsg: 'Please enter Section',
                          maxLength: 1,
                          isPhone: false,
                          isOptional: false,
                          onChange: (str) {},
                          onTap: (){
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          prefixIcon: CupertinoIcons.dot_square,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-z A-Z]")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                const AppDobTextField(),
                SizedBox(
                  height: 0.03.sh,
                ),
                AppElevatedButton(
                    onPressed: _trySubmit,
                    buttonText: "Confirm",
                    textColor: AppTheme.whiteColor,
                    buttonColor: AppTheme.primaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
