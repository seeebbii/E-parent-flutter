import 'dart:developer';

import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/components/widgets/app_dob_textfield.dart';
import 'package:e_parent_kit/components/widgets/app_search_field.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
import 'package:e_parent_kit/core/models/course/select_course.model.dart';
import 'package:e_parent_kit/core/models/notification/notifications.model.dart';
import 'package:e_parent_kit/core/models/student/enrollment.model.dart';
import 'package:e_parent_kit/core/models/student/select_student.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/notifiers/student.notifier.dart';
import 'package:e_parent_kit/core/notifiers/teacher.notifier.dart';
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


class AssignStudentsScreen extends StatefulWidget {
  const AssignStudentsScreen({Key? key}) : super(key: key);

  @override
  State<AssignStudentsScreen> createState() => _AssignStudentsScreenState();
}

class _AssignStudentsScreenState extends State<AssignStudentsScreen> {

  TextEditingController _searchController = TextEditingController();

  Future<EnrollmentModel>? _fetchEnrollmentModel;

  @override
  void initState() {
    _fetchEnrollmentModel = context.read<StudentNotifier>().fetchStudentsSearch(query: '', selectedClass: context.read<ClassNotifier>().selectedClass);
    super.initState();
  }

  Future<void> _onRefresh() async {
    await context.read<StudentNotifier>().fetchStudentsSearch(
        query: '', selectedClass: context.read<ClassNotifier>().selectedClass);
  }

  Future<void> _trySubmit() async {
    EasyLoading.show();
    StudentNotifier studentNotifier = Provider.of<StudentNotifier>(context, listen: false);

    List<String> selectedStudentIds = [];

    studentNotifier.filterStudents?.forEach((element) {
      if(element.selected == true){
        selectedStudentIds.add(element.sId!);
      }
    });

    await context.read<ClassNotifier>().updateStudentsEnrolled(selectedStudentIds, context);

    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    StudentNotifier studentNotifier = context.watch<StudentNotifier>();
    ClassNotifier classNotifier = context.watch<ClassNotifier>();
    return Scaffold(
      appBar: AppAppbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 0.01.sh,
            ),
            Text(
              "Select Students",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            AppSearchTextField(
              hintText: 'Phone Number or Name of Student',
              searchController: _searchController,
              suffixIcon: _searchController.text.trim().isNotEmpty ?
              IconButton(onPressed: () {
                _searchController.clear();
                FocusScope.of(context).unfocus();
                setState(() {
                  studentNotifier.filterStudents = context.read<StudentNotifier>().enrollmentModel.students;
                });
              }, icon: Icon(CupertinoIcons.clear_circled, color: AppTheme.primaryColor  ,),)
                  : const SizedBox.shrink(),
              onChange: (str) {
                print(_searchController.text.trim());
                setState(() {
                  context.read<StudentNotifier>().filterStudents =
                      studentNotifier.enrollmentModel.students!.where((element) {
                        String parentsPhone = element.parentPhone!.toString();
                        String fullName = element.fullName!.toLowerCase();
                        return fullName.contains(str.toLowerCase()) ||
                            parentsPhone.contains(str.toLowerCase());
                      }).toList();
                });
              },
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            FutureBuilder(
                future: _fetchEnrollmentModel,
                builder: (BuildContext context,
                    AsyncSnapshot<EnrollmentModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(child: AppCircularIndicatorWidget());
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      studentNotifier.filterStudents != null) {
                    if (studentNotifier.filterStudents!.isEmpty) {
                      return Expanded(
                        child: Center(
                            child: Text(
                              "No student found",
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                      );
                    } else {
                      return Expanded(
                        flex: 1,
                        child: RefreshIndicator(
                          color: AppTheme.primaryColor,
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: studentNotifier.filterStudents?.length,
                            itemBuilder: (BuildContext context, int index) {
                              StudentModel student = studentNotifier.filterStudents![index];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.005.sh),
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  selectedTileColor:
                                  AppTheme.primaryColor.withOpacity(0.3),
                                  selected: student.selected!,
                                  title: Text(
                                    '${student.fullName}',
                                    style: Theme.of(context).textTheme.displaySmall,
                                  ),
                                  subtitle: Text(
                                    student.classModel?.sId == null ? 'Not enrolled in any class' : student.classModel!.sId == classNotifier.selectedClass.sId ? 'Already enrolled in this class' : 'Already enrolled in ${student.classModel!.grade}${student.classModel!.section}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  activeColor: AppTheme.primaryColor,
                                  value: student.selected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      student.selected = !student.selected!;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  } else {
                    return Expanded(
                      child: Center(
                          child: Text(
                            "No student found",
                            style: Theme.of(context).textTheme.bodyLarge,
                          )),
                    );
                  }
                }),
          ],
        ),
      ),
      floatingActionButton:  AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: studentNotifier.checkStudentSelected ? FloatingActionButton.extended(
            icon: const Icon(CupertinoIcons.check_mark, color: AppTheme.black,),
            onPressed: _trySubmit,
            label: Text(
              "Update",
              style: Theme.of(context).textTheme.bodyLarge,
            )) : const SizedBox.shrink(),
      ),
    );
  }
}
