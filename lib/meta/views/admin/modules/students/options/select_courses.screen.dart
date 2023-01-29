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
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/notifiers/student.notifier.dart';
import 'package:e_parent_kit/core/notifiers/teacher.notifier.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/utils/time_ago.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
import 'package:e_parent_kit/core/models/course/select_course.model.dart';
import 'package:e_parent_kit/core/models/student/select_student.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/notifiers/teacher.notifier.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SelectCoursesScreen extends StatefulWidget {
  final StudentModel student;
  const SelectCoursesScreen({Key? key, required this.student}) : super(key: key);

  @override
  State<SelectCoursesScreen> createState() => _SelectCoursesScreenState();
}

class _SelectCoursesScreenState extends State<SelectCoursesScreen> {
  Future<SelectCoursesModel>? _fetchCourses;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _fetchCourses = context.read<StudentNotifier>().fetchAllCourses(widget.student);
    super.initState();
  }

  void _trySubmit() async {
    StudentNotifier studentNotifier = Provider.of<StudentNotifier>(context, listen: false);
    EasyLoading.show();

    List<String> courseIds = studentNotifier.getAllSelectedCourses.map((e) => e.sId!).toList();;
    await studentNotifier.manageEnrollment(context, studentId: widget.student.sId!, courseIds: courseIds);

    EasyLoading.dismiss();
  }

  Future<void> _onRefresh() async {
    await context.read<StudentNotifier>().fetchAllCourses(widget.student);
  }

  @override
  Widget build(BuildContext context) {
    StudentNotifier studentNotifier = context.watch<StudentNotifier>();
    return Scaffold(
      appBar: AppAppbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select courses for\n${widget.student.fullName}",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(
              height: 0.01.sh,
            ),
            AppSearchTextField(
              hintText: 'Course code or Course name',
              searchController: _searchController,
              suffixIcon: _searchController.text.trim().isNotEmpty ?
              IconButton(onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  studentNotifier.filterCourses = studentNotifier.studentCourses.data;
                });
                  _searchController.clear();
                }, icon: Icon(CupertinoIcons.clear_circled, color: AppTheme.primaryColor  ,),)
                  : const SizedBox.shrink(),
              onChange: (String str) {
                setState(() {
                  studentNotifier.filterCourses =
                      studentNotifier.studentCourses.data!.where((element) {
                        String courseCode = element.courseCode!.toLowerCase();
                        String courseName = element.courseName!.toString();
                        return courseName.contains(str.toLowerCase()) ||
                            courseCode.contains(str.toLowerCase());
                      }).toList();
                });
              },
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            FutureBuilder(
                future: _fetchCourses,
                builder: (BuildContext context,
                    AsyncSnapshot<SelectCoursesModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(child: AppCircularIndicatorWidget());
                  } else if (snapshot.connectionState == ConnectionState.done && studentNotifier.studentCourses.data != null) {
                    if (studentNotifier.studentCourses.data!.isEmpty) {
                      return Expanded(
                        child: Center(
                            child: Text(
                              "No course have been added yet",
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                      );
                    } else {

                      return Expanded(
                        child: RefreshIndicator(
                          color: AppTheme.primaryColor,
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: studentNotifier.filterCourses?.length,
                            itemBuilder: (BuildContext context, int index) {
                              CourseModel course = studentNotifier.filterCourses![index];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.005.sh),
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  selectedTileColor:
                                  AppTheme.primaryColor.withOpacity(0.3),
                                  selected: course.selected!,
                                  title: Text(
                                    '${course.courseName}',
                                    style: Theme.of(context).textTheme.displaySmall,
                                  ),
                                  subtitle: Text(
                                    '${course.courseCode}',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  activeColor: AppTheme.primaryColor,
                                  value: course.selected,
                                  onChanged: (bool? value) {
                                    if(studentNotifier.totalSelectedCourses <= 6){
                                      setState(() {
                                        course.selected = !course.selected!;
                                      });
                                    }else{
                                      if(course.selected == true){
                                        setState(() {
                                          course.selected = !course.selected!;
                                        });
                                        return;
                                      }
                                     BaseHelper.showSnackBar("Cannot select more than 6 courses");
                                    }
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
                            "No course have been added yet",
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
        child: studentNotifier.checkCourseSelections ? FloatingActionButton.extended(
            icon: const Icon(CupertinoIcons.check_mark, color: AppTheme.black,),
            onPressed: _trySubmit,
            label: Text(
              "Confirm",
              style: Theme.of(context).textTheme.bodyLarge,
            )) : const SizedBox.shrink(),
      ),
    );
  }
}
