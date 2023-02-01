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
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
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

class UploadAttendanceScreen extends StatefulWidget {
  const UploadAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<UploadAttendanceScreen> createState() => _UploadAttendanceScreenState();
}

class _UploadAttendanceScreenState extends State<UploadAttendanceScreen> {

  @override
  void initState() {

    Future.delayed(
        const Duration(
          milliseconds: 500,
        ), () {
      context.read<ClassNotifier>().setStudentAttendanceStatus(context);
    });
    super.initState();
  }

  void _trySubmit() async {

    if(context.read<AuthenticationScreenVM>().dobController.text.trim().isEmpty){
      return BaseHelper.showSnackBar("Please select attendance date");
    }

    EasyLoading.show();

    await context.read<ClassNotifier>().uploadClassAttendance(context);

    EasyLoading.dismiss();
  }

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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text("P", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.green),),
                    Text(" : Present", style: Theme.of(context).textTheme.displaySmall,),
                  ],
                ),
                Row(
                  children: [
                    Text("A", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.red),),
                    Text(" : Absent", style: Theme.of(context).textTheme.displaySmall,),
                  ],
                ),
                Row(
                  children: [
                    Text("L", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.blue),),
                    Text(" : Leave", style: Theme.of(context).textTheme.displaySmall,),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 0.02.sh,
          ),
          AppDivider(thickness: 3, ),
          SizedBox(
            height: 0.02.sh,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
            child: Row(
              children: [
                Text('Select attendance date', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(width: 0.02.sw,),
                Expanded(child: AppDobTextField(text: "Current Date", attendance: true,)),
              ],
            ),
          ),
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
                    DataColumn(label: Text('sNo', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text('Name', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),)),
                    DataColumn(label:Text('Status', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),),),
                  ],
                  rows: classNotifier.selectedClass.studentsEnrolled!.asMap()
                      .entries
                      .map(
                    ((element) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text("${element.key + 1}", style: Theme.of(context).textTheme.displaySmall,)),
                        DataCell(Text("${element.value.fullName}", style: Theme.of(context).textTheme.displaySmall,)),
                        DataCell(
                          SizedBox(
                            height: 0.1.sh,
                            width: 0.2.sw,
                            child: AppDropdown(
                              controller: element.value.statusTextEditingController,
                              myKey: element.value.studentAttendanceStatusKey,
                              contentList: classNotifier.statusList,
                              hintText: 'customer_type_tr',
                              itemBuilder: (ctx, item, isSelected) {
                                return ListTile(
                                    selected: isSelected,
                                    title: Text(item, style: Theme.of(context).textTheme.displaySmall,),
                                    onTap: () {
                                      setState(() {
                                        element.value.studentAttendanceStatusKey.currentState?.popupValidate([item]);
                                        element.value.statusTextEditingController.text = item;
                                      });
                                    });
                              },
                            ),
                          ),
                        ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(CupertinoIcons.check_mark, color: AppTheme.black,),
          onPressed: _trySubmit,
          label: Text(
            "Upload",
            style: Theme.of(context).textTheme.bodyLarge,
          )),
    );
  }
}
