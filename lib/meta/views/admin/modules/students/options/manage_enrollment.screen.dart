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
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'select_courses.screen.dart';

class ManageEnrollmentScreen extends StatefulWidget {
  const ManageEnrollmentScreen({Key? key}) : super(key: key);

  @override
  State<ManageEnrollmentScreen> createState() => _ManageEnrollmentScreenState();
}

class _ManageEnrollmentScreenState extends State<ManageEnrollmentScreen> {
  TextEditingController _searchController = TextEditingController();

  Future<EnrollmentModel>? _fetchEnrollmentModel;

  @override
  void initState() {
    _fetchEnrollmentModel = context
        .read<StudentNotifier>()
        .fetchStudentsSearch(query: _searchController.text.trim());
    super.initState();
  }

  Future<void> _onRefresh() async {
    await context.read<StudentNotifier>().fetchStudentsSearch(query: '');
  }

  @override
  Widget build(BuildContext context) {
    StudentNotifier studentNotifier = context.watch<StudentNotifier>();
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
              "Manage Students Enrollment",
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
                setState(() async {
                  _fetchEnrollmentModel = context
                      .read<StudentNotifier>()
                      .fetchStudentsSearch(query: '');
                });
              }, icon: Icon(CupertinoIcons.clear_circled, color: AppTheme.primaryColor  ,),)
                  : const SizedBox.shrink(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
              ],
              onChange: (str) {
                setState(() {
                  _fetchEnrollmentModel = context
                      .read<StudentNotifier>()
                      .fetchStudentsSearch(
                          query: _searchController.text.trim());
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
                      studentNotifier.enrollmentModel.students != null) {
                    if (studentNotifier.enrollmentModel.students!.isEmpty) {
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
                            itemCount: studentNotifier
                                .enrollmentModel.students?.length,
                            itemBuilder: (BuildContext context, int index) {
                              StudentModel student = studentNotifier
                                  .enrollmentModel.students![index];
                              return BuildListItemWidget(
                                onTap: () {
                                  Get.to(() =>
                                      SelectCoursesScreen(student: student));
                                },
                                text: student.fullName.toString(),
                                subtitle: Text(
                                    "Courses Enrolled: ${student.coursesEnrolled?.length ?? 0}"),
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
    );
  }
}
