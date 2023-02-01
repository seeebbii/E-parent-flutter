import 'dart:io';

import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/class/class.model.dart';
import 'package:e_parent_kit/core/models/teacherr/all_teachers.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/teacher.notifier.dart';
import 'package:e_parent_kit/meta/utils/app_sizes.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/create_class.screen.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/manage_class.screen.dart';
import 'package:e_parent_kit/meta/views/teacher/classes/view_leave_requests.screen.dart';
import 'package:e_parent_kit/meta/views/teacher/classes/view_my_students.screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'upload_attendance.screen.dart';
import 'upload_class_diary.screen.dart';

class UploadClassAssignmentScreen extends StatefulWidget {
  const UploadClassAssignmentScreen({Key? key}) : super(key: key);

  @override
  State<UploadClassAssignmentScreen> createState() =>
      _UploadClassAssignmentScreenState();
}

class _UploadClassAssignmentScreenState
    extends State<UploadClassAssignmentScreen> {
  File? _selectedFile;
  final TextEditingController titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_selectedFile == null || _selectedFile?.path == null) {
      return BaseHelper.showSnackBar('Please select File');
    }

    if (isValid) {
      EasyLoading.show();
      await context.read<TeacherNotifier>().uploadAssignment(title: titleController.text.trim(), context: context, file: _selectedFile!);
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    ClassNotifier classNotifier = context.watch<ClassNotifier>();
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
                TextFormField(
                    validator: (str) {
                      if (str == null || str.isEmpty) {
                        return ("Cannot_be_empty".tr);
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    maxLength: 50,
                    controller: classNotifier.diaryController,
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
                      labelText: "Title for assignment",
                      hintText: 'Assignment 1 is due this Monday...',
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
                  height: 0.02.sh,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Selected File: ${_selectedFile == null ? "No file selected" : "${_selectedFile?.path.split('/').last}"}",
                          style: Theme.of(context).textTheme.displaySmall,
                        )),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(allowMultiple: false);
                          if (result != null) {
                            File file = File(result.files.single.path!);
                            setState(() {
                              _selectedFile = file;
                            });
                          }
                        },
                        child: Text(
                          "Select File",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.02.sh,
                ),
                AppElevatedButton(
                    onPressed: _trySubmit,
                    buttonText: "Upload",
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
