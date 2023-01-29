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
import 'package:provider/provider.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({Key? key}) : super(key: key);

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  TextEditingController courseNameController = TextEditingController();
  TextEditingController courseCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _trySubmit() async {
    CourseNotifier courseNotifier = Provider.of<CourseNotifier>(context, listen: false);
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      EasyLoading.show();

      await courseNotifier.createCourse(
        courseName: courseNameController.text.trim(),
        courseCode: courseCodeController.text.trim(),
      );

      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  "Create Course",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                AppSimpleTextField(
                  controller: courseNameController,
                  keyboard: TextInputType.text,
                  hintText: 'Enter Course name',
                  validationMsg: 'Please enter course name',
                  isName: false,
                  isEmail: false,
                  isOptional: false,
                  onChange: (str) {},
                  prefixIcon: CupertinoIcons.book,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                  ],
                ),
                SizedBox(
                  height: 0.01.sh,
                ),
                AppSimpleTextField(
                  controller: courseCodeController,
                  keyboard: TextInputType.text,
                  hintText: 'Course Code (COURSE#111)',
                  validationMsg: 'Please enter course code',
                  isName: false,
                  isEmail: false,
                  isOptional: false,
                  onChange: (str) {},
                  prefixIcon: CupertinoIcons.book,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp("[a-z A-Z # 0-9]")),
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ],
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
