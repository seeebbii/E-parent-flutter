import 'package:e_parent_kit/core/models/student/student.model.dart';

class EnrollmentModel {
  int? status;
  bool? success;
  List<StudentModel>? students;

  EnrollmentModel({this.status, this.success, this.students});

  EnrollmentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      students = <StudentModel>[];
      json['data'].forEach((v) {
        students!.add(new StudentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.students != null) {
      data['data'] = this.students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
