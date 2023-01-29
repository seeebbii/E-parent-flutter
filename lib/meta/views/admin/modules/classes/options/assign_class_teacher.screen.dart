import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/components/widgets/app_dob_textfield.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/components/widgets/app_search_field.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
import 'package:e_parent_kit/core/models/course/select_course.model.dart';
import 'package:e_parent_kit/core/models/notification/notifications.model.dart';
import 'package:e_parent_kit/core/models/student/enrollment.model.dart';
import 'package:e_parent_kit/core/models/student/select_student.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/core/models/teacherr/all_teachers.model.dart';
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

class AssignClassTeacherScreen extends StatefulWidget {
  final bool isNewClass;

  const AssignClassTeacherScreen({Key? key, required this.isNewClass})
      : super(key: key);

  @override
  State<AssignClassTeacherScreen> createState() =>
      _AssignClassTeacherScreenState();
}

class _AssignClassTeacherScreenState extends State<AssignClassTeacherScreen> {
  TextEditingController _searchController = TextEditingController();

  Future<AllTeachersModel>? _fetchAllTeachers;

  @override
  void initState() {
    _fetchAllTeachers = context.read<TeacherNotifier>().fetchAllTeachers();
    super.initState();
  }

  Future<void> _onRefresh() async {
    await context.read<TeacherNotifier>().fetchAllTeachers();
  }

  void showConfirmationDialog(TeachersDataList tappedTeacher, BuildContext ctx) async {
    ClassNotifier classNotifier =
        Provider.of<ClassNotifier>(context, listen: false);
    Get.defaultDialog(
        title:
            "Are you sure you want to replace class teacher ${classNotifier.teacherAssigned.user!.fullName} with ${tappedTeacher.user!.fullName}?",
        titleStyle: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
        middleText: '',
        content: Row(
          children: [
            Expanded(
                child: AppElevatedButton(
                    onPressed: () {
                      navigationController.goBack();
                    },
                    buttonText: "Cancel",
                    textColor: AppTheme.whiteColor,
                    buttonColor: Colors.grey)),
            SizedBox(
              width: 0.01.sw,
            ),
            Expanded(
                child: AppElevatedButton(
                    onPressed: () async {
                      navigationController.goBack();
                      classNotifier.assignTeacher(tappedTeacher);
                      EasyLoading.show();


                      await classNotifier.updateClassTeacher(ctx);
                      EasyLoading.dismiss();

                    },
                    buttonText: "Confirm",
                    textColor: AppTheme.whiteColor,
                    buttonColor: AppTheme.primaryColor)),
          ],
        ),
        radius: 12.0);
  }

  @override
  Widget build(BuildContext context) {
    TeacherNotifier teacherNotifier = context.watch<TeacherNotifier>();
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
              "Assign Class Teacher",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            AppSearchTextField(
              hintText: 'Phone Number or Name of Teacher',
              searchController: _searchController,
              suffixIcon: _searchController.text.trim().isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                        setState(() async {
                          teacherNotifier.filterTeachers =
                              teacherNotifier.allTeachersModel.teachers;
                        });
                      },
                      icon: Icon(
                        CupertinoIcons.clear_circled,
                        color: AppTheme.primaryColor,
                      ),
                    )
                  : const SizedBox.shrink(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9a -zA-Z]")),
              ],
              onChange: (str) {
                setState(() {
                  teacherNotifier.filterTeachers = teacherNotifier
                      .allTeachersModel.teachers!
                      .where((element) {
                    String teacherName = element.user!.fullName!.toLowerCase();
                    String phoneNumber =
                        element.user!.completePhone!.toString();
                    return phoneNumber.contains(str.toLowerCase()) ||
                        teacherName.contains(str.toLowerCase());
                  }).toList();
                });
              },
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            FutureBuilder(
                future: _fetchAllTeachers,
                builder: (BuildContext context,
                    AsyncSnapshot<AllTeachersModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(child: AppCircularIndicatorWidget());
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      teacherNotifier.filterTeachers != null) {
                    if (teacherNotifier.filterTeachers!.isEmpty) {
                      return Expanded(
                        child: Center(
                            child: Text(
                          "No teacher found",
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
                            itemCount: teacherNotifier.filterTeachers?.length,
                            itemBuilder: (BuildContext context, int index) {
                              TeachersDataList teacher =
                                  teacherNotifier.filterTeachers![index];
                              return BuildListItemWidget(
                                onTap: () {
                                  // Assign teacher

                                  if (widget.isNewClass) {
                                    navigationController.goBack();
                                  } else {
                                    if (classNotifier
                                            .teacherAssigned.user!.sId ==
                                        teacher.user!.sId) {
                                      return BaseHelper.showSnackBar(
                                          'Cannot select already assigned teacher');
                                    }
                                    showConfirmationDialog(teacher, context);
                                  }
                                },
                                text: teacher.user!.fullName.toString(),
                                subtitle: Text(
                                    "Course Teaches: ${teacher.teacherData!.courseTeaches?.length ?? 0}"),
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
                        "No teacher found",
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
