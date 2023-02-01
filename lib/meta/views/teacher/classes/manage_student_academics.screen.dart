import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_divider.dart';
import 'package:e_parent_kit/components/widgets/app_dob_textfield.dart';
import 'package:e_parent_kit/components/widgets/app_dropdown.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/class/class.model.dart';
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
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'view_student_courses.screen.dart';

class ManageStudentAcademicsScreen extends StatefulWidget {
  bool view;
  ManageStudentAcademicsScreen({Key? key, this.view = false}) : super(key: key);

  @override
  State<ManageStudentAcademicsScreen> createState() => _ManageStudentAcademicsScreenState();
}

class _ManageStudentAcademicsScreenState extends State<ManageStudentAcademicsScreen> {
  @override
  Widget build(BuildContext context) {
    ClassNotifier classNotifier = context.watch<ClassNotifier>();
    ParentNotifier parentNotifier = context.watch<ParentNotifier>();
    TeacherNotifier teacherNotifier = context.watch<TeacherNotifier>();
    return Scaffold(
      appBar: AppAppbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.01.sh,),
            Text(
              "Students of class ${classNotifier.selectedClass.grade}${classNotifier.selectedClass.section}",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(height: 0.01.sh,),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: classNotifier.selectedClass.studentsEnrolled?.length,
                itemBuilder: (BuildContext context, int index) {
                  StudentModel student = classNotifier.selectedClass.studentsEnrolled![index];
                  return InkWell(
                    splashColor: AppTheme.primaryColor,
                    highlightColor: Colors.transparent,
                    onTap: (){
                      teacherNotifier.assignStudent(student);
                      Get.to(() => ViewStudentCourseScreen(view: widget.view));
                    },
                    child: Card(
                      elevation: 5,
                      color: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${student.fullName}", style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
