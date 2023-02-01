import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/views/admin/admin.navbar.screen.dart';
import 'package:e_parent_kit/meta/views/main/calender/calender.navbar.screen.dart';
import 'package:e_parent_kit/meta/views/main/chat/chat.navbar.screen.dart';
import 'package:e_parent_kit/meta/views/main/dashboard/dashboard.navbar.screen.dart';
import 'package:e_parent_kit/meta/views/main/profile/profile.navbar.screen.dart';
import 'package:e_parent_kit/meta/views/teacher/teacher_navbar.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';

class BottomNavBarVM extends ChangeNotifier {

  int _currentPageIndex = 0;
  int _homePageIndex = 0;
  int get currentPageIndex => _currentPageIndex;
  int get homePageIndex => _homePageIndex;

  bool _isVisible = true;
  bool get isVisible => _isVisible;

  PageController homePageViewController = PageController();

  PersistentTabController bottomNavBarController = PersistentTabController(initialIndex: 0);
  final AdvancedDrawerController advancedDrawerController = AdvancedDrawerController();

  List<Widget> screens(BuildContext context){
    AuthenticationNotifier authNotifier = context.watch<AuthenticationNotifier>();

    // Render screens according to roles
    if(authNotifier.authModel.user!.authRole == Role.Parent){
      return const [
        DashboardNavbarScreen(),
        CalenderNavbarScreen(),
        ChatNavbarScreen(),
        ProfileNavbarScreen(),
      ];
    }else if(authNotifier.authModel.user!.authRole == Role.TeacherAdmin){

      return const [
        AdminNavbarScreen(),
        ChatNavbarScreen(),
        ProfileNavbarScreen(),
      ];

    }else{
      return const [
        TeacherNavbarScreen(),
        ChatNavbarScreen(),
        ProfileNavbarScreen(),
      ];
    }
  }


  List<PersistentBottomNavBarItem> bottomNavbarItems(BuildContext context){
    AuthenticationNotifier authNotifier = context.watch<AuthenticationNotifier>();

    if(authNotifier.authModel.user!.authRole == Role.Parent){
      return [
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.home),
          title: ("Dashboard"),
          activeColorPrimary: AppTheme.primaryColor,
          inactiveColorPrimary: AppTheme.subtitleLightGreyColor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.calendar_today),
          title: ("Attendance"),
          activeColorPrimary: AppTheme.primaryColor,
          inactiveColorPrimary: AppTheme.subtitleLightGreyColor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.chat_bubble_2),
          title: ("Chat"),
          activeColorPrimary: AppTheme.primaryColor,
          inactiveColorPrimary: AppTheme.subtitleLightGreyColor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.person),
          title: ("Profile"),
          activeColorPrimary: AppTheme.primaryColor,
          inactiveColorPrimary: AppTheme.subtitleLightGreyColor,
        ),
      ];
    }else if(authNotifier.authModel.user!.authRole == Role.TeacherAdmin){

      return [
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.home),
          title: ("Dashboard"),
          activeColorPrimary: AppTheme.primaryColor,
          inactiveColorPrimary: AppTheme.subtitleLightGreyColor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.chat_bubble_2),
          title: ("Chat"),
          activeColorPrimary: AppTheme.primaryColor,
          inactiveColorPrimary: AppTheme.subtitleLightGreyColor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.person),
          title: ("Profile"),
          activeColorPrimary: AppTheme.primaryColor,
          inactiveColorPrimary: AppTheme.subtitleLightGreyColor,
        ),
      ];

    }else{
      return [
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.home),
          title: ("Dashboard"),
          activeColorPrimary: AppTheme.primaryColor,
          inactiveColorPrimary: AppTheme.subtitleLightGreyColor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.chat_bubble_2),
          title: ("Chat"),
          activeColorPrimary: AppTheme.primaryColor,
          inactiveColorPrimary: AppTheme.subtitleLightGreyColor,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.person),
          title: ("Profile"),
          activeColorPrimary: AppTheme.primaryColor,
          inactiveColorPrimary: AppTheme.subtitleLightGreyColor,
        ),
      ];
    }

  }


  void updateCurrentPageIndex(int page){
    _currentPageIndex = page;
    notifyListeners();
  }

  void updateNavBarVisibility(bool val) {
    _isVisible = val;
    notifyListeners();
  }

}
