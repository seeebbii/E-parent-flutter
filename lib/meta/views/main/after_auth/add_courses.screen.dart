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

class AddCoursesScreen extends StatefulWidget {
  const AddCoursesScreen({Key? key}) : super(key: key);

  @override
  State<AddCoursesScreen> createState() => _AddCoursesScreenState();
}

class _AddCoursesScreenState extends State<AddCoursesScreen> {

  Future<SelectCoursesModel>? _fetchCourses;

  @override
  void initState() {
    _fetchCourses = context.read<TeacherNotifier>().fetchAllCourses();
    super.initState();
  }

  void _trySubmit() async {
    TeacherNotifier teacherNotifier = Provider.of<TeacherNotifier>(context, listen: false);
    AuthenticationNotifier authNotifier = Provider.of<AuthenticationNotifier>(context, listen: false);
    List<String> courseIds = teacherNotifier.getAllSelectedCourses.map((e) => e.sId!).toList();

    // Call Add students query
    EasyLoading.show();

    await teacherNotifier.addCourses(context, teacherId: authNotifier.authModel.teacherData!.sId!, courseIds: courseIds);

    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    TeacherNotifier teacherNotifier = context.watch<TeacherNotifier>();
    AuthenticationNotifier authNotifier = context.watch<AuthenticationNotifier>();
    return Scaffold(
      appBar: AppAppbar(
        actions: [
          IconButton(
            splashRadius: 20,
            tooltip: "Reload",
            onPressed: () {
              setState(() {
                _fetchCourses = context
                    .read<TeacherNotifier>()
                    .fetchAllCourses();
              });
            },
            icon: const Icon(CupertinoIcons.arrow_clockwise),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select your courses",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(
              height: 0.01.sh,
            ),
            Text(
              "Select the courses you will be teaching through out your journey, you can always edit your courses list.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 3,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                    'In case of any query, kindly contact admin ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppTheme.unselectedItemColor),
                  ),
                  TextSpan(
                    text: "haseebzafar.dev@gmail.com",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.blue,
                        fontWeight: FontWeight.bold,
                        decorationStyle: TextDecorationStyle.dashed),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        BaseHelper.launchUrl(
                            'mailto:haseebzafar.dev@gmail.com');
                      },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0.01.sh,
            ),
            FutureBuilder(
                future: _fetchCourses,
                builder: (BuildContext context,
                    AsyncSnapshot<SelectCoursesModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(child: AppCircularIndicatorWidget());
                  } else if (snapshot.connectionState == ConnectionState.done && teacherNotifier.myCourses.data != null) {
                    if (teacherNotifier.myCourses.data!.isEmpty) {
                      return Expanded(
                        child: Center(
                            child: Text(
                              "No course have been added yet",
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: teacherNotifier.myCourses.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            CourseModel course = teacherNotifier.myCourses.data![index];
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
                                  '${teacherNotifier.myCourses.data?[index].courseName}',
                                  style: Theme.of(context).textTheme.displaySmall,
                                ),
                                subtitle: Text(
                                  '${teacherNotifier.myCourses.data?[index].courseCode}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: AppTheme.primaryColor,
                                value: course.selected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    course.selected = !course.selected!;
                                  });
                                },
                              ),
                            );
                          },
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
        child: teacherNotifier.checkCoursesSelections ? FloatingActionButton.extended(
            icon: const Icon(CupertinoIcons.check_mark, color: AppTheme.black,),
            onPressed: _trySubmit,
            label: Text(
              "Select",
              style: Theme.of(context).textTheme.bodyLarge,
            )) : const SizedBox.shrink(),
      ),
    );
  }
}
