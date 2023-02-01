import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/components/widgets/app_divider.dart';
import 'package:e_parent_kit/components/widgets/app_dob_textfield.dart';
import 'package:e_parent_kit/components/widgets/app_dropdown.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/class/academics.model.dart';
import 'package:e_parent_kit/core/models/class/class.model.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ViewStudentsAcademicsScreen extends StatefulWidget {
  const ViewStudentsAcademicsScreen({Key? key}) : super(key: key);

  @override
  State<ViewStudentsAcademicsScreen> createState() => _ViewStudentsAcademicsScreenState();
}

class _ViewStudentsAcademicsScreenState extends State<ViewStudentsAcademicsScreen> {

  Future<AcademicsModel>? _fetchRecords;

 @override
  void initState() {
   _fetchRecords = context.read<TeacherNotifier>().viewAcademics(context: context);
    super.initState();
  }

  Future<void> _onRefresh() async{
   await context.read<TeacherNotifier>().viewAcademics(context: context);
  }

  @override
  Widget build(BuildContext context) {
    TeacherNotifier teacherNotifier = context.watch<TeacherNotifier>();
    return Scaffold(
      appBar: AppAppbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
        child: Column(
          children: [
            SizedBox(height: 0.01.sh,),
            FutureBuilder(
                future: _fetchRecords,
                builder: (BuildContext context,
                    AsyncSnapshot<AcademicsModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(child: AppCircularIndicatorWidget());
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      teacherNotifier.academicsModel.data != null) {
                    if (teacherNotifier.academicsModel.data!.isEmpty) {
                      return Expanded(
                        child: Center(
                            child: Text(
                              "No academic records found",
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                      );
                    } else {
                      return Expanded(
                        child: RefreshIndicator(
                          color: AppTheme.primaryColor,
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: teacherNotifier.academicsModel.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              Record record = teacherNotifier.academicsModel.data![index];
                              return Padding(
                                padding:
                                EdgeInsets.symmetric(vertical: 0.005.sh),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0.03.sw, vertical: 0.01.sh),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${teacherNotifier.selectedCourse.courseName}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                          ),
                                          Text(
                                            "${teacherNotifier.selectedCourse.courseCode}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AppDivider(
                                        thickness: 3,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        '${record.title}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      AppDivider(
                                        thickness: 3,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Obtained Mark: ${record.obtainedMarks}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),

                                          Text(
                                            "Total Mark: ${record.totalMarks}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                        ],
                                      ), SizedBox(
                                        height: 0.02.sh,
                                      ),

                                      Text(
                                        "Uploaded by ${record.teacherId?.fullName} on ${BaseHelper.formatDateWithMonth(DateTime.parse(record.createdAt!))}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                                      ),

                                      SizedBox(
                                        height: 0.02.sh,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  } else {
                    return Expanded(
                      child: Center(
                          child: Text(
                            "No leave requests yet",
                            style: Theme.of(context).textTheme.bodyLarge,
                          )),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
