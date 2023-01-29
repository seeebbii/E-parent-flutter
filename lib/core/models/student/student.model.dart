import 'package:e_parent_kit/core/models/class/class.model.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';

class StudentModel {
  ClassModel? classModel;
  String? sId;
  String? fullName;
  String? dob;
  int? age;
  String? parentPhone;
  List<CourseModel>? coursesEnrolled;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? selected;

  StudentModel(
      {this.sId,
        this.classModel,
        this.fullName,
        this.dob,
        this.age,
        this.parentPhone,
        this.coursesEnrolled,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.selected = true});

  StudentModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['full_name'];
    dob = json['dob'];
    age = json['age'];
    parentPhone = json['parent_phone'];
    // classModel = json['class_id'];
    if(json['class_id'] != null){
      classModel = ClassModel.fromJson(json['class_id']);
    }
    if (json['courses_enrolled'] != null) {
      coursesEnrolled = <CourseModel>[];
      json['courses_enrolled'].forEach((v) {
        coursesEnrolled!.add(CourseModel.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    selected = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  {};
    data['_id'] = this.sId;
    data['full_name'] = this.fullName;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['parent_phone'] = this.parentPhone;
    data['class_id'] = this.classModel?.toJson();
    if (this.coursesEnrolled != null) {
      data['courses_enrolled'] =
          this.coursesEnrolled!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}