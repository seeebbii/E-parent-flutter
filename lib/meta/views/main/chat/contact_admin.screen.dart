import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/chat/admin_chat.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/chat.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


class ContactAdminScreen extends StatefulWidget {
  const ContactAdminScreen({Key? key}) : super(key: key);

  @override
  State<ContactAdminScreen> createState() => _ContactAdminScreenState();
}

class _ContactAdminScreenState extends State<ContactAdminScreen> {

  Future<AdminChatModel>? _fetchAdmins;

  @override
  void initState() {
    AuthenticationNotifier authNotifier = context.read<AuthenticationNotifier>();
    _fetchAdmins = context.read<ChatNotifier>().fetchAdminChats(authNotifier.authModel.user!.sId!);
    super.initState();
  }

  void _generateRoom(AuthData admin) async {
    AuthenticationNotifier authNotifier = context.read<AuthenticationNotifier>();
    EasyLoading.show();

    await context.read<ChatNotifier>().createChatRoom(
        first_user: authNotifier.authModel.user!.sId!,
        second_user: admin.sId!,
        chattingWith: admin,
        context: context);


    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    ChatNotifier chatNotifier = context.watch<ChatNotifier>();
    AuthenticationNotifier authNotifier = context.watch<AuthenticationNotifier>();
    return Scaffold(
      appBar: AppAppbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 0.01.sh,
            ),
            Text("Admin Support", style: Theme.of(context).textTheme.displayMedium,),
            SizedBox(
              height: 0.02.sh,
            ),
            FutureBuilder(
                future: _fetchAdmins,
                builder: (BuildContext context,
                    AsyncSnapshot<AdminChatModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(child: AppCircularIndicatorWidget());
                  } else if (snapshot.connectionState == ConnectionState.done && chatNotifier.adminChatModel.admins != null) {
                    if (chatNotifier.adminChatModel.admins!.isEmpty) {
                      return Expanded(
                        child: Center(
                            child: Text(
                              "No admin found",
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: chatNotifier.adminChatModel.admins?.length,
                          itemBuilder: (BuildContext context, int index) {
                            AuthData admin = chatNotifier.adminChatModel.admins![index];
                            if(admin.sId == authNotifier.authModel.user!.sId){
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.005.sh),
                              child: ListTile(
                                onTap: () => _generateRoom(admin),
                                selected: admin.admin!,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                selectedTileColor: AppTheme.primaryColor.withOpacity(0.3),
                                leading: CircleAvatar(
                                  backgroundColor: AppTheme.primaryColor,
                                  radius: 25,
                                  child: Text(
                                    '${admin.fullName?.substring(0, 1).capitalize}',
                                    style: Theme.of(context).textTheme.displaySmall,
                                  ),
                                ),
                                title: Text(
                                  '${admin.fullName}',
                                  style: Theme.of(context).textTheme.displaySmall,
                                ),
                                subtitle: Text(
                                  "${admin.email}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppTheme.unselectedItemColor),
                                ),
                                trailing: Icon(CupertinoIcons.chat_bubble, color: AppTheme.black,),
                              )
                            );
                          },
                        ),
                      );
                    }
                  } else {
                    return Expanded(
                      child: Center(
                          child: Text(
                            "No admin found",
                            style: Theme.of(context).textTheme.bodyLarge,
                          )),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
