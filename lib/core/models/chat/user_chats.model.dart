import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';

class UserChatsModel {
  int? status;
  bool? success;
  List<UserChat>? userChat;

  UserChatsModel({this.status, this.success, this.userChat});

  UserChatsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      userChat = <UserChat>[];
      json['data'].forEach((v) {
        userChat!.add(new UserChat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.userChat != null) {
      data['data'] = this.userChat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserChat {
  String? sId;
  AuthData? firstUser;
  AuthData? secondUser;
  String? roomId;
  String? lastMessage;
  String? lastMessageSentAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UserChat(
      {this.sId,
        this.firstUser,
        this.secondUser,
        this.roomId,
        this.lastMessage,
        this.lastMessageSentAt,
        this.createdAt,
        this.updatedAt,
        this.iV});

  UserChat.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstUser = json['first_user'] != null
        ? new AuthData.fromJson(json['first_user'])
        : null;
    secondUser = json['second_user'] != null
        ? new AuthData.fromJson(json['second_user'])
        : null;
    roomId = json['room_id'];
    lastMessage = json['last_message'];
    lastMessageSentAt = json['last_message_sent_at'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.firstUser != null) {
      data['first_user'] = this.firstUser!.toJson();
    }
    if (this.secondUser != null) {
      data['second_user'] = this.secondUser!.toJson();
    }
    data['room_id'] = this.roomId;
    data['last_message'] = this.lastMessage;
    data['last_message_sent_at'] = this.lastMessageSentAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

