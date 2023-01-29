import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/course.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalBottomSheet;
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../../main/after_auth/update_student.screen.dart';

class DrawerContent extends StatefulWidget {
  const DrawerContent({
    Key? key,
  }) : super(key: key);

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  @override
  void initState() {
    // Fetching notifications api
    context.read<AuthenticationNotifier>().fetchNotifications();

    if(context.read<AuthenticationNotifier>().authModel.user?.authRole == Role.TeacherAdmin){
      // Fetch all classes
      context.read<ClassNotifier>().fetchAllClasses();
    }else if(context.read<AuthenticationNotifier>().authModel.user?.authRole == Role.Teacher){
      // Fetch teacher classes only
      context.read<ClassNotifier>().fetchAllClasses(teacherId: context.read<AuthenticationNotifier>().authModel.user!.sId!);
    }

    super.initState();
  }

  ListTile _buildListTile(
      {required String title,
      String subTitle = '',
      required IconData icon,
      required VoidCallback onTap,
      Color textColor = AppTheme.black,
      Color iconColor = AppTheme.black,
      Widget? trailing}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(
        title,
        style:
            Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor),
      ),
      trailing: trailing,
    );
  }

  Widget _buildAdminOptions() {
    return Column(
      children: [
        // _buildListTile(
        //   title: 'Admin Settings',
        //   icon: CupertinoIcons.person_alt_circle_fill,
        //   onTap: () {},
        // ),
      ],
    );
  }

  Widget _buildParentOptions() {
    return Column(
      children: [
        _buildListTile(
          title: 'Switch Student',
          icon: CupertinoIcons.shuffle,
          onTap: () {
            modalBottomSheet.showMaterialModalBottomSheet(
              elevation: 15,
              enableDrag: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              )),
              context: context,
              builder: (context) => Container(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: context
                        .watch<AuthenticationNotifier>()
                        .authModel
                        .parentData
                        ?.students
                        ?.length,
                    itemBuilder: (context, index) {
                      StudentModel? student = context
                          .watch<AuthenticationNotifier>()
                          .authModel
                          .parentData
                          ?.students?[index];
                      return ListTile(
                        onTap: () {
                          context
                              .read<ParentNotifier>()
                              .setStudentProfile(context, student: student);
                          navigationController.goBack();
                        },
                        selected: context
                                .watch<ParentNotifier>()
                                .selectedStudentProfile
                                ?.sId ==
                            student?.sId,
                        title: Text(
                          "${student?.fullName}",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        trailing: Radio<bool>(
                          activeColor: AppTheme.primaryColor,
                          value: context
                                  .watch<ParentNotifier>()
                                  .selectedStudentProfile
                                  ?.sId ==
                              student?.sId,
                          groupValue: true,
                          onChanged: (bool? value) {},
                        ),
                      );
                    }),
              ),
            );
          },
        ),
        _buildListTile(
          title: 'Add Students',
          icon: CupertinoIcons.add_circled,
          onTap: () => Get.to(() => UpdateStudentsScreen()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // var appVM = context.watch<AppVM>();
    // var loginVM = context.watch<LoginVM>();
    AuthenticationNotifier authNotifier =
        context.watch<AuthenticationNotifier>();
    return SafeArea(
      child: Container(
        color: AppTheme.primaryColor.withOpacity(0.01),
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 0.02.sw),
                height: 100,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.logo,
                      height: 50,
                    ),
                    Expanded(
                        child: ListTile(
                      title: Text(
                        "${authNotifier.authModel.user?.fullName}",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(color: AppTheme.black),
                      ),
                      subtitle: Text(
                        "${authNotifier.authModel.user?.email}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppTheme.unselectedItemColor),
                      ),
                    )),
                  ],
                ),
              ),
              _buildListTile(
                title: 'Dashboard',
                icon: CupertinoIcons.home,
                onTap: () {
                  context
                      .read<BottomNavBarVM>()
                      .advancedDrawerController
                      .hideDrawer();
                  context.read<BottomNavBarVM>().bottomNavBarController.index =
                      0;
                },
              ),
              authNotifier.authModel.user?.authRole == Role.Parent
                  ? _buildParentOptions()
                  : const SizedBox.shrink(),
              _buildListTile(
                  title: 'Notifications',
                  icon: CupertinoIcons.bell,
                  onTap: () {
                    context
                        .read<BottomNavBarVM>()
                        .advancedDrawerController
                        .hideDrawer();
                    navigationController
                        .navigateToNamed(RouteGenerator.notificationScreen);
                  },
                  trailing: authNotifier.notificationsModel.count != null &&
                          authNotifier.notificationsModel.count != 0
                      ? badges.Badge(
                          badgeContent: Text(
                            "${authNotifier.notificationsModel.count ?? 0}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: AppTheme.whiteColor, fontSize: 10),
                          ),
                          badgeStyle: badges.BadgeStyle(
                            padding: EdgeInsets.all(6),
                            elevation: 5,
                          ))
                      : null),
              _buildListTile(
                title: 'Profile',
                icon: CupertinoIcons.person,
                onTap: () {
                  context
                      .read<BottomNavBarVM>()
                      .advancedDrawerController
                      .hideDrawer();
                  context.read<BottomNavBarVM>().bottomNavBarController.index =
                      3;
                },
              ),
              authNotifier.authModel.user?.authRole == Role.TeacherAdmin
                  ? _buildAdminOptions()
                  : const SizedBox.shrink(),
              const Spacer(),
              ListTile(
                title: Text(
                  "Logged in as: ${authNotifier.authModel.user?.authRole?.name}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppTheme.unselectedItemColor),
                ),
              ),
              Divider(
                color: AppTheme.dividerColor.withOpacity(0.4),
                thickness: 1,
                indent: 20,
                endIndent: 50,
              ),
              _buildListTile(
                title: 'Log Out',
                icon: CupertinoIcons.power,
                onTap: () =>
                    context.read<AuthenticationNotifier>().logout(context),
                iconColor: AppTheme.red,
                textColor: AppTheme.red,
              ),
              SizedBox(
                height: 0.02.sh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
