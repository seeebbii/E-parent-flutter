import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
import 'package:e_parent_kit/core/models/diary/teacher_class_diary.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/notifiers/teacher.notifier.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/views/authentication/change_password.screen.dart';
import 'package:e_parent_kit/meta/views/main/dashboard/view_course.screen.dart';
import 'package:e_parent_kit/meta/views/teacher/classes/view_students_academics.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalBottomSheet;

import 'edit_profile.screen.dart';

class ProfileNavbarScreen extends StatefulWidget {
  const ProfileNavbarScreen({Key? key}) : super(key: key);

  @override
  State<ProfileNavbarScreen> createState() => _ProfileNavbarScreenState();
}

class _ProfileNavbarScreenState extends State<ProfileNavbarScreen> {
  ListTile _buildListTile(
      {required String title,
      required IconData icon,
      required VoidCallback? onTap,
      Color textColor = AppTheme.black,
      Color iconColor = AppTheme.black,
      Widget? subTitle,
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
      subtitle: subTitle,
      trailing: trailing,
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authNotifier =
        context.watch<AuthenticationNotifier>();
    ClassNotifier classNotifier = context.watch<ClassNotifier>();
    ParentNotifier parentNotifier = context.watch<ParentNotifier>();
    return Scaffold(
      backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Profile",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Text(
                    "Logged in as: ${authNotifier.authModel.user?.authRole?.name}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppTheme.unselectedItemColor),
                  ),
                ],
              ),
              Container(
                height: 150,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.logo,
                      height: 90,
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
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "${authNotifier.authModel.user?.email}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppTheme.unselectedItemColor),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Text(
                            "${authNotifier.authModel.user?.completePhone}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppTheme.unselectedItemColor),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 0.01.sh,
              ),
              SizedBox(
                  width: double.infinity,
                  child: AppElevatedButton(
                    onPressed: () {
                      Get.to(() => EditProfileScreen());
                    },
                    buttonText: 'Edit Profile',
                    textColor: AppTheme.whiteColor,
                    buttonColor: AppTheme.primaryColor,
                  )),
              SizedBox(
                height: 0.03.sh,
              ),
              _buildListTile(
                title: 'Change Password',
                icon: CupertinoIcons.lock,
                onTap: () => Get.to(() => ChangePasswordScreen(forgot: false,)),
              ),
              authNotifier.authModel.user!.authRole == Role.Parent
                  ? _buildListTile(
                      title: 'Currently Selected Student',
                      subTitle: Text(
                        "${parentNotifier.selectedStudentProfile!.fullName!}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      icon: CupertinoIcons.person_2,
                      onTap: null,
                    )
                  : _buildListTile(
                      title: 'My Options',
                      icon: CupertinoIcons.person_2,
                      onTap: () {
                        context
                            .read<BottomNavBarVM>()
                            .bottomNavBarController
                            .index = 0;
                      },
                    ),
              authNotifier.authModel.user!.authRole == Role.Parent ? _buildListTile(
                title: 'My Registered Students',
                icon: CupertinoIcons.person_2,
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
                                    .setStudentProfile(context,
                                        student: student);
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
              ) : SizedBox.shrink(),
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
                title: 'Log Out',
                icon: CupertinoIcons.power,
                onTap: () =>
                    context.read<AuthenticationNotifier>().logout(context),
                iconColor: AppTheme.red,
                textColor: AppTheme.red,
              ),
              SizedBox(
                height: 0.01.sh,
              ),
              SizedBox(
                height: 0.05.sh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
