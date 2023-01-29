import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
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
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    context.read<AuthenticationNotifier>().fetchNotifications();
    super.initState();
  }

  Future<void> _onRefresh() async {
    await context.read<AuthenticationNotifier>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authNotifier = context.watch<AuthenticationNotifier>();
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
              "Notifications",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(
              height: 0.02.sh,
            ),

            authNotifier.notificationsModel.notifications != null && authNotifier.notificationsModel.notifications!.isNotEmpty ?
            Expanded(
              flex: 1,
              child: RefreshIndicator(
                color: AppTheme.primaryColor,
                onRefresh: _onRefresh,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: authNotifier.notificationsModel.notifications?.length,
                  itemBuilder: (BuildContext context, int index) {
                    Notifications notification = authNotifier.notificationsModel.notifications![index];
                    return Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.005.sh),
                        child: Dismissible(
                          direction: notification.read! ? DismissDirection.none:  DismissDirection.startToEnd,
                          key: ValueKey("${notification.sId}"),
                          background: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppTheme.primaryColor,
                            ),
                            child: Align(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    CupertinoIcons.bell_slash,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Read",
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.whiteColor),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                          onDismissed: (DismissDirection direction){
                            authNotifier.readNotification(notification.sId!);

                            if(direction.index == DismissDirection.startToEnd){
                              authNotifier.notificationsModel.count = authNotifier.notificationsModel.count! - 1;
                              setState(() {
                                notification.read = true;
                              });
                            }
                          },
                          onUpdate: (details){
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0.01.sh, horizontal: 0.03.sw),
                            onTap: () {},
                            tileColor: notification.read! ? Colors.transparent :Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12)),
                            leading: CircleAvatar(
                              backgroundColor: AppTheme.primaryColor,
                              radius: 20,
                              child: Icon(CupertinoIcons.bell, color: AppTheme.whiteColor,),
                            ),
                            title: Text(
                              '${notification.title}',
                              style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("${notification.description}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                  color:
                                  AppTheme.unselectedItemColor,
                                  overflow: TextOverflow.visible),
                            ),
                            trailing: Text(
                              getTimeAgo(DateTime.parse(
                                  "${notification.sentAt}")),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                  color: AppTheme.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ));
                  },
                ),
              ),
            )
            : Expanded(
              child: Center(
                  child: Text(
                    "No new notification",
                    style: Theme.of(context).textTheme.bodyLarge,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
