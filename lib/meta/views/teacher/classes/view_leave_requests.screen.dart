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
import 'package:provider/provider.dart';

import 'upload_attendance.screen.dart';
import 'upload_class_diary.screen.dart';

class ViewLeaveRequestsScreen extends StatefulWidget {
  const ViewLeaveRequestsScreen({Key? key}) : super(key: key);

  @override
  State<ViewLeaveRequestsScreen> createState() =>
      _ViewLeaveRequestsScreenState();
}

class _ViewLeaveRequestsScreenState extends State<ViewLeaveRequestsScreen> {
  Future<LeaveRequestsModel>? _fetchAllRequests;

  @override
  void initState() {
    _fetchAllRequests =
        context.read<TeacherNotifier>().fetchAllLeaveRequests(context);

    super.initState();
  }

  Future<void> _onRefresh() async {
    await context.read<TeacherNotifier>().fetchAllLeaveRequests(context);
  }

  @override
  Widget build(BuildContext context) {
    TeacherNotifier teacherNotifier = context.watch<TeacherNotifier>();
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
              "Request Leaves",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            FutureBuilder(
                future: _fetchAllRequests,
                builder: (BuildContext context,
                    AsyncSnapshot<LeaveRequestsModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(child: AppCircularIndicatorWidget());
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      teacherNotifier.leaveRequestsModel.request != null) {
                    if (teacherNotifier.leaveRequestsModel.request!.isEmpty) {
                      return Expanded(
                        child: Center(
                            child: Text(
                          "No new leave requests",
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
                            itemCount: teacherNotifier
                                .leaveRequestsModel.request?.length,
                            itemBuilder: (BuildContext context, int index) {
                              Requests request = teacherNotifier
                                  .leaveRequestsModel.request![index];
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
                                      Text(
                                        'Leave Request From ${request.parentId?.fullName} for ${request.studentId?.fullName} on (${BaseHelper.formatDateWithMonth(DateTime.parse(request.dateForLeave!))})',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      AppDivider(
                                        thickness: 3,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Reason: ${request.reasonForLeave}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      SizedBox(
                                        height: 0.02.sh,
                                      ),
                                      request.leaveStatus != null
                                          ? Text(
                                              "Leave Request Status: ${request.leaveStatus}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall
                                                  ?.copyWith(
                                                      color:
                                                          request.leaveStatus ==
                                                                  true
                                                              ? AppTheme.green
                                                              : AppTheme.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            )
                                          : Row(
                                              children: [
                                                Expanded(
                                                    child: AppElevatedButton(
                                                  onPressed: () async {
                                                    EasyLoading.show();
                                                    await context.read<TeacherNotifier>().rejectLeaveRequest(request, context, index);
                                                    EasyLoading.dismiss();
                                                  },
                                                  buttonText: 'Reject',
                                                  textColor:
                                                      AppTheme.whiteColor,
                                                  buttonColor: AppTheme.red,
                                                )),
                                                SizedBox(
                                                  width: 0.01.sw,
                                                ),
                                                Expanded(
                                                    child: AppElevatedButton(
                                                  onPressed: () async {
                                                    EasyLoading.show();
                                                    await context.read<TeacherNotifier>().acceptLeaveRequest(request, context, index);
                                                    EasyLoading.dismiss();
                                                  },
                                                  buttonText: 'Accept',
                                                  textColor:
                                                      AppTheme.whiteColor,
                                                  buttonColor: AppTheme.green,
                                                )),
                                              ],
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
                        "No new leave requests",
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
