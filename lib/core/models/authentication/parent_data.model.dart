import 'package:e_parent_kit/core/models/student/student.model.dart';

class ParentData {
  String? sId;
  String? roleId;
  List<StudentModel>? students;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ParentData(
      {this.sId,
        this.roleId,
        this.students,
        this.createdAt,
        this.updatedAt,
        this.iV});

  ParentData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    roleId = json['role_id'];
    if (json['students'] != null) {
      students = <StudentModel>[];
      json['students'].forEach((v) {
        students!.add(StudentModel.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['role_id'] = this.roleId;
    if (this.students != null) {
      data['students'] = this.students!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}