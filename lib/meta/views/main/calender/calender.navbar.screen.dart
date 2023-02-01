import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/components/widgets/app_divider.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/class/class.model.dart';
import 'package:e_parent_kit/core/models/student/leave_requests.model.dart';
import 'package:e_parent_kit/core/models/teacherr/all_teachers.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/notifiers/teacher.notifier.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/create_class.screen.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/manage_class.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;

import 'widget/calender_widget.dart';

class CalenderNavbarScreen extends StatefulWidget {
  const CalenderNavbarScreen({Key? key}) : super(key: key);

  @override
  State<CalenderNavbarScreen> createState() => _CalenderNavbarScreenState();
}

class _CalenderNavbarScreenState extends State<CalenderNavbarScreen> {

  @override
  void initState() {
    context.read<ParentNotifier>().fetchStudentAttendance(selectedDate: DateFormat("MM/dd/yyyy").format(DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ParentNotifier parentNotifier = context.watch<ParentNotifier>();
    return Scaffold(
      backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
          child: Column(
            children: [
              CalenderWidget(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text("P", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.green),),
                      Text(" : Present", style: Theme.of(context).textTheme.displaySmall,),
                    ],
                  ),
                  Row(
                    children: [
                      Text("A", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.red),),
                      Text(" : Absent", style: Theme.of(context).textTheme.displaySmall,),
                    ],
                  ),
                  Row(
                    children: [
                      Text("L", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.blue),),
                      Text(" : Leave", style: Theme.of(context).textTheme.displaySmall,),
                    ],
                  ),
                ],
              ),
              parentNotifier.studentsAttendanceModel.success == null ?
              Container(height: 0.2.sh , child: Center(child: Text("No Record Found", style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),)))
                  : ListTile(title: Text("Attendance Status: ${parentNotifier.studentsAttendanceModel.data!.first.attendanceStatus}", style: Theme.of(context).textTheme.displaySmall,),),
            ],
          ),
        ),
      ),
    );
  }
}
