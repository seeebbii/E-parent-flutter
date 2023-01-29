import 'package:e_parent_kit/core/models/authentication/parent_data.model.dart';
import 'package:e_parent_kit/core/models/authentication/teacher_data.model.dart';

import 'auth_data.model.dart';

class AuthenticationModel {
  int? status;
  bool? success;
  String? message;
  String? token;
  ParentData? parentData;
  TeacherData? teacherData;
  AuthData? user;

  AuthenticationModel(
      {this.status,
        this.success,
        this.message,
        this.token,
        this.parentData,
        this.teacherData,
        this.user});

  AuthenticationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    token = json['token'];
    parentData = json['parentData'] != null
        ? new ParentData.fromJson(json['parentData'])
        : null;
    teacherData = json['teacherData'] != null
        ? new TeacherData.fromJson(json['teacherData'])
        : null;
    user = json['user'] != null ? new AuthData.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    data['token'] = this.token;
    if (this.parentData != null) {
      data['parentData'] = this.parentData!.toJson();
    }
    if (this.teacherData != null) {
      data['teacherData'] = this.teacherData!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}




