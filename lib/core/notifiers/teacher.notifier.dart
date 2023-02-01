import 'dart:developer';
import 'dart:io';

import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/core/api/api_paths.dart';
import 'package:e_parent_kit/core/api/api_service.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/class/academics.model.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
import 'package:e_parent_kit/core/models/course/select_course.model.dart';
import 'package:e_parent_kit/core/models/diary/teacher_class_diary.model.dart';
import 'package:e_parent_kit/core/models/student/leave_requests.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/core/models/teacherr/all_teachers.model.dart';
import 'package:e_parent_kit/core/notifiers/class.notifier.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart' as dio;
import 'authentication.notifier.dart';

class TeacherNotifier extends ChangeNotifier {
  // Data Variables
  SelectCoursesModel myCourses = SelectCoursesModel();
  AllTeachersModel allTeachersModel = AllTeachersModel();
  LeaveRequestsModel leaveRequestsModel = LeaveRequestsModel();
  StudentModel selectedStudentProfile = StudentModel();
  CourseModel selectedCourse = CourseModel();
  AcademicsModel academicsModel = AcademicsModel();
  AuthData selectedTeacher = AuthData();

  void assignStudent(StudentModel student) {
    selectedStudentProfile = student;
    notifyListeners();
  }

  void assignCourse(CourseModel course) {
    selectedCourse = course;
    notifyListeners();
  }

  void assignTeacher(AuthData auth) {
    selectedTeacher = auth;
    notifyListeners();
  }

  List<TeachersDataList>? filterTeachers = <TeachersDataList>[];

  bool get checkCoursesSelections =>
      myCourses.data == null || myCourses.data!.isEmpty
          ? false
          : myCourses.data!
              .where(
                (element) => element.selected == true,
              )
              .isNotEmpty;

  List<CourseModel> get getAllSelectedCourses => myCourses.data!
      .where(
        (element) => element.selected == true,
      )
      .toList();

  Future<SelectCoursesModel> fetchAllCourses() async {
    var response = await ApiService.request("${ApiPaths.fetchCourses}",
        method: RequestMethod.GET);

    if (response != null && response['success'] == true) {
      myCourses = SelectCoursesModel.fromJson(response);
      notifyListeners();
    }
    return myCourses;
  }

  Future<void> addCourses(BuildContext context,
      {required String teacherId, required List<String> courseIds}) async {
    var data = {"teacher_id": teacherId, "courses": courseIds};

    var response = await ApiService.request("${ApiPaths.addCourses}",
        method: RequestMethod.POST, data: data);

    if (response != null) {
      if (response['success'] == true) {
        await context.read<AuthenticationNotifier>().fetchProfile();
        navigationController.getOffAll(RouteGenerator.rootScreen);
        BaseHelper.showSnackBar('${response['message']}');
      } else {
        BaseHelper.showSnackBar('${response['message']}');
      }
    }
  }

  Future<AllTeachersModel> fetchAllTeachers() async {
    var response = await ApiService.request("${ApiPaths.getAllTeachers}",
        method: RequestMethod.GET);

    if (response != null && response['success'] == true) {
      allTeachersModel = AllTeachersModel.fromJson(response);
      filterTeachers = allTeachersModel.teachers;
      notifyListeners();
    }
    return allTeachersModel;
  }

  Future<LeaveRequestsModel> fetchAllLeaveRequests(BuildContext context) async {
    var data = {
      "class_id": context.read<ClassNotifier>().selectedClass.sId,
      "teacher_id": context.read<AuthenticationNotifier>().authModel.user!.sId,
    };

    var response = await ApiService.request("${ApiPaths.allLeaveRequests}",
        method: RequestMethod.POST, data: data);
    if (response != null && response['success'] == true) {
      leaveRequestsModel = LeaveRequestsModel.fromJson(response);
      notifyListeners();
    }
    return leaveRequestsModel;
  }

