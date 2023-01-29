import 'package:e_parent_kit/core/models/student/student.model.dart';

class SelectStudentsModel {
  int? status;
  bool? success;
  List<StudentModel>? data;

  SelectStudentsModel({this.status, this.success, this.data});

  SelectStudentsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      data = <StudentModel>[];
      json['data'].forEach((v) {
        data!.add( StudentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  {};
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}