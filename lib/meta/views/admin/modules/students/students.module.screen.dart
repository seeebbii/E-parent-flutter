import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/components/widgets/app_dob_textfield.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
import 'package:e_parent_kit/core/models/course/select_course.model.dart';
import 'package:e_parent_kit/core/models/notification/notifications.model.dart';
import 'package:e_parent_kit/core/models/student/select_student.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
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

import 'options/create_student.screen.dart';
import 'options/manage_enrollment.screen.dart';

class StudentsModuleScreen extends StatefulWidget {
  const StudentsModuleScreen({Key? key}) : super(key: key);

  @override
  State<StudentsModuleScreen> createState() => _StudentsModuleScreenState();
}

class _StudentsModuleScreenState extends State<StudentsModuleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(),
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
                "Students Module",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              BuildListItemWidget(
                onTap: () {
                  Get.to(() => CreateStudentScreen());
                },
                text: 'Create Student',
              ),

              BuildListItemWidget(
                onTap: () {
                  Get.to(() => ManageEnrollmentScreen());
                },
                text: 'Manage Enrollment',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
