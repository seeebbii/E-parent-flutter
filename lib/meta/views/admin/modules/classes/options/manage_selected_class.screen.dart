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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'assign_class_teacher.screen.dart';
import 'assign_students.screen.dart';

class ManageSelectedClassScreen extends StatefulWidget {
  const ManageSelectedClassScreen({Key? key}) : super(key: key);

  @override
  State<ManageSelectedClassScreen> createState() => _ManageSelectedClassScreenState();
}

class _ManageSelectedClassScreenState extends State<ManageSelectedClassScreen> {

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
                "Managing Class: ${classNotifier.selectedClass.grade}${classNotifier.selectedClass.section?.toUpperCase()}",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              BuildListItemWidget(
                onTap: () {
                  Get.to(() => AssignStudentsScreen());
                },
                text: 'Assign Students',
              ),
              BuildListItemWidget(
                onTap: () {
                  Get.to(() => AssignClassTeacherScreen(
                    isNewClass: false,
                  ));
                },
                text: 'Assign Class Teacher',
                subtitle: Text("Current Class Teacher: ${classNotifier.teacherAssigned.user?.fullName}", style: Theme.of(context).textTheme.bodySmall,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
