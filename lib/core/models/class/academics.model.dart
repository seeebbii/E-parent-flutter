import '../authentication/auth_data.model.dart';

class AcademicsModel {
  int? status;
  bool? success;
  List<Record>? data;

  AcademicsModel({this.status, this.success, this.data});

  AcademicsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      data = <Record>[];
      json['data'].forEach((v) {
        data!.add(new Record.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Record {
  String? sId;
  String? studentId;
  String? courseId;
  String? classId;
  AuthData? teacherId;
  String? type;
  String? title;
  int? totalMarks;
  int? obtainedMarks;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Record(
      {this.sId,
        this.studentId,
        this.courseId,
        this.classId,
        this.teacherId,
        this.type,
        this.title,
        this.totalMarks,
        this.obtainedMarks,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Record.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    studentId = json['student_id'];
    courseId = json['course_id'];
    classId = json['class_id'];
    teacherId = json['teacher_id'] != null ? new AuthData.fromJson(json['teacher_id']) : null;
    type = json['type'];
    title = json['title'];
    totalMarks = json['total_marks'];
    obtainedMarks = json['obtained_marks'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['student_id'] = this.studentId;
    data['course_id'] = this.courseId;
    data['class_id'] = this.classId;
    data['teacher_id'] = this.teacherId?.toJson();
    data['type'] = this.type;
    data['title'] = this.title;
    data['total_marks'] = this.totalMarks;
    data['obtained_marks'] = this.obtainedMarks;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