  Future<void> acceptLeaveRequest(
      Requests request, BuildContext context, int index) async {
    var data = {
      "leave_id": request.sId,
      "parent_id": request.parentId?.sId,
      'teacher_id': request.teacherId,
      'student_id': request.studentId?.sId,
    };

    var response = await ApiService.request("${ApiPaths.acceptRequest}",
        method: RequestMethod.POST, data: data);

    if (response != null) {
      if (response['success'] == true) {
        // Set current request model status to true
        leaveRequestsModel.request?.elementAt(index).leaveStatus = true;
        notifyListeners();
        BaseHelper.showSnackBar('${response['message']}');
      } else {
        BaseHelper.showSnackBar('${response['message']}');
      }
    }
  }

  Future<void> rejectLeaveRequest(
      Requests request, BuildContext context, int index) async {
    var data = {
      "leave_id": request.sId,
      "parent_id": request.parentId?.sId,
      'teacher_id': request.teacherId,
      'student_id': request.studentId?.sId,
    };

    var response = await ApiService.request("${ApiPaths.rejectRequest}",
        method: RequestMethod.POST, data: data);

    if (response != null) {
      if (response['success'] == true) {
        // Set current request model status to true
        leaveRequestsModel.request?.elementAt(index).leaveStatus = false;
        notifyListeners();
        BaseHelper.showSnackBar('${response['message']}');
      } else {
        BaseHelper.showSnackBar('${response['message']}');
      }
    }
  }

  Future<AuthData> fetchParentObject(String parentPhone) async {
    var data = {"phone_number": parentPhone};

    var response = await ApiService.request("${ApiPaths.fetchParent}",
        method: RequestMethod.POST, data: data);
    if (response != null) {
      return AuthData.fromJson(response['data']);
    }
    return AuthData();
  }

  Future<void> uploadAssignment(
      {required String title,
      required File file,
      required BuildContext context}) async {
    var multipartFile = await dio.MultipartFile.fromFile(file.path);
    var data = {
      "file": multipartFile,
      "class_id": context.read<ClassNotifier>().selectedClass.sId,
      "title": title,
      "teacher_id": context.read<AuthenticationNotifier>().authModel.user!.sId,
    };

    var response = await ApiService.request("${ApiPaths.uploadAssignment}",
        method: RequestMethod.POST, data: data);
    if (response != null) {
      if (response['success'] == true) {
        navigationController.goBack();
        BaseHelper.showSnackBar('${response['message']}');
      } else {
        BaseHelper.showSnackBar('${response['message']}');
      }
    }
  }

  Future<void> uploadStudentAcademic(
      {required BuildContext context,
      required String title,
      required double totalMarks,
      required double obtainedMarks,
      required String type}) async {
    TeacherNotifier teacherNotifier = context.read<TeacherNotifier>();
    ClassNotifier classNotifier = context.read<ClassNotifier>();

    var data = {
      "student_id": selectedStudentProfile.sId,
      "course_id": selectedCourse.sId,
      "class_id": classNotifier.selectedClass.sId,
      "teacher_id": context.read<AuthenticationNotifier>().authModel.user!.sId,
      "type": type,
      "title": title,
      "total_marks": totalMarks,
      "obtained_marks": obtainedMarks,
    };

    var response = await ApiService.request("${ApiPaths.uploadAcademics}",
        method: RequestMethod.POST, data: data);
    if (response != null) {
      if (response['success'] == true) {
        navigationController.goBack();
        BaseHelper.showSnackBar('${response['message']}');
      } else {
        BaseHelper.showSnackBar('${response['message']}');
      }
    }
  }

  Future<AcademicsModel> viewAcademics({
    required BuildContext context,
  }) async {
    TeacherNotifier teacherNotifier = context.read<TeacherNotifier>();
    ClassNotifier classNotifier = context.read<ClassNotifier>();

    var data = {
      "student_id": selectedStudentProfile.sId,
      "course_id": selectedCourse.sId,
      "class_id": classNotifier.selectedClass.sId,
    };

    var response = await ApiService.request("${ApiPaths.viewAcademics}",
        method: RequestMethod.POST, data: data);
    if (response != null) {
      academicsModel = AcademicsModel.fromJson(response);
      notifyListeners();
    }
    return academicsModel;
  }
}
