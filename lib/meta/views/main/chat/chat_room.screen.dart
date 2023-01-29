import 'package:e_parent_kit/components/widgets/app_appbar.dart';
import 'package:e_parent_kit/components/widgets/app_circular_indicator_widget.dart';
import 'package:e_parent_kit/components/widgets/app_simple_text_field.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/chat/messages.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/notifiers/chat.notifier.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'widget/chat_bubble.widget.dart';

class ChatRoomScreen extends StatefulWidget {
  final AuthData chattingWith;
  final String roomId;

  const ChatRoomScreen(
      {Key? key, required this.chattingWith, required this.roomId})
      : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  Future<MessagesModel>? _fetchRoomMessages;

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    _fetchRoomMessages =
        context.read<ChatNotifier>().fetchAllMessages(widget.roomId);
    super.initState();
  }

  void _trySubmit() async {
    if (messageController.text.trim().isEmpty) {
      BaseHelper.showSnackBar("Cannot send empty message");
      return;
    }
    AuthenticationNotifier authNotifier =
        context.read<AuthenticationNotifier>();
    context.read<ChatNotifier>().sendMessage(
        roomId: widget.roomId,
        sentBy: authNotifier.authModel.user!.sId!,
        sentTo: widget.chattingWith.sId!,
        message: messageController.text.trim());
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ChatNotifier chatNotifier = context.watch<ChatNotifier>();
    return Scaffold(
      appBar: AppAppbar(
        bgColor: AppTheme.primaryColor.withOpacity(0.24),
        toolbarHeight: 60,
        isTitleText: false,
        titleWidget: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              radius: 20,
              child: Text(
                '${widget.chattingWith.fullName?.substring(0, 1).capitalize}',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            SizedBox(
              width: 0.03.sw,
            ),
            Text(
              '${widget.chattingWith.fullName}',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: _fetchRoomMessages,
                builder: (BuildContext context,
                    AsyncSnapshot<MessagesModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return AppCircularIndicatorWidget();
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      chatNotifier.messagesModel.messageData?.messages !=
                          null) {
                    if (chatNotifier
                        .messagesModel.messageData!.messages!.isEmpty) {
                      return Center(
                          child: Text(
                        "Send a message to start a conversation",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ));
                    } else {
                      return ListView.builder(
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: chatNotifier
                            .messagesModel.messageData?.messages?.length,
                        itemBuilder: (BuildContext context, int index) {
                          Messages message = chatNotifier
                              .messagesModel.messageData!.messages![index];
                          return ChatBubbleWidget(
                            message: message,
                          );
                        },
                      );
                    }
                  } else {
                    return Center(
                        child: Text(
                      "Send a message to start a conversation",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ));
                  }
                }),
          ),
          Container(
            height: 80,
            child: Row(
              children: [
                SizedBox(
                  width: 0.02.sw,
                ),
                Expanded(
                  child: AppSimpleTextField(
                    controller: messageController,
                    keyboard: TextInputType.multiline,
                    hintText: 'Enter your message',
                    validationMsg: 'Cannot be empty',
                    isPass: false,
                    isOptional: true,
                    onChange: (str) {},
                    prefixIcon: CupertinoIcons.app_badge,
                  ),
                ),
                SizedBox(
                  width: 0.02.sw,
                ),
                SizedBox(
                    height: 50,
                    child: FittedBox(
                        child: FloatingActionButton(
                            child: Icon(
                              CupertinoIcons.paperplane,
                              size: 28,
                            ),
                            onPressed: _trySubmit))),
                SizedBox(
                  width: 0.02.sw,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
