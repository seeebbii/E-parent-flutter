import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/build_list_item_widget.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/create_class.screen.dart';
import 'package:e_parent_kit/meta/views/admin/modules/classes/options/manage_class.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class ClassesModuleScreen extends StatefulWidget {
  const ClassesModuleScreen({Key? key}) : super(key: key);

  @override
  State<ClassesModuleScreen> createState() => _ClassesModuleScreenState();
}

class _ClassesModuleScreenState extends State<ClassesModuleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 0.01.sh,
              ),
              Text(
                "Classes Module",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              BuildListItemWidget(
                onTap: () {
                  Get.to(() => CreateClassScreen());
                },
                text: 'Create Class',
              ),
              BuildListItemWidget(
                onTap: () {
                  Get.to(() => ManageClassScreen());
                },
                text: 'Manage Classes',
              ),
              // BuildListItemWidget(
              //   onTap: () {
              //     Get.to(() => ManageEnrollmentScreen());
              //   },
              //   text: 'Manage Enrollment',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

