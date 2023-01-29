import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';

class AdminChatModel {
  int? status;
  bool? success;
  List<AuthData>? admins;

  AdminChatModel({this.status, this.success, this.admins});

  AdminChatModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      admins = <AuthData>[];
      json['data'].forEach((v) {
        admins!.add(AuthData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.admins != null) {
      data['data'] = this.admins!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
