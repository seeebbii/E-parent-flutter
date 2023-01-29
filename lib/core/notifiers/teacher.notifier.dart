import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/core/api/api_paths.dart';
import 'package:e_parent_kit/core/api/api_service.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
import 'package:e_parent_kit/core/models/course/select_course.model.dart';
import 'package:e_parent_kit/core/models/diary/teacher_class_diary.model.dart';
import 'package:e_parent_kit/core/models/teacherr/all_teachers.model.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication.notifier.dart';

class TeacherNotifier extends ChangeNotifier {
  // Data Variables
  SelectCoursesModel myCourses = SelectCoursesModel();
  AllTeachersModel allTeachersModel = AllTeachersModel();


  List<TeachersDataList>? filterTeachers = <TeachersDataList>[];

  bool get checkCoursesSelections => myCourses.data == null || myCourses.data!.isEmpty ? false : myCourses.data!.where((element) => element.selected == true,).isNotEmpty;
  List<CourseModel> get getAllSelectedCourses => myCourses.data!.where((element) => element.selected == true,).toList();

  Future<SelectCoursesModel> fetchAllCourses() async {
    var response = await ApiService.request("${ApiPaths.fetchCourses}", method: RequestMethod.GET);

    if(response != null && response['success'] == true){
      myCourses = SelectCoursesModel.fromJson(response);
      notifyListeners();
    }
    return myCourses;
  }

  Future<void> addCourses(BuildContext context, {required String teacherId, required List<String> courseIds}) async {

    var data = {
      "teacher_id" : teacherId,
      "courses": courseIds
    };

    var response = await ApiService.request("${ApiPaths.addCourses}", method: RequestMethod.POST, data: data);

    if(response != null){
      if(response['success'] == true){
        await context.read<AuthenticationNotifier>().fetchProfile();
        navigationController.getOffAll(RouteGenerator.rootScreen);
        BaseHelper.showSnackBar('${response['message']}');
      }else{
        BaseHelper.showSnackBar('${response['message']}');
      }
    }
  }

  Future<AllTeachersModel> fetchAllTeachers() async {
    var response = await ApiService.request("${ApiPaths.getAllTeachers}", method: RequestMethod.GET);

    if(response != null && response['success'] == true){
      allTeachersModel = AllTeachersModel.fromJson(response);
      filterTeachers = allTeachersModel.teachers;
      notifyListeners();
    }
    return allTeachersModel;
  }

}