import 'package:e_parent_kit/meta/views/admin/modules/accounts/manage_accounts.module.screen.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/classes.module.screen.dart';
import 'package:e_parent_kit/meta/views/admin/modules/courses/courses.module.screen.dart';
import 'package:e_parent_kit/meta/views/admin/modules/parents/parents.module.screen.dart';
import 'package:e_parent_kit/meta/views/admin/modules/requests/admin_requests.module.screen.dart';
import 'package:e_parent_kit/meta/views/admin/modules/students/students.module.screen.dart';
import 'package:e_parent_kit/meta/views/admin/modules/teachers/teachers.module.screen.dart';
import 'package:e_parent_kit/meta/views/authentication/change_password.screen.dart';
import 'package:e_parent_kit/meta/views/authentication/forgot_password.screen.dart';
import 'package:e_parent_kit/meta/views/authentication/login.screen.dart';
import 'package:e_parent_kit/meta/views/authentication/otp.screen.dart';
import 'package:e_parent_kit/meta/views/authentication/signup.screen.dart';
import 'package:e_parent_kit/meta/views/main/after_auth/add_courses.screen.dart';
import 'package:e_parent_kit/meta/views/main/after_auth/add_students.screen.dart';
import 'package:e_parent_kit/meta/views/main/chat/chat_room.screen.dart';
import 'package:e_parent_kit/meta/views/main/chat/contact_admin.screen.dart';
import 'package:e_parent_kit/meta/views/notification/notification.screen.dart';
import 'package:e_parent_kit/meta/views/root/root.screen.dart';
import 'package:e_parent_kit/meta/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  // TODO : ROUTES GENERATOR CLASS THAT CONTROLS THE FLOW OF NAVIGATION/ROUTING

  static String lastRoute = '';

  // WELCOME ROUTE
  static const String splashScreen = '/splash-screen';

  // AUTH ROUTE
  static const String loginScreen = '/login-screen';
  static const String forgotPasswordScreen = '/forgot-password-screen';
  static const String otpScreen = '/otp-screen';
  static const String resetPasswordScreen = '/reset-password-screen';
  static const String changePassword = '/change-password-screen';
  static const String signupScreen = '/signup-screen';

  // AFTER AUTH
  static const String addCoursesScreen = '/add-courses-screen';
  static const String addStudentsScreen = '/add-students-screen';

  // HOME ROUTES
  static const String rootScreen = '/root-screen';
  static const String contactAdminChatScreen = '/contact-admin-chat-screen';
  static const String chatRoomScreen = '/chat-room-screen';

  // Notification
  static const String notificationScreen = '/notification-screen';

  // Admin Modules
  static const String studentsModuleScreen = '/students-module-screen';
  static const String coursesModuleScreen = '/courses-module-screen';
  static const String classesModuleScreen = '/classes-module-screen';
  static const String parentsModuleScreen = '/parents-module-screen';
  static const String teachersModuleScreen = '/teachers-module-screen';
  static const String adminRequestsModuleScreen =
      '/adin-requests-module-screen';
  static const String accountsModuleScreen = '/accounts-module-screen';

  // FUNCTION THAT HANDLES ROUTING
  static Route<dynamic>? onGeneratedRoutes(RouteSettings settings) {
    Map<String, dynamic> args = {};

    // GETTING ARGUMENTS IF PASSED
    if (settings.arguments != null) {
      args = settings.arguments as Map<String, dynamic>;
      debugPrint("${settings.arguments}");
    }
    debugPrint(settings.name);

    switch (settings.name) {
      case splashScreen:
        return _getPageRoute(const SplashScreen());

      // case rootScreen:
      //   return _getPageRoute(const BottomNavigationBarScreen(), rootScreen);

      case loginScreen:
        return _getPageRoute(const LoginScreen());

      case signupScreen:
        return _getPageRoute(SignupScreen(
          isParent: args['isParent'],
        ));

      case forgotPasswordScreen:
        return _getPageRoute(const ForgotPasswordScreen());

      case otpScreen:
        return _getPageRoute(OtpScreen(
          isVerification: args['isVerification'],
        ));

      case rootScreen:
        return _getPageRoute(const RootScreen());

      case changePassword:
        return _getPageRoute(const ChangePasswordScreen());

      case addCoursesScreen:
        return _getPageRoute(const AddCoursesScreen());

      case addStudentsScreen:
        return _getPageRoute(const AddStudentsScreen());

      case contactAdminChatScreen:
        return _getPageRoute(const ContactAdminScreen());

      case notificationScreen:
        return _getPageRoute(const NotificationScreen());

      case chatRoomScreen:
        return _getPageRoute(ChatRoomScreen(
          chattingWith: args['chattingWith'],
          roomId: args['roomId'],
        ));

      case studentsModuleScreen:
        return _getPageRoute(const StudentsModuleScreen());

      case coursesModuleScreen:
        return _getPageRoute(const CoursesModuleScreen());

      case classesModuleScreen:
        return _getPageRoute(const ClassesModuleScreen());

      case parentsModuleScreen:
        return _getPageRoute(const ParentsModuleScreen());

      case teachersModuleScreen:
        return _getPageRoute(const TeachersModuleScreen());

      case adminRequestsModuleScreen:
        return _getPageRoute(const AdminRequestsModuleScreen());

      case accountsModuleScreen:
        return _getPageRoute(const ManageAccountsModuleScreen());

      default:
        return null;
    }
  }

  // FUNCTION THAT HANDLES NAVIGATION
  static PageRoute _getPageRoute(
    Widget child,
  ) {
    // return MaterialPageRoute(builder: (ctx) => child);
    return PageTransition(child: child, type: PageTransitionType.fade);
  }

  // 404 PAGE
  static PageRoute _errorRoute() {
    return MaterialPageRoute(builder: (ctx) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('404'),
        ),
        body: const Center(
          child: Text('ERROR 404: Not Found'),
        ),
      );
    });
  }
}
