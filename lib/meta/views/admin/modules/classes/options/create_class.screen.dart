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
import 'package:e_parent_kit/core/notifiers/course.notifier.dart';
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

import 'assign_class_teacher.screen.dart';

class CreateClassScreen extends StatefulWidget {
  const CreateClassScreen({Key? key}) : super(key: key);

  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  TextEditingController gradeController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _trySubmit() async {
    ClassNotifier classNotifier = Provider.of<ClassNotifier>(context, listen: false);
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(classNotifier.teacherAssigned.user?.sId == null){
      BaseHelper.showSnackBar("Please assign a class teacher");
      return;
    }

    if (isValid) {
      EasyLoading.show();

      await classNotifier.createClass(
        grade: int.parse(gradeController.text.trim()),
        section: sectionController.text.trim().toUpperCase(),
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
                  "Create Class",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppSimpleTextField(
                        controller: gradeController,
                        keyboard: TextInputType.phone,
                        hintText: 'Enter Grade',
                        validationMsg: 'Please enter Grade',
                        maxLength: 2,
                        isPhone: false,
                        isOptional: false,
                        onChange: (str) {},
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
                        controller: sectionController,
                        textInputAction: TextInputAction.done,
                        keyboard: TextInputType.text,
                        hintText: 'Enter Section',
                        validationMsg: 'Please enter Section',
                        maxLength: 1,
                        isPhone: false,
                        isOptional: false,
                        onChange: (str) {},
                        prefixIcon: CupertinoIcons.dot_square,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-z A-Z]")),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                BuildListItemWidget(
                  onTap: () {
                    Get.to(() => AssignClassTeacherScreen(
                          isNewClass: true,
                        ));
                  },
                  text: "Assign Class Teacher",
                  subtitle: Text(
                    classNotifier.teacherAssigned.user?.sId == null ? "Selected Class Teacher: No teacher assigned yet" : "Selected Class Teacher: ${classNotifier.teacherAssigned.user?.fullName}" ,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
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
