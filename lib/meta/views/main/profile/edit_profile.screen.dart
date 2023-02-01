import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/components/widgets/app_elevated_button.dart';
import 'package:e_parent_kit/components/widgets/app_simple_text_field.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
import 'package:e_parent_kit/core/models/diary/teacher_class_diary.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/notifiers/teacher.notifier.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/views/main/dashboard/view_course.screen.dart';
import 'package:e_parent_kit/meta/views/teacher/classes/view_students_academics.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modalBottomSheet;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    AuthenticationScreenVM authVM = context.read<AuthenticationScreenVM>();
    AuthenticationNotifier authNotifier = context.read<AuthenticationNotifier>();
    authVM.nameController.text = authNotifier.authModel.user?.fullName ?? '';

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  void _trySubmit() async {
    AuthenticationScreenVM authVM = Provider.of(context, listen: false);
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      EasyLoading.show();
      await context.read<AuthenticationNotifier>().updateProfile(
            userId: context.read<AuthenticationNotifier>().authModel.user!.sId!,
            fullName: authVM.nameController.text.trim(),
          );

      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationScreenVM authVM = Provider.of(context, listen: true);
    return Scaffold(
      appBar: AppAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 0.03.sh,
                ),
                AppSimpleTextField(
                  controller: authVM.nameController,
                  keyboard: TextInputType.text,
                  hintText: 'Enter your full name',
                  validationMsg: 'Please enter your full name',
                  isName: true,
                  isEmail: false,
                  isOptional: false,
                  onChange: (str) {},
                  prefixIcon: CupertinoIcons.person,

                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                  ],
                ),
                SizedBox(
                  height: 0.03.sh,
                ),
                SizedBox(
                    width: double.infinity,
                    child: AppElevatedButton(onPressed: _trySubmit,
                      buttonText: 'Update',
                      textColor: AppTheme.whiteColor,
                      buttonColor: AppTheme.primaryColor,)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
