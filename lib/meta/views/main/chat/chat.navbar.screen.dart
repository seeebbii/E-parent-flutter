import 'package:e_parent_kit/app/constants/assets.constant.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/chat/user_chats.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/chat.notifier.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/utils/time_ago.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChatNavbarScreen extends StatefulWidget {
  const ChatNavbarScreen({Key? key}) : super(key: key);

  @override
  State<ChatNavbarScreen> createState() => _ChatNavbarScreenState();
}

class _ChatNavbarScreenState extends State<ChatNavbarScreen> {
  Future<UserChatsModel>? _fetchUserChats;

  @override
  void initState() {
    AuthenticationNotifier authNotifier =
        context.read<AuthenticationNotifier>();
    _fetchUserChats = context
        .read<ChatNotifier>()
        .fetchUserChats(authNotifier.authModel.user!.sId!);
    context.read<ChatNotifier>().initSocketConnection();
    super.initState();
  }

  Future<void> _onRefresh() async {
    AuthenticationNotifier authNotifier =
        context.read<AuthenticationNotifier>();
    await context
        .read<ChatNotifier>()
        .fetchUserChats(authNotifier.authModel.user!.sId!);
  }

  void _openChatRoom(String roomId, AuthData chattingWith) {
    context.read<ChatNotifier>().updateCurrentlyChattingWith(
        chattingWith, context.read<AuthenticationNotifier>().authModel.user!, roomId);
    navigationController.navigateToNamedWithArg(RouteGenerator.chatRoomScreen,
        {'roomId': roomId, 'chattingWith': chattingWith});
  }

  @override
  Widget build(BuildContext context) {
    ChatNotifier chatNotifier = context.watch<ChatNotifier>();
    AuthenticationNotifier authNotifier =
        context.watch<AuthenticationNotifier>();
    return Scaffold(
      backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 0.01.sh,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chats",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Row(
                  children: [
                    Text("Online: ", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.subtitleLightGreyColor),),
                    const SizedBox(width: 5,),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: chatNotifier.socket.connected ? AppTheme.green : AppTheme.red
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 0.02.sh,
            ),
            FutureBuilder(
                future: _fetchUserChats,
                builder: (BuildContext context,
                    AsyncSnapshot<UserChatsModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(child: AppCircularIndicatorWidget());
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      chatNotifier.userChatsModel.userChat != null) {
                    if (chatNotifier.userChatsModel.userChat!.isEmpty) {
                      return Expanded(
                        child: Center(
                            child: Text(
                          "No chats found",
                          style: Theme.of(context).textTheme.bodyLarge,
                        )),
                      );
                    } else {
                      return Expanded(
                        flex: 1,
                        child: RefreshIndicator(
                          color: AppTheme.primaryColor,
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount:
                                chatNotifier.userChatsModel.userChat?.length,
                            itemBuilder: (BuildContext context, int index) {
                              // Check what user is current user chatting with
                              UserChat currentChat =
                                  chatNotifier.userChatsModel.userChat![index];
                              AuthData chatWith = chatNotifier.userChatsModel
                                          .userChat![index].firstUser!.sId! !=
                                      authNotifier.authModel.user!.sId!
                                  ? chatNotifier.userChatsModel.userChat![index]
                                      .firstUser!
                                  : chatNotifier.userChatsModel.userChat![index]
                                      .secondUser!;
                              return Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 0.005.sh),
                                  child: ListTile(
                                    tileColor: AppTheme.whiteColor,
                                    onTap: () => _openChatRoom(
                                        currentChat.roomId!, chatWith),
                                    selected: chatWith.admin!,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    selectedTileColor:
                                        AppTheme.primaryColor.withOpacity(0.3),
                                    leading: CircleAvatar(
                                      backgroundColor: chatWith.admin!
                                          ? AppTheme.whiteColor
                                          : AppTheme.primaryColor,
                                      radius: 25,
                                      child: Text(
                                        '${chatWith.fullName?.substring(0, 1).capitalize}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                    ),
                                    title: Text(
                                      '${chatWith.fullName}',
                                      style:
                                          Theme.of(context).textTheme.displaySmall,
                                    ),
                                    subtitle: Text(
                                      currentChat.lastMessage == ""
                                          ? "No last message"
                                          : "${currentChat.lastMessage}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color:
                                                  AppTheme.unselectedItemColor,
                                              overflow: TextOverflow.ellipsis),
                                    ),
                                    trailing: Text(
                                      getTimeAgo(DateTime.parse(
                                          "${currentChat.lastMessageSentAt}")),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: AppTheme.black,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      );
                    }
                  } else {
                    return Expanded(
                      child: Center(
                          child: Text(
                        "No chats found",
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
