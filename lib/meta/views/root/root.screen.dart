import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/views/root/widgets/bottom_nav_widget.dart';
import 'package:e_parent_kit/meta/views/root/widgets/drawer_content_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  DateTime? currentBackPressTime;

  Future<bool> confirmBackTap() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime ?? DateTime.now()) >
            const Duration(seconds: 2)) {
      currentBackPressTime = now;
      BaseHelper.showSnackBar("Press again to exit the app");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();
    // If the role is parent, select first student as current student profile by default
    if(context.read<AuthenticationNotifier>().authModel.user?.authRole == Role.Parent){
      context.read<ParentNotifier>().setStudentProfile(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    BottomNavBarVM bottomNavBarVM = context.watch<BottomNavBarVM>();
    return AdvancedDrawer(
      backdropColor: AppTheme.primaryColor.withOpacity(0.5),
      controller: bottomNavBarVM.advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.primaryColor,
            blurRadius: 8.0,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: const DrawerContent(),
      child: Scaffold(
        appBar: AppAppbar(
          elevation: 0,
          bgColor: AppTheme.primaryColor.withOpacity(0.24),
          leadingWidget: IconButton(
            splashRadius: 20,
            onPressed: () =>
                bottomNavBarVM.advancedDrawerController.showDrawer(),
            icon: const Icon(CupertinoIcons.line_horizontal_3),
          ),
          actions: [
            bottomNavBarVM.bottomNavBarController.index == 2 ?
                IconButton(splashRadius: 20, icon: Icon(CupertinoIcons.person_crop_circle_badge_checkmark),
                  onPressed: () => navigationController.navigateToNamed(RouteGenerator.contactAdminChatScreen),) : const SizedBox.shrink()
          ],
        ),
        body: BottomNavWidget(),
      ),
    );
  }
}
