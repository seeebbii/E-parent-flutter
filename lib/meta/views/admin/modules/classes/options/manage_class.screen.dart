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

import 'manage_selected_class.screen.dart';


class ManageClassScreen extends StatefulWidget {
  const ManageClassScreen({Key? key}) : super(key: key);

  @override
  State<ManageClassScreen> createState() => _ManageClassScreenState();
}

class _ManageClassScreenState extends State<ManageClassScreen> {

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
          teacherId: context.read<AuthenticationNotifier>().authModel.user!.sId!);
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
              "Select a class to manage",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(
              height: 0.02.sh,
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
                        classNotifier.assignTeacher(TeachersDataList(user: classNotifier.selectedClass.classTeacher));
                        Get.to(() => ManageSelectedClassScreen());
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
            SizedBox(
              height: 0.01.sh,
            ),
          ],
        ),
      ),
    );
  }
}
