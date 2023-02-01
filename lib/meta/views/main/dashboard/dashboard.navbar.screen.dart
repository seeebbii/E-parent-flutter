import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
import 'package:e_parent_kit/core/models/diary/teacher_class_diary.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/notifiers/teacher.notifier.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/views/main/dashboard/view_course.screen.dart';
import 'package:e_parent_kit/meta/views/teacher/classes/view_students_academics.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardNavbarScreen extends StatefulWidget {
  const DashboardNavbarScreen({Key? key}) : super(key: key);

  @override
  State<DashboardNavbarScreen> createState() => _DashboardNavbarScreenState();
}

class _DashboardNavbarScreenState extends State<DashboardNavbarScreen> {
  Future<TeacherClassDiary>? _fetchClassDiary;

  @override
  void initState() {
    _fetchClassDiary = context.read<ClassNotifier>().fetchClassDiary(context);
    super.initState();
  }

  Future<void> _onRefresh() async {
    EasyLoading.show();
    await context.read<ClassNotifier>().fetchClassDiary(context);
    EasyLoading.dismiss();
    BaseHelper.showSnackBar('Sync Complete');
  }

  @override
  Widget build(BuildContext context) {
    BottomNavBarVM bottomNavBarVM = context.watch<BottomNavBarVM>();
    ClassNotifier classNotifier = context.watch<ClassNotifier>();
    ParentNotifier parentNotifier = context.watch<ParentNotifier>();
    TeacherNotifier teacherNotifier = context.watch<TeacherNotifier>();
    return Scaffold(
      backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 0.01.sh,
              ),
              Text(
                "Dashboard",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              FutureBuilder(
                  future: _fetchClassDiary,
                  builder: (BuildContext context,
                      AsyncSnapshot<TeacherClassDiary> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return AppCircularIndicatorWidget();
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        classNotifier.studentClassDiary.diary != null) {
                      if (classNotifier.studentClassDiary.diary!.isEmpty) {
                        return Container(
                          height: 0.4.sh,
                          decoration: BoxDecoration(
                              color: AppTheme.whiteColor.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.symmetric(
                              vertical: 0.01.sh, horizontal: 0.02.sw),
                          child: Center(
                              child: Text(
                            "No Diary found",
                            style: Theme.of(context).textTheme.bodyLarge,
                          )),
                        );
                      } else {
                        return CarouselSlider.builder(
                          itemCount:
                              classNotifier.studentClassDiary.diary?.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) {
                            Diary diary = classNotifier
                                .studentClassDiary.diary![itemIndex];
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                    color:
                                        AppTheme.whiteColor.withOpacity(0.45),
                                    borderRadius: BorderRadius.circular(12)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.01.sh, horizontal: 0.02.sw),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Daily Diary: ${diary.classId?.grade}${diary.classId?.section} (${BaseHelper.formatDateWithMonth(DateTime.parse(diary.currentDate!))})",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 0.01.sh,
                                      ),
                                      Text(
                                        "${diary.diary}",
                                        // maxLines: 10,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontSize: 16,
                                              overflow: TextOverflow.fade,
                                            ),
                                      ),
                                      SizedBox(
                                        height: 0.02.sh,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "Updated On: ${BaseHelper.formatDateWithMonth(DateTime.parse(diary.createdAt!))}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight:
                                                      FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            scrollPhysics: const BouncingScrollPhysics(),
                            height: 0.4.sh,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            reverse: false,
                            autoPlay:
                                classNotifier.studentClassDiary.diary!.length >
                                        1
                                    ? true
                                    : false,
                            autoPlayInterval: Duration(seconds: 5),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.3,
                            onPageChanged: (page, reason) {},
                            scrollDirection: Axis.horizontal,
                          ),
                        );
                      }
                    } else {
                      return Container(
                        height: 0.4.sh,
                        decoration: BoxDecoration(
                            color: AppTheme.whiteColor.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.01.sh, horizontal: 0.02.sw),
                        child: Center(
                            child: Text(
                          "No Diary found",
                          style: Theme.of(context).textTheme.bodyLarge,
                        )),
                      );
                    }
                  }),
              SizedBox(
                height: 0.02.sh,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${parentNotifier.selectedStudentProfile?.fullName}'s Courses",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: _onRefresh,
                    icon: Icon(CupertinoIcons.arrow_2_circlepath),
                  )
                ],
              ),
              SizedBox(
                height: 0.01.sh,
              ),
              parentNotifier.selectedStudentProfile!.coursesEnrolled!.isEmpty ?
              Container(
                height: 0.3.sh,
                child: Center(
                    child: Text(
                      "No Courses Enrolled",
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
              )
                  :
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: parentNotifier.selectedStudentProfile?.coursesEnrolled?.length,
                itemBuilder: (BuildContext context, int index) {
                  CourseModel courseModel = parentNotifier.selectedStudentProfile!.coursesEnrolled![index];
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      classNotifier.assignCourse(courseModel);
                      teacherNotifier.assignCourse(courseModel);
                      teacherNotifier.assignStudent(parentNotifier.selectedStudentProfile!);


                      Get.to(() => ViewStudentsAcademicsScreen());
                    },
                    child: Card(
                      elevation: 0,
                      color: AppTheme.primaryColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${courseModel.courseName}",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          // SizedBox(
                          //   height: 0.01.sh,
                          // ),
                          // Text(
                          //   "Student Count: ${classItem.studentsEnrolled?.length ?? 0}",
                          //   style: Theme.of(context).textTheme.bodyMedium,
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 0.05.sh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
