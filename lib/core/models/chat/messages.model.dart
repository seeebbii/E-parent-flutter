import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';

class MessagesModel {
  int? status;
  bool? success;
  MessageData? messageData;

  MessagesModel({this.status, this.success, this.messageData});

  MessagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    messageData = json['data'] != null ? new MessageData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.messageData != null) {
      data['data'] = this.messageData!.toJson();
    }
    return data;
  }
}

class MessageData {
  String? sId;
  String? roomId;
  List<Messages>? messages;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MessageData(
      {this.sId,
        this.roomId,
        this.messages,
        this.createdAt,
        this.updatedAt,
        this.iV});

  MessageData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    roomId = json['room_id'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['room_id'] = this.roomId;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Messages {
  AuthData? sentBy;
  String? message;
  String? sentAt;
  String? sId;

  Messages({this.sentBy, this.message, this.sentAt, this.sId});

  Messages.fromJson(Map<String, dynamic> json) {
    sentBy =
    json['sent_by'] != null ? new AuthData.fromJson(json['sent_by']) : null;
    message = json['message'];
    sentAt = json['sent_at'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sentBy != null) {
      data['sent_by'] = this.sentBy!.toJson();
    }
    data['message'] = this.message;
    data['sent_at'] = this.sentAt;
    data['_id'] = this.sId;
    return data;
  }
}

