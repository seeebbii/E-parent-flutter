import 'dart:developer';

import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/core/api/api_paths.dart';
import 'package:e_parent_kit/core/api/api_service.dart';
import 'package:e_parent_kit/core/models/authentication/auth_data.model.dart';
import 'package:e_parent_kit/core/models/authentication/authentication.model.dart';
import 'package:e_parent_kit/core/models/class/all_classes.model.dart';
import 'package:e_parent_kit/core/models/class/class.model.dart';
import 'package:e_parent_kit/core/models/diary/teacher_class_diary.model.dart';
import 'package:e_parent_kit/core/models/teacherr/all_teachers.model.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'authentication.notifier.dart';

class ClassNotifier extends ChangeNotifier{
  AllClassesModel allClassesModel = AllClassesModel();
  TeachersDataList teacherAssigned = TeachersDataList();

  ClassModel selectedClass = ClassModel();

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

  Future<TeacherClassDiary> fetchClassDiary({required String classId}) async {

    print(classId);

    // var response = await ApiService.request("${ApiPaths.getStudentClassDiary}$classId", method: RequestMethod.POST);
    //
    // if(response != null && response['success'] == true){
    //   teacherClassDiary = TeacherClassDiary.fromJson(response);
    //   notifyListeners();
    // }
    return teacherClassDiary;
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


  void assignTeacher(TeachersDataList teacher){
    teacherAssigned = teacher;
    notifyListeners();
  }

  void assignClass(ClassModel className){
    selectedClass = className;
    notifyListeners();
  }


}