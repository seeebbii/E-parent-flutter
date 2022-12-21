import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/connection.notifier.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/hive_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

    super.initState();
    Provider.of<ConnectionNotifier>(context, listen: false).initConnectivity();
    // Future.delayed(const Duration(seconds: 3), () {
    //   // LOGGED IN ? HOME PAGE : AUTH SCREEN
    //   if(HiveDatabase.getValue(HiveDatabase.loginCheck) == true){
    //     /// Fetching user's profile if the user is already logged in
    //     // context.read<AuthenticationNotifier>().fetchUserProfile();
    //     navigationController.getOffAll(RouteGenerator.rootScreen);
    //
    //   }else{
    //     navigationController.getOffAll(RouteGenerator.loginScreen);
    //   }
    // });
  }


  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SvgPicture.asset(Assets.splashLogo,)),
    );
  }
}

