enum Role{
  Parent,
  Teacher,
  TeacherAdmin
}

class AuthData {
  String? sId;
  bool? admin;
  int? role;
  String? fullName;
  String? email;
  String? password;
  String? countryCode;
  String? phone;
  bool? verified;
  DateTime? verifiedAt;
  String? fcmToken;
  String? completePhone;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Role? authRole;

  AuthData(
      {this.sId,
        this.admin,
        this.role,
        this.fullName,
        this.email,
        this.password,
        this.countryCode,
        this.phone,
        this.verified,
        this.verifiedAt,
        this.fcmToken,
        this.completePhone,
        this.createdAt,
        this.updatedAt,
        this.authRole,
        this.iV});

  AuthData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    admin = json['admin'];
    role = json['role'];
    authRole = role == 1 ? admin == true ? Role.TeacherAdmin : Role.Teacher : Role.Parent;
    fullName = json['full_name'];
    email = json['email'];
    password = json['password'];
    countryCode = json['country_code'];
    phone = json['phone'];
    verified = json['verified'];
    verifiedAt = json['verified_at'] != null ? DateTime.parse(json['verified_at']) : null;
    fcmToken = json['fcm_token'];
    completePhone = json['complete_phone'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['admin'] = this.admin;
    data['role'] = this.role;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['verified'] = this.verified;
    data['verified_at'] = this.verifiedAt;
    data['fcm_token'] = this.fcmToken;
    data['complete_phone'] = this.completePhone;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['authRole'] = this.authRole;
    return data;
  }
}