import 'package:e_parent_kit/core/models/class/class.model.dart';

class TeacherClassDiary {
  int? status;
  bool? success;
  List<Diary>? diary;

  TeacherClassDiary({this.status, this.success, this.diary});

  TeacherClassDiary.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      diary = <Diary>[];
      json['data'].forEach((v) {
        diary!.add(new Diary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.diary != null) {
      data['data'] = this.diary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Diary {
  String? sId;
  ClassModel? classId;
  String? diary;
  String? currentDate;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Diary(
      {this.sId,
        this.classId,
        this.diary,
        this.currentDate,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Diary.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    classId = json['class_id'] != null
        ? new ClassModel.fromJson(json['class_id'])
        : null;
    diary = json['diary'];
    currentDate = json['current_date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.classId != null) {
      data['class_id'] = this.classId!.toJson();
    }
    data['diary'] = this.diary;
    data['current_date'] = this.currentDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

