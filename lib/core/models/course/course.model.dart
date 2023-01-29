class CourseModel {
  String? sId;
  String? courseName;
  String? courseCode;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? selected;

  CourseModel(
      {this.sId,
        this.courseName,
        this.courseCode,
        this.createdAt,
        this.updatedAt,
        this.iV, this.selected = false});

  CourseModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courseName = json['course_name'];
    courseCode = json['course_code'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    selected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['course_name'] = this.courseName;
    data['course_code'] = this.courseCode;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}