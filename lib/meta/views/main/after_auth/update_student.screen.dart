import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/core/models/student/select_student.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class UpdateStudentsScreen extends StatefulWidget {
  const UpdateStudentsScreen({Key? key}) : super(key: key);

  @override
  State<UpdateStudentsScreen> createState() => _UpdateStudentsScreenState();
}

class _UpdateStudentsScreenState extends State<UpdateStudentsScreen> {

  Future<SelectStudentsModel>? _fetchStudents;

  @override
  void initState() {
    AuthenticationNotifier authNotifier =
    context.read<AuthenticationNotifier>();
    _fetchStudents = context.read<ParentNotifier>().fetchStudentsFromNumber(authNotifier.authModel.user?.completePhone ?? "");
    super.initState();
  }


  void _trySubmit() async {
    ParentNotifier parentNotifier = Provider.of<ParentNotifier>(context, listen: false);
    AuthenticationNotifier authNotifier = Provider.of<AuthenticationNotifier>(context, listen: false);
    List<String> studentIds = parentNotifier.getAllSelectedStudents.map((e) => e.sId!).toList();

    // Call Add students query
    EasyLoading.show();

    await parentNotifier.addStudents(context, parentId: authNotifier.authModel.parentData!.sId!, studentIds: studentIds);
    navigationController.getOffAll(RouteGenerator.rootScreen);

    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    ParentNotifier parentNotifier = context.watch<ParentNotifier>();
    AuthenticationNotifier authNotifier =
    context.watch<AuthenticationNotifier>();
    return Scaffold(
      appBar: AppAppbar(
        leading: true,
        actions: [
          IconButton(
            splashRadius: 20,
            tooltip: "Reload",
            onPressed: () {
              setState(() {
                _fetchStudents = context
                    .read<ParentNotifier>()
                    .fetchStudentsFromNumber(
                    authNotifier.authModel.user?.completePhone ?? "");
              });
            },
            icon: const Icon(CupertinoIcons.arrow_clockwise),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select your children",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(
              height: 0.01.sh,
            ),
            Text(
              "Students against your registered phone number will be displayed here",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 3,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                    'In case your children are not in the list, kindly contact admin ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppTheme.unselectedItemColor),
                  ),
                  TextSpan(
                    text: "haseebzafar.dev@gmail.com",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.blue,
                        fontWeight: FontWeight.bold,
                        decorationStyle: TextDecorationStyle.dashed),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        BaseHelper.launchUrl(
                            'mailto:haseebzafar.dev@gmail.com');
                      },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0.01.sh,
            ),
            FutureBuilder(
                future: _fetchStudents,
                builder: (BuildContext context,
                    AsyncSnapshot<SelectStudentsModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(child: AppCircularIndicatorWidget());
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      parentNotifier.myStudents.data != null) {
                    if (parentNotifier.myStudents.data!.isEmpty) {
                      return Expanded(
                        child: Center(
                            child: Text(
                              "No students have been added yet",
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: parentNotifier.myStudents.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            StudentModel student =
                            parentNotifier.myStudents.data![index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.005.sh),
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                selectedTileColor:
                                AppTheme.primaryColor.withOpacity(0.3),
                                selected: student.selected!,
                                title: Text(
                                  '${parentNotifier.myStudents.data?[index].fullName}',
                                  style: Theme.of(context).textTheme.displaySmall,
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: AppTheme.primaryColor,
                                value: student.selected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    student.selected = !student.selected!;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }
                  } else {
                    return Expanded(
                      child: Center(
                          child: Text(
                            "No students have been added yet",
                            style: Theme.of(context).textTheme.bodyLarge,
                          )),
                    );
                  }
                })
          ],
        ),
      ),
      floatingActionButton:  AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: parentNotifier.checkStudentsSelections ? FloatingActionButton.extended(
            icon: const Icon(CupertinoIcons.check_mark, color: AppTheme.black,),
            onPressed: _trySubmit,
            label: Text(
              "Select",
              style: Theme.of(context).textTheme.bodyLarge,
            )) : const SizedBox.shrink(),
      ),
    );
  }
}
