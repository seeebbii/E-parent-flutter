import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/authentication/teacher_data.model.dart';

class AllTeachersModel {
  int? status;
  bool? success;
  List<TeachersDataList>? teachers;

  AllTeachersModel({this.status, this.success, this.teachers});

  AllTeachersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      teachers = <TeachersDataList>[];
      json['data'].forEach((v) {
        teachers!.add(new TeachersDataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.teachers != null) {
      data['data'] = this.teachers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeachersDataList {
  AuthData? user;
  TeacherData? teacherData;

  TeachersDataList({this.user, this.teacherData});

  TeachersDataList.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new AuthData.fromJson(json['user']) : null;
    teacherData = json['teacherData'] != null
        ? new TeacherData.fromJson(json['teacherData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.teacherData != null) {
      data['teacherData'] = this.teacherData!.toJson();
    }
    return data;
  }
}