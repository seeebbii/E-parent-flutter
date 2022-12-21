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
  static const String otpVerificationScreen = '/otp-verification-screen';
  static const String resetPasswordScreen = '/reset-password-screen';
  static const String changePassword = '/change-password-screen';
  static const String signupScreen = '/signup-screen';

  // HOME ROUTES
  static const String rootScreen = '/root-screen';

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
        return _getPageRoute(const SplashScreen(), splashScreen);

      // case rootScreen:
      //   return _getPageRoute(const BottomNavigationBarScreen(), rootScreen);


      // case orderDetailsScreen:
      //   return _getPageRoute(const OrderDetailScreen());

      // case createAdScreen:
      //   return _getPageRoute(CreateAdScreen(
      //     isUpdate: args['isUpdate'],
      //   ));

      default:
        return null;
    }
  }

  // FUNCTION THAT HANDLES NAVIGATION
  static PageRoute _getPageRoute(Widget child, routeName) {
    lastRoute = routeName;
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
