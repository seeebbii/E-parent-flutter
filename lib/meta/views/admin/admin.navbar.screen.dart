import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/views/admin/widgets/gridview_item.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AdminNavbarScreen extends StatefulWidget {
  const AdminNavbarScreen({Key? key}) : super(key: key);

  @override
  State<AdminNavbarScreen> createState() => _AdminNavbarScreenState();
}

class _AdminNavbarScreenState extends State<AdminNavbarScreen> {
  @override
  Widget build(BuildContext context) {
    BottomNavBarVM bottomNavBarVM = context.watch<BottomNavBarVM>();
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
              Text(
                "Admin Dashboard",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              GridView.extent(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                maxCrossAxisExtent: 200.0,
                children: <Widget>[
                  GridviewItemWidget(
                    onTap: () => navigationController.navigateToNamed(RouteGenerator.studentsModuleScreen),
                    imagePath: Assets.studentsIcon,
                    text: 'Students',
                    color: Colors.purple.shade100,
                  ),
                  GridviewItemWidget(
                    onTap:  () => navigationController.navigateToNamed(RouteGenerator.coursesModuleScreen),
                    imagePath: Assets.courseIcon,
                    text: 'Courses',
                    color: Colors.yellow.shade100,
                  ),
                  GridviewItemWidget(
                    onTap:  () => navigationController.navigateToNamed(RouteGenerator.classesModuleScreen),
                    imagePath: Assets.classIcon,
                    text: 'Classes',
                    color: Colors.deepOrangeAccent.shade100,
                  ),
                  GridviewItemWidget(
                    onTap:  () => navigationController.navigateToNamed(RouteGenerator.parentsModuleScreen),
                    imagePath: Assets.parentsIcon,
                    text: 'Parents',
                    color: Colors.blue.shade100,
                  ),
                  GridviewItemWidget(
                    onTap:  () => navigationController.navigateToNamed(RouteGenerator.teachersModuleScreen),
                    imagePath: Assets.teachersIcon,
                    text: 'Teachers',
                    color: Colors.green.shade100,
                  ),
                  GridviewItemWidget(
                    onTap:  () => navigationController.navigateToNamed(RouteGenerator.adminRequestsModuleScreen),
                    imagePath: Assets.adminRequest,
                    text: 'Admin Requests',
                    color: Colors.brown.shade200,
                  ),
                  GridviewItemWidget(
                    onTap:  () => navigationController.navigateToNamed(RouteGenerator.accountsModuleScreen),
                    imagePath: Assets.accountIcon,
                    text: 'Manage Accounts',
                    color: Colors.red.shade200,
                  ),
                ],
              ),
              SizedBox(
                height: 0.03.sh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
