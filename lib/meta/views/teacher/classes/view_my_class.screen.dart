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
import 'package:e_parent_kit/meta/views/teacher/classes/view_leave_requests.screen.dart';
import 'package:e_parent_kit/meta/views/teacher/classes/view_my_students.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'manage_academic_reports.screen.dart';
import 'upload_attendance.screen.dart';
import 'upload_class_diary.screen.dart';

class ViewMyClassScreen extends StatefulWidget {
  const ViewMyClassScreen({Key? key}) : super(key: key);

  @override
  State<ViewMyClassScreen> createState() => _ViewMyClassScreenState();
}

class _ViewMyClassScreenState extends State<ViewMyClassScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ClassNotifier classNotifier = context.watch<ClassNotifier>();
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
                "Viewing Class ${classNotifier.selectedClass.grade}${classNotifier.selectedClass.section}",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              BuildListItemWidget(
                onTap: () {
                  Get.to(() => UploadClassDiaryScreen());
                },
                text: 'Upload Class Diary',
              ),
              BuildListItemWidget(
                onTap: () {
                  Get.to(() => UploadAttendanceScreen());
                },
                text: 'Upload Attendance',
              ),
              BuildListItemWidget(
                onTap: () {
                  Get.to(() => ViewMyStudentsScreen());
                },
                text: 'View Students',
              ),
              BuildListItemWidget(
                onTap: () {
                  Get.to(() => ManageAcademicReports());
                },
                text: 'Manage Academic Reports',
              ),
              BuildListItemWidget(
                onTap: () {
                  Get.to(() => ViewLeaveRequestsScreen());
                },
                text: 'View Leave Requests',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
