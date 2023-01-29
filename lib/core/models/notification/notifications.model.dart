import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';

class NotificationsModel {
  int? status;
  bool? success;
  int? count;
  List<Notifications>? notifications;

  NotificationsModel({this.status, this.success, this.count, this.notifications});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    count = json['count'];
    if (json['data'] != null) {
      notifications = <Notifications>[];
      json['data'].forEach((v) {
        notifications!.add(new Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['count'] = this.count;
    if (this.notifications != null) {
      data['data'] = this.notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  String? sId;
  AuthData? sentBy;
  AuthData? sentTo;
  String? title;
  String? description;
  String? notificationType;
  String? sentAt;
  bool? read;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Notifications(
      {this.sId,
        this.sentBy,
        this.sentTo,
        this.title,
        this.description,
        this.notificationType,
        this.sentAt,
        this.read,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Notifications.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sentBy =
    json['sent_by'] != null ? new AuthData.fromJson(json['sent_by']) : null;
    sentTo =
    json['sent_to'] != null ? new AuthData.fromJson(json['sent_to']) : null;
    title = json['title'];
    description = json['description'];
    notificationType = json['notification_type'];
    sentAt = json['sent_at'];
    read = json['read'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.sentBy != null) {
      data['sent_by'] = this.sentBy!.toJson();
    }
    if (this.sentTo != null) {
      data['sent_to'] = this.sentTo!.toJson();
    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['notification_type'] = this.notificationType;
    data['sent_at'] = this.sentAt;
    data['read'] = this.read;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

