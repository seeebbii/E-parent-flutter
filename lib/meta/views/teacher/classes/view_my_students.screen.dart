import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_divider.dart';
import 'package:e_parent_kit/components/widgets/app_dob_textfield.dart';
import 'package:e_parent_kit/components/widgets/app_dropdown.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/class/class.model.dart';
import 'package:e_parent_kit/core/models/teacherr/all_teachers.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/chat.notifier.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/notifiers/teacher.notifier.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/create_class.screen.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/manage_class.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ViewMyStudentsScreen extends StatefulWidget {
  const ViewMyStudentsScreen({Key? key}) : super(key: key);

  @override
  State<ViewMyStudentsScreen> createState() => _ViewMyStudentsScreenState();
}

class _ViewMyStudentsScreenState extends State<ViewMyStudentsScreen> {
  @override
  Widget build(BuildContext context) {
    ClassNotifier classNotifier = context.watch<ClassNotifier>();
    return Scaffold(
      appBar: AppAppbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 0.01.sh,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  // columnSpacing: 0.085.sw,
                  columns: [
                    DataColumn(
                        label: Text(
                      'sNo',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Name',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                      label: Text(
                        "Parent's Phone",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Contact",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: classNotifier.selectedClass.studentsEnrolled!
                      .asMap()
                      .entries
                      .map(
                        ((element) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(
                                  "${element.key + 1}",
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                )),
                                DataCell(Text(
                                  "${element.value.fullName}",
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                )),
                                DataCell(InkWell(
                                  onTap: (){
                                    BaseHelper.openDialPad(element.value.parentPhone!);
                                  },
                                    child: Text(
                                  "${element.value.parentPhone}",
                                  style:
                                      Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.blue, decorationStyle: TextDecorationStyle.dashed),
                                ))),
                                DataCell(InkWell(
                                    onTap: () async {
                                      AuthenticationNotifier authNotifier = context.read<AuthenticationNotifier>();
                                      ParentNotifier parentNotifier = context.read<ParentNotifier>();
                                      TeacherNotifier teacherNotifier = context.read<TeacherNotifier>();
                                      EasyLoading.show();

                                      AuthData parentObject = await teacherNotifier.fetchParentObject(element.value.parentPhone!);

                                      await context.read<ChatNotifier>().createChatRoom(
                                          first_user: authNotifier.authModel.user!.sId!,
                                          second_user: parentObject.sId!,
                                          chattingWith: parentObject,
                                          context: context);


                                      EasyLoading.dismiss();
                                    },
                                    child: Text(
                                      "Chat",
                                      style:
                                      Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.blue, decorationStyle: TextDecorationStyle.dashed),
                                    ))),
                              ],
                            )),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
