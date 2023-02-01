import 'dart:developer';

import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/core/api/api_paths.dart';
import 'package:e_parent_kit/core/api/api_service.dart';
import 'package:e_parent_kit/core/models/attendance/students_attendance.model.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/authentication/authentication.model.dart';
import 'package:e_parent_kit/core/models/class/all_classes.model.dart';
import 'package:e_parent_kit/core/models/class/class.model.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
import 'package:e_parent_kit/core/models/diary/teacher_class_diary.model.dart';
import 'package:e_parent_kit/core/models/teacherr/all_teachers.model.dart';
import 'package:e_parent_kit/core/notifiers/parent.notifier.dart';
import 'package:e_parent_kit/core/view_models/authentication_VM.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'authentication.notifier.dart';

class ClassNotifier extends ChangeNotifier{

  final TextEditingController diaryController = TextEditingController();

  final statusList = <String>[
    'P',
    'A',
    'L',
  ];

  AllClassesModel allClassesModel = AllClassesModel();
  TeachersDataList teacherAssigned = TeachersDataList();

  ClassModel selectedClass = ClassModel();
  CourseModel selectedCourse = CourseModel();

  TeacherClassDiary teacherClassDiary = TeacherClassDiary();
  TeacherClassDiary studentClassDiary = TeacherClassDiary();

  Future<void> createClass({required int grade, required String section}) async {
    var data = {"grade": grade, "section": section, "teacherId": teacherAssigned.user!.sId};
    var response = await ApiService.request(ApiPaths.createClass, method: RequestMethod.POST, data: data);
    if (response != null) {
      if(response['success'] == true){
        navigationController.goBack();
        BaseHelper.showSnackBar(response['message']);
      }else{
        BaseHelper.showSnackBar(response['message']);
      }
    }
  }

  Future<AllClassesModel> fetchAllClasses({String teacherId = ''}) async {
    var response;
    if(teacherId == ''){
      response = await ApiService.request("${ApiPaths.fetchClasses}", method: RequestMethod.GET,);
    }else{
      response = await ApiService.request("${ApiPaths.fetchClasses}$teacherId", method: RequestMethod.GET,);
    }
    if(response != null){
      allClassesModel = AllClassesModel.fromJson(response);
      notifyListeners();
    }
    return allClassesModel;
  }

  Future<TeacherClassDiary> fetchTeacherClassDiary({required String teacherId}) async {

    var classesResponse = await ApiService.request("${ApiPaths.fetchClasses}$teacherId", method: RequestMethod.GET,);

    if(classesResponse != null){
      AllClassesModel teacherClasses = AllClassesModel.fromJson(classesResponse);

      List<String> teacherClassIds = [];
      teacherClasses.data!.forEach((element) {
        teacherClassIds.add(element.sId!);
      });

      var data = {
        "class_id": teacherClassIds
      };

      var response = await ApiService.request("${ApiPaths.getTeacherClassDiary}", method: RequestMethod.POST, data: data);

      if(response != null && response['success'] == true){
        teacherClassDiary = TeacherClassDiary.fromJson(response);
        notifyListeners();
      }

    }


    return teacherClassDiary;
  }

  Future<TeacherClassDiary> fetchClassDiary(BuildContext context) async {

    log("${context.read<ParentNotifier>().selectedStudentProfile?.classModel?.sId}");

    String classId = context.read<ParentNotifier>().selectedStudentProfile?.classModel?.sId ?? "";

    var response = await ApiService.request("${ApiPaths.getStudentClassDiary}$classId", method: RequestMethod.GET);
    log("$response");
    if(response != null ){
      if(response['success'] == true){
        studentClassDiary = TeacherClassDiary.fromJson(response);
        notifyListeners();
      }
    }
    return studentClassDiary;
  }

  Future<void> uploadClassDiary(BuildContext context) async {

    log("${context.read<AuthenticationScreenVM>().dobController.text.trim()}");
    var data = {
      "class_id" : selectedClass.sId,
      "diary": diaryController.text.trim(),
      "current_date" : context.read<AuthenticationScreenVM>().dobController.text.trim(),
      "teacher_id" : context.read<AuthenticationNotifier>().authModel.user!.sId
    };

    var response = await ApiService.request("${ApiPaths.uploadClassDiary}", method: RequestMethod.POST, data: data);

    if(response != null){
      if(response['success'] == true){
        await fetchTeacherClassDiary(teacherId: context.read<AuthenticationNotifier>().authModel.user!.sId!);
        navigationController.goBack();
        BaseHelper.showSnackBar("${response['message']}");
      }else{
        BaseHelper.showSnackBar("${response['message']}");
      }
    }
  }

  Future<void> updateStudentsEnrolled(List<String> selectedStudentIds, BuildContext context) async {

    var data = {
      "student_ids" : selectedStudentIds,
      'class_id': selectedClass.sId
    };

    var response = await ApiService.request(ApiPaths.assignStudents, method: RequestMethod.POST, data: data);

    if (response != null) {
      await refreshAllClasses(context);
      BaseHelper.showSnackBar('${response['message']}');
    }

  }

