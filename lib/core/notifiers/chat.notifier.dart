import 'dart:convert';
import 'dart:developer';

import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/core/api/api_paths.dart';
import 'package:e_parent_kit/core/api/api_service.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/chat/admin_chat.model.dart';
import 'package:e_parent_kit/core/models/chat/messages.model.dart';
import 'package:e_parent_kit/core/models/chat/user_chats.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatNotifier extends ChangeNotifier {
  AdminChatModel adminChatModel = AdminChatModel();
  UserChatsModel userChatsModel = UserChatsModel();
  AuthData currentlyChattingWith = AuthData();
  AuthData currentUser = AuthData();
  String currentRoomId = '';
  MessagesModel messagesModel = MessagesModel();

  late IO.Socket socket;

  // Socket Connection

  Future<void> initSocketConnection() async {
    socket = IO.io(ApiPaths.socketBaseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    }).connect();

    socket.onConnect((_) {
      log('connected');
      print(socket.id);
    });

    socket.onDisconnect((_) => log('disconnected'));

    listenToEvents();
  }

  void listenToEvents() {
    socket.on("message", (data) {
      Map<dynamic, dynamic> socketData = jsonDecode(data);
      log("Decoded socket data: $socketData");
      if (socketData['room_id'].toString() == currentRoomId) {
        messagesModel.messageData!.messages!.insert(
            0,
            Messages(
                sentBy: AuthData(sId: socketData['sent_by']),
                message: socketData['message'],
                sentAt: DateTime.now().toIso8601String()));
        notifyListeners();
      }
    });

    socket.on("client_connected", (data) {
      print("From client_connected event: $data");
    });

    socket.on("client_disconnected", (data) {
      print("From client_disconnected event: $data");
    });
  }

  Future<AdminChatModel> fetchAdminChats(String userId) async {
    var response = await ApiService.request(
        "${ApiPaths.fetchAdminChats}$userId",
        method: RequestMethod.GET);

    if (response != null && response['success'] == true) {
      adminChatModel = AdminChatModel.fromJson(response);
      notifyListeners();
    }
    return adminChatModel;
  }

  Future<UserChatsModel> fetchUserChats(String userId) async {
    var response = await ApiService.request("${ApiPaths.fetchUserChats}$userId",
        method: RequestMethod.GET);

    if (response != null && response['success'] == true) {
      userChatsModel = UserChatsModel.fromJson(response);
      notifyListeners();
    }
    return userChatsModel;
  }

  Future<void> createChatRoom(
      {required String first_user,
      required String second_user,
      required AuthData chattingWith,
      required BuildContext context}) async {
    String chatRoomId = createChatRoomId(first_user, second_user);
    log("Chat Room: $chatRoomId");

    var data = {
      "first_user": first_user,
      "second_user": second_user,
      "room_id": chatRoomId
    };

    var response = await ApiService.request("${ApiPaths.createChatRoom}",
        method: RequestMethod.POST, data: data);

    if (response != null && response['success'] == true) {
      log("${response['message']}");

      if (response['message'] != 'Room already exists') {
        // The room has been created, reload the list and open the chat room
        navigationController.goBack();
        updateCurrentlyChattingWith(chattingWith,
            context.read<AuthenticationNotifier>().authModel.user!, chatRoomId);
        navigationController.navigateToNamedWithArg(
            RouteGenerator.chatRoomScreen,
            {'roomId': chatRoomId, 'chattingWith': chattingWith});
        fetchUserChats(
            context.read<AuthenticationNotifier>().authModel.user!.sId!);
      } else {
        navigationController.goBack();
        navigationController.navigateToNamedWithArg(
            RouteGenerator.chatRoomScreen,
            {'roomId': chatRoomId, 'chattingWith': chattingWith});
      }
    }
  }

  Future<MessagesModel> fetchAllMessages(String roomId) async {
    messagesModel = MessagesModel();
    var response = await ApiService.request("${ApiPaths.fetchMessages}/$roomId",
        method: RequestMethod.GET);

    if (response != null && response['success'] == true) {
      messagesModel = MessagesModel.fromJson(response);
      messagesModel.messageData?.messages =
          messagesModel.messageData?.messages?.reversed.toList();
      notifyListeners();
    }
    return messagesModel;
  }

  Future<void> sendMessage(
      {required String roomId,
      required String sentBy,
      required String sentTo,
      required String message}) async {
    var data = {
      "room_id": roomId,
      "message": message,
      "sent_by": sentBy,
      "sent_to": sentTo,
      "socket_id" : socket.id
    };

    var response = await ApiService.request("${ApiPaths.sendMessage}",
        method: RequestMethod.POST, data: data);

    // Update last message sent in chat room
    userChatsModel.userChat
        ?.firstWhere((element) => element.roomId == roomId)
        .lastMessage = message;
    userChatsModel.userChat
        ?.firstWhere((element) => element.roomId == roomId)
        .lastMessageSentAt = DateTime.now().toIso8601String();
    notifyListeners();

    log("Message Sent Response: $response");
  }

  String createChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  void updateCurrentlyChattingWith(AuthData chattingWith, AuthData user, String roomId) {
    currentlyChattingWith = chattingWith;
    currentUser = user;
    currentRoomId = roomId;
    notifyListeners();
  }
}
