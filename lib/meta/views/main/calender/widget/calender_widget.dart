import 'dart:math';

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
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;

class CalenderWidget extends StatefulWidget {
  const CalenderWidget({Key? key}) : super(key: key);

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  late double cHeight;


  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {

    cHeight = MediaQuery.of(context).size.height;

    return CalendarCarousel(
      headerTextStyle: Theme.of(context).textTheme.displayMedium,
      height: cHeight * 0.54,
      weekdayTextStyle: Theme.of(context).textTheme.bodyLarge,
      iconColor: AppTheme.primaryColor,
      maxSelectedDate: DateTime.now(),
      todayBorderColor: Colors.red,
      selectedDayButtonColor: AppTheme.primaryColor,
      selectedDayBorderColor: AppTheme.primaryColor,
      selectedDayTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.whiteColor),
      weekendTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.red),
      daysTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold,),
      todayButtonColor: Colors.transparent,
      todayTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold,),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal: null, // null for not showing hidden events indicator
      showOnlyCurrentMonthDate: true,
      selectedDateTime: selectedDate,
      onDayPressed: (DateTime date, List<EventInterface> event){
        setState(() {
          selectedDate = date;
        });
        context.read<ParentNotifier>().fetchStudentAttendance(selectedDate: date.toIso8601String());
      },
    );
  }
}
