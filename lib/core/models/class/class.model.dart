import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';

class ClassModel {
  String? sId;
  int? grade;
  String? section;
  AuthData? classTeacher;
  List<StudentModel>? studentsEnrolled;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ClassModel(
      {this.sId,
        this.grade,
        this.section,
        this.classTeacher,
        this.studentsEnrolled,
        this.createdAt,
        this.updatedAt,
        this.iV});

  ClassModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    grade = json['grade'];
    section = json['section'];
    classTeacher = json['classTeacher'] != null
        ? new AuthData.fromJson(json['classTeacher'])
        : null;
    if (json['studentsEnrolled'] != null) {
      studentsEnrolled = <StudentModel>[];
      json['studentsEnrolled'].forEach((v) {
        studentsEnrolled!.add(StudentModel.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['grade'] = this.grade;
    data['section'] = this.section;
    if (this.classTeacher != null) {
      data['classTeacher'] = this.classTeacher!.toJson();
    }
    if (this.studentsEnrolled != null) {
      data['studentsEnrolled'] =
          this.studentsEnrolled!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
