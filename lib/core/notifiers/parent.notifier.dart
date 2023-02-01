import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/core/api/api_paths.dart';
import 'package:e_parent_kit/core/api/api_service.dart';
import 'package:e_parent_kit/core/models/attendance/students_attendance.model.dart';
import 'package:e_parent_kit/core/models/authentication/authentication.model.dart';
import 'package:e_parent_kit/core/models/student/leave_requests.model.dart';
import 'package:e_parent_kit/core/models/student/select_student.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/utils/hive_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'class.notifier.dart';

class ParentNotifier extends ChangeNotifier {
  // Data Variables
  SelectStudentsModel myStudents = SelectStudentsModel();
  StudentModel? selectedStudentProfile = StudentModel();
  LeaveRequestsModel leaveRequestsModel = LeaveRequestsModel();
  StudentsAttendanceModel studentsAttendanceModel = StudentsAttendanceModel();

  bool get checkStudentsSelections =>
      myStudents.data == null || myStudents.data!.isEmpty
          ? false
          : myStudents.data!
              .where(
                (element) => element.selected == true,
              )
              .isNotEmpty;

  List<StudentModel> get getAllSelectedStudents => myStudents.data!
      .where(
        (element) => element.selected == true,
      )
      .toList();

  void setStudentProfile(BuildContext context, {StudentModel? student}) async {
    if (student == null) {
      selectedStudentProfile = context
          .read<AuthenticationNotifier>()
          .authModel
          .parentData
          ?.students
          ?.first;
      await context.read<ClassNotifier>().fetchClassDiary(context);
    } else {
      selectedStudentProfile = student;
      await context.read<ClassNotifier>().fetchClassDiary(context);
      notifyListeners();
    }
  }

  Future<SelectStudentsModel> fetchStudentsFromNumber(
      String completePhoneNumber) async {
    var response = await ApiService.request(
        "${ApiPaths.fetchStudents}$completePhoneNumber",
        method: RequestMethod.GET);
    if (response != null) {
      log("$response");
      myStudents = SelectStudentsModel.fromJson(response);
      selectedStudentProfile = myStudents.data?[0];
      notifyListeners();
    }
    return myStudents;
  }

  Future<void> addStudents(BuildContext context,
      {required String parentId, required List<String> studentIds}) async {
    var data = {"parent_id": parentId, "students": studentIds};

    var response = await ApiService.request("${ApiPaths.addStudents}",
        method: RequestMethod.POST, data: data);

    if (response != null) {
      if (response['success'] == true) {
        await context.read<AuthenticationNotifier>().fetchProfile();

        BaseHelper.showSnackBar('${response['message']}');
      } else {
        BaseHelper.showSnackBar('${response['message']}');
      }
    }
  }

  Future<void> requestLeave({
    required String parentId,
    required String teacherId,
    required String studentId,
    required String classId,
    required String reason,
    required BuildContext context,
  }) async {
    var data = {
    "parent_id": parentId,
    'teacher_id': teacherId,
    'student_id': studentId,
    'class_id': classId,
    'reason_for_leave': reason,
    'date_for_leave': context.read<AuthenticationScreenVM>().dobController.text.trim(),
    };

    var response = await ApiService.request("${ApiPaths.requestLeaveFromParent}", method: RequestMethod.POST, data: data);

    if(response != null) {
      if(response['success'] == true){
        navigationController.goBack();
        BaseHelper.showSnackBar(response['message']);
      }else{
        BaseHelper.showSnackBar(response['message']);
      }
    }
  }

  Future<LeaveRequestsModel> myPreviousRequests(BuildContext context) async {
    var data = {
      "student_id": selectedStudentProfile!.sId,
      "parent_id": context.read<AuthenticationNotifier>().authModel.user!.sId,
    };

    var response = await ApiService.request("${ApiPaths.viewParentLeaveRequests}", method: RequestMethod.POST, data: data);
    if(response != null && response['success'] == true){
      leaveRequestsModel = LeaveRequestsModel.fromJson(response);
      notifyListeners();
    }
    return leaveRequestsModel;
  }

  Future<void> fetchStudentAttendance({required String selectedDate}) async {
    EasyLoading.show();

    var data = {
      "attendance_date" : selectedDate,
      "class_id": selectedStudentProfile!.classModel!.sId,
      "student_id": selectedStudentProfile!.sId,
    };
    var response = await ApiService.request("${ApiPaths.viewStudentClassAttendance}", method: RequestMethod.POST, data: data);

    if(response!= null){
      log("Attendance response: $response");
      if(response['success'] == true){
        studentsAttendanceModel = StudentsAttendanceModel.fromJson(response);
        notifyListeners();
      }else{
        studentsAttendanceModel = StudentsAttendanceModel();
        notifyListeners();
      }
    }

    EasyLoading.dismiss();
  }

}