  Future<void> updateClassTeacher(BuildContext context) async {

    var data = {
      "teacher_id" : teacherAssigned.user!.sId,
      'class_id': selectedClass.sId
    };

    var response = await ApiService.request(ApiPaths.updateClassTeacher, method: RequestMethod.POST, data: data);

    if(response != null) {
      if(response['success'] == true){
        await refreshAllClasses(context);
        BaseHelper.showSnackBar(response['message']);
      }else{
        BaseHelper.showSnackBar(response['message']);
      }
    }

  }

  Future<void> refreshAllClasses(BuildContext context) async {
    if (context.read<AuthenticationNotifier>().authModel.user?.authRole ==
        Role.TeacherAdmin) {
      // Fetch all classes
      await context.read<ClassNotifier>().fetchAllClasses();
    } else if (context
        .read<AuthenticationNotifier>()
        .authModel
        .user
        ?.authRole ==
        Role.Teacher) {
      // Fetch teacher classes only
      await context.read<ClassNotifier>().fetchAllClasses(
          teacherId: context.read<AuthenticationNotifier>().authModel.user!.sId!);
    }
  }

  Future<void> uploadClassAttendance(BuildContext context) async {

    List<Map<String, dynamic>> mappedArray = [];

    selectedClass.studentsEnrolled?.forEach((element) {
      // log("${element.toJson()}");
      mappedArray.add({
        "class_id": element.classModel?.sId,
        "student_id": element.sId,
        "attendance_date": context.read<AuthenticationScreenVM>().dobController.text.trim(),
        "attendance_status" : element.statusTextEditingController.text.trim(),
      });
    });

    var data = {
      "students": mappedArray,
      'attendance_date' : context.read<AuthenticationScreenVM>().dobController.text.trim(),
    };

    var response = await ApiService.request(ApiPaths.uploadClassAttendance, method: RequestMethod.POST, data: data);

    if(response != null) {
      if(response['success'] == true){

        BaseHelper.showSnackBar(response['message']);
      }else{
        BaseHelper.showSnackBar(response['message']);
      }
    }

  }

  Future<void> loadAttendanceFromDate(BuildContext context) async {
    EasyLoading.show();

    var data = {
      "attendance_date": context.read<AuthenticationScreenVM>().dobController.text.trim(),
      "class_id": selectedClass.sId,
    };

    var response = await ApiService.request(ApiPaths.viewClassAttendance, method: RequestMethod.POST, data: data);
    log("$response");
    if(response != null) {

      if(response['success'] == true){
        StudentsAttendanceModel studentsAttendanceModel = StudentsAttendanceModel.fromJson(response);

        studentsAttendanceModel.data?.forEach((element) {
          // Compare fetched attendance array with selected class's students and update on UI
          selectedClass.studentsEnrolled?.forEach((student) {
            if(student.sId == element.studentId){
              student.statusTextEditingController.text =  element.attendanceStatus!;
              student.studentAttendanceStatusKey.currentState?.changeSelectedItem(element.attendanceStatus!);
            }
          });
        });
        notifyListeners();
      }else{
        BaseHelper.showSnackBar("No previous record found");
        selectedClass.studentsEnrolled?.forEach((student) {
          student.statusTextEditingController.text =  "P";
          student.studentAttendanceStatusKey.currentState?.changeSelectedItem("P");
        });
        notifyListeners();
      }

    }

    EasyLoading.dismiss();
  }

  Future<void> viewDiaryByDate(BuildContext context) async {
    EasyLoading.show();

    var data = {
      "diary_date": context.read<AuthenticationScreenVM>().dobController.text.trim(),
      "class_id": selectedClass.sId,
    };

    var response = await ApiService.request(ApiPaths.viewDiaryByDate, method: RequestMethod.POST, data: data);

    if(response != null) {

      if(response['success'] == true){
        Diary diary = Diary.fromJson(response['data']);
        diaryController.text = diary.diary ?? "";
        log("${diary.toJson()}");
        notifyListeners();
      }

    }

    EasyLoading.dismiss();
  }


  void assignTeacher(TeachersDataList teacher){
    teacherAssigned = teacher;
    notifyListeners();
  }

  void assignClass(ClassModel className){
    selectedClass = className;
    notifyListeners();
  }


  void assignCourse(CourseModel course){
    selectedCourse = course;
    notifyListeners();
  }

  void setStudentAttendanceStatus(BuildContext context) {

    context.read<AuthenticationScreenVM>().dobController.clear();
    context.read<AuthenticationScreenVM>().currentDob = DateTime.now();

    selectedClass.studentsEnrolled?.forEach((element) {
      element.statusTextEditingController.text = 'P';
      element.studentAttendanceStatusKey.currentState?.changeSelectedItem("P");
    });
    notifyListeners();
  }

  void setDateAndDiaryController(BuildContext context) {

    diaryController.clear();
    context.read<AuthenticationScreenVM>().dobController.clear();
    context.read<AuthenticationScreenVM>().currentDob = DateTime.now();

    notifyListeners();
  }

  void resetDate(BuildContext context) {
    context.read<AuthenticationScreenVM>().dobController.clear();
    context.read<AuthenticationScreenVM>().currentDob = DateTime.now();

    notifyListeners();
  }





}