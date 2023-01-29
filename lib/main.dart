import 'package:e_parent_kit/app/translation/languages.dart';
import 'package:e_parent_kit/core/notifiers/connection.notifier.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app/providers/multi_providers.dart';
import 'core/controller/navigation_controller.dart';
import 'core/notifications/notification_service.dart';
import 'meta/utils/hive_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(NavigationController());
  await SharedPref.init();
  await ConnectionNotifier().initConnectivity();
  await HiveDatabase.init();
  NotificationInitilization.initializePushNotifications();
  Languages.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // CHECKING IF THE USER IS PRE LOGGED IN
    if(HiveDatabase.getValue(HiveDatabase.loginCheck) != true){
      HiveDatabase.storeValue(HiveDatabase.authToken, "null");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(),
      child: ScreenUtilInit(
          builder: (_, w) => MultiProviders(
            GetMaterialApp(
              onGenerateRoute: RouteGenerator.onGeneratedRoutes,
              title: "E parent school kit",
              debugShowCheckedModeBanner: false,
              translations: Languages(),
              locale: Get.locale ?? Languages.locale,
              fallbackLocale: Languages.fallbackLocale,
              initialRoute: RouteGenerator.splashScreen,
              theme: AppTheme.lightTheme,
              builder: EasyLoading.init(),
            ),
          )
      ),
    );
  }
}


