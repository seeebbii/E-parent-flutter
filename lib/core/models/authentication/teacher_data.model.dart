import 'package:e_parent_kit/core/models/course/course.model.dart';

class TeacherData {
  String? sId;
  String? roleId;
  List<CourseModel>? courseTeaches;
  String? createdAt;
  String? updatedAt;
  int? iV;

  TeacherData(
      {this.sId,
        this.roleId,
        this.courseTeaches,
        this.createdAt,
        this.updatedAt,
        this.iV});

  TeacherData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    roleId = json['role_id'];
    if (json['course_teaches'] != null) {
      courseTeaches = <CourseModel>[];
      json['course_teaches'].forEach((v) {
        courseTeaches!.add(CourseModel.fromJson(v));
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
    if (this.courseTeaches != null) {
      data['course_teaches'] = this.courseTeaches!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}