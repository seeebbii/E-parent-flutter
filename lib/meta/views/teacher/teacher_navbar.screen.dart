import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/class/all_classes.model.dart';
import 'package:e_parent_kit/core/models/diary/teacher_class_diary.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/notifiers/teacher.notifier.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/models/class/class.model.dart';
import 'classes/view_my_class.screen.dart';

class TeacherNavbarScreen extends StatefulWidget {
  const TeacherNavbarScreen({Key? key}) : super(key: key);

  @override
  State<TeacherNavbarScreen> createState() => _TeacherNavbarScreenState();
}

class _TeacherNavbarScreenState extends State<TeacherNavbarScreen> {
  Future<AllClassesModel>? _fetchMyClasses;
  Future<TeacherClassDiary>? _fetchTeacherClassDiary;

  Future<void> _onRefresh() async {
    EasyLoading.show();
    await context.read<ClassNotifier>().fetchAllClasses(teacherId: context.read<AuthenticationNotifier>().authModel.user!.sId!);
    await context.read<ClassNotifier>().fetchTeacherClassDiary(teacherId: context.read<AuthenticationNotifier>().authModel.user!.sId!);
    EasyLoading.dismiss();
    BaseHelper.showSnackBar('Sync Complete');
  }

  @override
  void initState() {
    _fetchMyClasses = context.read<ClassNotifier>().fetchAllClasses(teacherId: context.read<AuthenticationNotifier>().authModel.user!.sId!);
    _fetchTeacherClassDiary = context.read<ClassNotifier>().fetchTeacherClassDiary(teacherId: context.read<AuthenticationNotifier>().authModel.user!.sId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BottomNavBarVM bottomNavBarVM = context.watch<BottomNavBarVM>();
    AuthenticationNotifier authNotifier =
        context.watch<AuthenticationNotifier>();
    ClassNotifier classNotifier = context.watch<ClassNotifier>();
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
                "Welcome back,\n${authNotifier.authModel.user?.fullName}",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(
                height: 0.02.sh,
              ),

              FutureBuilder(
                  future: _fetchTeacherClassDiary,
                  builder: (BuildContext context,
                      AsyncSnapshot<TeacherClassDiary> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return AppCircularIndicatorWidget();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done &&
                        classNotifier.teacherClassDiary.diary != null) {
                      if (classNotifier.teacherClassDiary.diary!.isEmpty) {
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
                          itemCount: classNotifier.teacherClassDiary.diary?.length,
                          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                            Diary diary = classNotifier.teacherClassDiary.diary![itemIndex];
                            return GestureDetector(
                              onTap: () {
                                print(diary.currentDate);
                                log("${DateFormat("MM/dd/yyyy").format(DateTime.parse(diary.currentDate!))}");

                                // log("${DateTime.now().toIso8601String()}");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: AppTheme.whiteColor.withOpacity(0.45),
                                    borderRadius: BorderRadius.circular(12)),
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.01.sh, horizontal: 0.02.sw),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Daily Diary: ${diary.classId?.grade}${diary.classId?.section} (${BaseHelper.formatDateWithMonth(DateTime.parse(diary.currentDate!))})",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 0.01.sh,
                                      ),
                                      Text(
                                        "${diary.diary}",
                                        // maxLines: 10,
                                        style:
                                        Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                                          style:
                                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold
                                          ),
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
                            autoPlay: classNotifier.teacherClassDiary.diary!.length > 1 ? true : false,
                            autoPlayInterval: Duration(seconds: 5),
                            autoPlayAnimationDuration: Duration(milliseconds: 800),
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
                  Text(
                    "My Classes",
                    style: Theme.of(context).textTheme.displayMedium,
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
              FutureBuilder(
                  future: _fetchMyClasses,
                  builder: (BuildContext context,
                      AsyncSnapshot<AllClassesModel> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return AppCircularIndicatorWidget();
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        classNotifier.allClassesModel.data != null) {
                      if (classNotifier.allClassesModel.data!.isEmpty) {
                        return Container(
                          height: 0.3.sh,
                          child: Center(
                              child: Text(
                            "No Classes found",
                            style: Theme.of(context).textTheme.bodyLarge,
                          )),
                        );
                      } else {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: classNotifier.allClassesModel.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            ClassModel classItem =
                                classNotifier.allClassesModel.data![index];
                            return InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                classNotifier.assignClass(classItem);
                                Get.to(() => ViewMyClassScreen());
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
                                      "${classItem.grade}${classItem.section}",
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
                                      "Student Count: ${classItem.studentsEnrolled?.length ?? 0}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      return Center(
                          child: Text(
                        "No Classes found",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ));
                    }
                  }),
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
