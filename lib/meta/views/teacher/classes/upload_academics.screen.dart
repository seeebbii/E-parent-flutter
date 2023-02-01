import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_divider.dart';
import 'package:e_parent_kit/components/widgets/app_dob_textfield.dart';
import 'package:e_parent_kit/components/widgets/app_dropdown.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/class/class.model.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/core/models/teacherr/all_teachers.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/notifiers/teacher.notifier.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/create_class.screen.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/manage_class.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../components/widgets/app_simple_text_field.dart';

class UploadAcademicsScreen extends StatefulWidget {
  const UploadAcademicsScreen({Key? key}) : super(key: key);

  @override
  State<UploadAcademicsScreen> createState() => _UploadAcademicsScreenState();
}

class _UploadAcademicsScreenState extends State<UploadAcademicsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController totalMarksController = TextEditingController();
  final TextEditingController obtainedMarksController = TextEditingController();
  final _key = GlobalKey<DropdownSearchState<String>>();

  final _formKey = GlobalKey<FormState>();

  List<String> _type = [
    "Quiz",
    "Assignment",
    "Mid Term Exam",
    "Final Term Exam"
  ];

  void _trySubmit() async {
    if (typeController.text.trim().isEmpty) {
      return BaseHelper.showSnackBar("Please select type");
    }

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      EasyLoading.show();
      await context.read<TeacherNotifier>().uploadStudentAcademic(
            context: context,
            title: titleController.text.trim(),
            totalMarks: double.parse(totalMarksController.text.trim()),
            obtainedMarks: double.parse(obtainedMarksController.text.trim()),
            type: typeController.text.trim(),
          );
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    ParentNotifier parentNotifier = context.watch<ParentNotifier>();
    TeacherNotifier teacherNotifier = context.watch<TeacherNotifier>();
    return Scaffold(
      appBar: AppAppbar(),
      body: SingleChildScrollView(
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
                  "Current Course: ${teacherNotifier.selectedCourse.courseName}",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                AppSimpleTextField(
                  controller: titleController,
                  onChange: (str) {},
                  prefixIcon: CupertinoIcons.app_badge,
                  keyboard: TextInputType.text,
                  hintText: "Your title here...",
                  // inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]")),],
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Total Marks: ",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    )),
                    Expanded(
                      flex: 3,
                      child: AppSimpleTextField(
                        controller: totalMarksController,
                        onChange: (str) {},
                        prefixIcon: CupertinoIcons.app_badge,
                        keyboard: TextInputType.phone,
                        hintText: "Total Marks",
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Obtained Marks: ",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    )),
                    Expanded(
                      flex: 3,
                      child: AppSimpleTextField(
                        controller: obtainedMarksController,
                        onChange: (str) {},
                        prefixIcon: CupertinoIcons.app,
                        keyboard: TextInputType.phone,
                        hintText: "Obtained Marks",
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Type: ",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    )),
                    Expanded(
                      flex: 3,
                      child: AppDropdown(
                        controller: typeController,
                        myKey: _key,
                        contentList: _type,
                        hintText: 'Types',
                        itemBuilder: (ctx, item, isSelected) {
                          return ListTile(
                              selected: isSelected,
                              title: Text(
                                item,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              onTap: () {
                                setState(() {
                                  _key.currentState?.popupValidate([item]);
                                  typeController.text = item;
                                });
                              });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                AppElevatedButton(
                  onPressed: _trySubmit,
                  buttonText: 'Upload',
                  textColor: AppTheme.whiteColor,
                  buttonColor: AppTheme.primaryColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
