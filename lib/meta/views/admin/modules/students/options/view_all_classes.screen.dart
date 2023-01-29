import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/components/widgets/app_dob_textfield.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/components/widgets/app_phone_textfield.dart';
import 'package:e_parent_kit/components/widgets/app_simple_text_field.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
import 'package:e_parent_kit/core/models/course/select_course.model.dart';
import 'package:e_parent_kit/core/models/notification/notifications.model.dart';
import 'package:e_parent_kit/core/models/student/select_student.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/notifiers/student.notifier.dart';
import 'package:e_parent_kit/core/notifiers/teacher.notifier.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
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

import '../../../../../../core/models/class/class.model.dart';
import 'view_all_classes.screen.dart';

class ViewAllClassesScreen extends StatefulWidget {
  const ViewAllClassesScreen({Key? key}) : super(key: key);

  @override
  State<ViewAllClassesScreen> createState() => _ViewAllClassesScreenState();
}

class _ViewAllClassesScreenState extends State<ViewAllClassesScreen> {
  Future<void> _onRefresh() async {
    if (context.read<AuthenticationNotifier>().authModel.user?.authRole ==
        Role.TeacherAdmin) {
      // Fetch all classes
      await context.read<ClassNotifier>().fetchAllClasses();
    } else if (context
            .read<AuthenticationNotifier>()
            .authModel
            .user
            ?.authRole ==
        Role.Teacher) {
      // Fetch teacher classes only
      await context.read<ClassNotifier>().fetchAllClasses(
          teacherId:
              context.read<AuthenticationNotifier>().authModel.user!.sId!);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              "All Classes",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(
              height: 0.03.sh,
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppTheme.primaryColor,
                onRefresh: _onRefresh,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0
                  ),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: classNotifier.allClassesModel.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    ClassModel classItem = classNotifier.allClassesModel.data![index];
                    return InkWell(
                      splashColor: AppTheme.primaryColor,
                      highlightColor: Colors.transparent,
                      onTap: (){
                        classNotifier.assignClass(classItem);
                        navigationController.goBack();
                      },
                      child: Card(
                        elevation: 5,
                        color: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("${classItem.classTeacher?.fullName}", textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),),
                            Text("${classItem.grade}${classItem.section}", style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),),
                            Text("Student Count: ${classItem.studentsEnrolled?.length ?? 0}", style: Theme.of(context).textTheme.bodyMedium,),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
