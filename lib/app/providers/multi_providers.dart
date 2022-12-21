import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/connection.notifier.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MultiProviders extends StatelessWidget {
  const MultiProviders(this.child, {Key? key}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider<ConnectionNotifier>(
          create: (BuildContext context) => ConnectionNotifier(),
        ),

        ChangeNotifierProvider<AuthenticationScreenVM>(
          create: (BuildContext context) => AuthenticationScreenVM(),
        ),

        ChangeNotifierProvider<AuthenticationNotifier>(
          create: (BuildContext context) => AuthenticationNotifier(),
        ),

        ChangeNotifierProvider<BottomNavBarVM>(
          create: (BuildContext context) => BottomNavBarVM(),
        ),


      ],
      child: child,
    );
  }
}
