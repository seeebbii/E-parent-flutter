import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/class/class.model.dart';
import 'package:e_parent_kit/core/models/teacherr/all_teachers.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/create_class.screen.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/manage_class.screen.dart';
import 'package:e_parent_kit/meta/views/teacher/classes/manage_student_academics.screen.dart';
import 'package:e_parent_kit/meta/views/teacher/classes/view_leave_requests.screen.dart';
import 'package:e_parent_kit/meta/views/teacher/classes/view_my_students.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'upload_attendance.screen.dart';
import 'upload_class_assignment.screen.dart';
import 'upload_class_diary.screen.dart';

class ManageAcademicReports extends StatefulWidget {
  const ManageAcademicReports({Key? key}) : super(key: key);

  @override
  State<ManageAcademicReports> createState() => _ManageAcademicReportsState();
}

class _ManageAcademicReportsState extends State<ManageAcademicReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 0.01.sh,
              ),
              Text(
                "Managing Academic Reports",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(
                height: 0.02.sh,
              ),

              // BuildListItemWidget(
              //   onTap: () {
              //     Get.to(() => UploadClassAssignmentScreen());
              //   },
              //   text: 'Upload Class Assignments',
              // ),

              BuildListItemWidget(
                onTap: () {
                  Get.to(() => ManageStudentAcademicsScreen());
                },
                text: 'Manage Student Academics',
              ),

              BuildListItemWidget(
                onTap: () {
                  Get.to(() => ManageStudentAcademicsScreen(view: true,));
                },
                text: 'View Student Academics',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
