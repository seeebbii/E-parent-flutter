import 'class.model.dart';

class AllClassesModel {
  int? status;
  bool? success;
  List<ClassModel>? data;

  AllClassesModel({this.status, this.success, this.data});

  AllClassesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      data = <ClassModel>[];
      json['data'].forEach((v) {
        data!.add(new ClassModel.fromJson(v));
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