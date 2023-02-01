class StudentsAttendanceModel {
  int? status;
  bool? success;
  List<Attendance>? data;

  StudentsAttendanceModel({this.status, this.success, this.data = const []});

  StudentsAttendanceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    if (json['data'] != null) {
      data = <Attendance>[];
      json['data'].forEach((v) {
        data!.add(new Attendance.fromJson(v));
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

class Attendance {
  String? sId;
  String? attendanceDate;
  String? classId;
  String? studentId;
  int? iV;
  String? attendanceStatus;
  String? createdAt;
  String? updatedAt;

  Attendance(
      {this.sId,
        this.attendanceDate,
        this.classId,
        this.studentId,
        this.iV,
        this.attendanceStatus,
        this.createdAt,
        this.updatedAt});

  Attendance.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    attendanceDate = json['attendance_date'];
    classId = json['class_id'];
    studentId = json['student_id'];
    iV = json['__v'];
    attendanceStatus = json['attendance_status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['attendance_date'] = this.attendanceDate;
    data['class_id'] = this.classId;
    data['student_id'] = this.studentId;
    data['__v'] = this.iV;
    data['attendance_status'] = this.attendanceStatus;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
