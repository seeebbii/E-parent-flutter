import 'package:e_parent_kit/core/notifiers/admin.notifier.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/chat.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/connection.notifier.dart';
import 'package:e_parent_kit/core/notifiers/course.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/notifiers/teacher.notifier.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/notifiers/student.notifier.dart';

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

        ChangeNotifierProvider<ParentNotifier>(
          create: (BuildContext context) => ParentNotifier(),
        ),

        ChangeNotifierProvider<TeacherNotifier>(
          create: (BuildContext context) => TeacherNotifier(),
        ),

        ChangeNotifierProvider<ChatNotifier>(
          create: (BuildContext context) => ChatNotifier(),
        ),

        ChangeNotifierProvider<StudentNotifier>(
          create: (BuildContext context) => StudentNotifier(),
        ),

        ChangeNotifierProvider<AdminNotifier>(
          create: (BuildContext context) => AdminNotifier(),
        ),

        ChangeNotifierProvider<CourseNotifier>(
          create: (BuildContext context) => CourseNotifier(),
        ),

        ChangeNotifierProvider<ClassNotifier>(
          create: (BuildContext context) => ClassNotifier(),
        ),


      ],
      child: child,
    );
  }
}
