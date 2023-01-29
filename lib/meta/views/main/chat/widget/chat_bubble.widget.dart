import 'package:e_parent_kit/core/models/chat/messages.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/meta/utils/app_theme.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatBubbleWidget extends StatefulWidget {
  final Messages message;

  const ChatBubbleWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends State<ChatBubbleWidget> {
  // Future? loadThumbnail;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationNotifier authenticationNotifier =
        context.watch<AuthenticationNotifier>();
    if (widget.message.sentBy!.sId ==
        authenticationNotifier.authModel.user!.sId) {
      return Padding(
        padding: EdgeInsets.only(right: 0.03.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget.message.message != '' && widget.message.message != null
                    ? Text(
                        BaseHelper.formatTime(
                            DateTime.parse(widget.message.sentAt.toString())),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.unselectedItemColor, fontSize: 9),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  width: 3,
                ),
                widget.message.message != '' && widget.message.message != null
                    ? Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.60,
                        ),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.unselectedItemColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Text(
                          "${widget.message.message}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppTheme.whiteColor),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: 0.03.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget.message.message != '' && widget.message.message != null
                    ? Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.55,
                        ),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.9),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(18),
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Text(
                          "${widget.message.message}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      )
                    : const SizedBox.shrink(),
                widget.message.message != '' && widget.message.message != null
                    ? Text(
                        BaseHelper.formatTime(
                            DateTime.parse(widget.message.sentAt.toString())),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.unselectedItemColor, fontSize: 9),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  width: 3,
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
