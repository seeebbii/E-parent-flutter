import 'course.model.dart';

class SelectCoursesModel {
  int? status;
  bool? success;
  List<CourseModel>? data;

  SelectCoursesModel({this.status, this.success, this.data});

  SelectCoursesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      data = <CourseModel>[];
      json['data'].forEach((v) {
        data!.add(new CourseModel.fromJson(v));
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
