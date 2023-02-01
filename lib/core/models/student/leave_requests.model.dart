import 'dart:ffi';

import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';

class LeaveRequestsModel {
  int? status;
  bool? success;
  List<Requests>? request;

  LeaveRequestsModel({this.status, this.success, this.request});

  LeaveRequestsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      request = <Requests>[];
      json['data'].forEach((v) {
        request!.add(new Requests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.request != null) {
      data['data'] = this.request!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Requests {
  String? sId;
  String? classId;
  StudentModel? studentId;
  AuthData? parentId;
  String? teacherId;
  String? dateForLeave;
  String? reasonForLeave;
  bool? leaveStatus;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Requests(
      {this.sId,
        this.classId,
        this.studentId,
        this.parentId,
        this.teacherId,
        this.dateForLeave,
        this.reasonForLeave,
        this.leaveStatus,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Requests.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    classId = json['class_id'];
    studentId = json['student_id'] != null
        ? new StudentModel.fromJson(json['student_id'])
        : null;
    parentId = json['parent_id'] != null
        ? new AuthData.fromJson(json['parent_id'])
        : null;
    teacherId = json['teacher_id'];
    dateForLeave = json['date_for_leave'];
    reasonForLeave = json['reason_for_leave'];
    leaveStatus = json['leave_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['class_id'] = this.classId;
    if (this.studentId != null) {
      data['student_id'] = this.studentId!.toJson();
    }
    if (this.parentId != null) {
      data['parent_id'] = this.parentId!.toJson();
    }
    data['teacher_id'] = this.teacherId;
    data['date_for_leave'] = this.dateForLeave;
    data['reason_for_leave'] = this.reasonForLeave;
    data['leave_status'] = this.leaveStatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
