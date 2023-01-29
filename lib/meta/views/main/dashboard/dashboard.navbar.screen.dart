import 'dart:developer';

import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/diary/teacher_class_diary.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    log("First Student Class Id: ${context.read<AuthenticationNotifier>().authModel.parentData!.students!.first.classModel?.toJson()}");
    // _fetchClassDiary = context.read<ClassNotifier>().fetchClassDiary(classId: context.read<ParentNotifier>().selectedStudentProfile!.classModel!.sId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BottomNavBarVM bottomNavBarVM = context.watch<BottomNavBarVM>();
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
              Text("Dashboard", style: Theme.of(context).textTheme.displayMedium,),
              SizedBox(
                height: 0.02.sh,
              ),

              // FutureBuilder(
              //     future: _fetchClassDiary,
              //     builder: (BuildContext context,
              //         AsyncSnapshot<TeacherClassDiary> snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return AppCircularIndicatorWidget();
              //       } else if (snapshot.connectionState ==
              //           ConnectionState.done &&
              //           classNotifier.teacherClassDiary.diary != null) {
              //         if (classNotifier.teacherClassDiary.diary!.isEmpty) {
              //           return Container(
              //             height: 0.4.sh,
              //             decoration: BoxDecoration(
              //                 color: AppTheme.whiteColor.withOpacity(0.45),
              //                 borderRadius: BorderRadius.circular(12)),
              //             padding: EdgeInsets.symmetric(
              //                 vertical: 0.01.sh, horizontal: 0.02.sw),
              //             child: Center(
              //                 child: Text(
              //                   "No Diary found",
              //                   style: Theme.of(context).textTheme.bodyLarge,
              //                 )),
              //           );
              //         } else {
              //           return CarouselSlider.builder(
              //             itemCount: classNotifier.teacherClassDiary.diary?.length,
              //             itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
              //               Diary diary = classNotifier.teacherClassDiary.diary![itemIndex];
              //               return GestureDetector(
              //                 onTap: () {
              //                   log("${DateFormat("MM/dd/yyyy").format(DateTime.now())}");
              //                   log("${DateTime.now().toIso8601String()}");
              //                 },
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                       color: AppTheme.whiteColor.withOpacity(0.45),
              //                       borderRadius: BorderRadius.circular(12)),
              //                   padding: EdgeInsets.symmetric(
              //                       vertical: 0.01.sh, horizontal: 0.02.sw),
              //                   child: SingleChildScrollView(
              //                     physics: const BouncingScrollPhysics(),
              //                     child: Expanded(
              //                       child: Column(
              //                         crossAxisAlignment: CrossAxisAlignment.stretch,
              //                         children: [
              //                           Text(
              //                             "Daily Diary: ${diary.classId?.grade}${diary.classId?.section}",
              //                             style: Theme.of(context)
              //                                 .textTheme
              //                                 .displaySmall
              //                                 ?.copyWith(fontWeight: FontWeight.bold),
              //                           ),
              //                           SizedBox(
              //                             height: 0.01.sh,
              //                           ),
              //                           Text(
              //                             "${diary.diary}",
              //                             // maxLines: 10,
              //                             style:
              //                             Theme.of(context).textTheme.bodyLarge?.copyWith(
              //                               fontSize: 16,
              //                               overflow: TextOverflow.fade,
              //                             ),
              //                           ),
              //                           SizedBox(
              //                             height: 0.02.sh,
              //                           ),
              //                           Align(
              //                             alignment: Alignment.bottomRight,
              //                             child: Text(
              //                               "Updated On: ${BaseHelper.formatDateWithMonth(DateTime.parse(diary.currentDate!))}",
              //                               style:
              //                               Theme.of(context).textTheme.bodyMedium?.copyWith(
              //                                   overflow: TextOverflow.ellipsis,
              //                                   fontWeight: FontWeight.bold
              //                               ),
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               );
              //             },
              //             options: CarouselOptions(
              //               scrollPhysics: const BouncingScrollPhysics(),
              //               height: 0.4.sh,
              //               aspectRatio: 16 / 9,
              //               viewportFraction: 1,
              //               initialPage: 0,
              //               enableInfiniteScroll: false,
              //               reverse: false,
              //               autoPlay: classNotifier.teacherClassDiary.diary!.length > 1 ? true : false,
              //               autoPlayInterval: Duration(seconds: 5),
              //               autoPlayAnimationDuration: Duration(milliseconds: 800),
              //               autoPlayCurve: Curves.fastOutSlowIn,
              //               enlargeCenterPage: true,
              //               enlargeFactor: 0.3,
              //               onPageChanged: (page, reason) {},
              //               scrollDirection: Axis.horizontal,
              //             ),
              //           );
              //         }
              //       } else {
              //         return Container(
              //           height: 0.4.sh,
              //           decoration: BoxDecoration(
              //               color: AppTheme.whiteColor.withOpacity(0.45),
              //               borderRadius: BorderRadius.circular(12)),
              //           padding: EdgeInsets.symmetric(
              //               vertical: 0.01.sh, horizontal: 0.02.sw),
              //           child: Center(
              //               child: Text(
              //                 "No Diary found",
              //                 style: Theme.of(context).textTheme.bodyLarge,
              //               )),
              //         );
              //       }
              //     }),

            ],
          ),
        ),
      ),
    );
  }
}
