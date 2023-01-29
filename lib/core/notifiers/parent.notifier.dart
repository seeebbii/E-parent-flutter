import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/core/api/api_paths.dart';
import 'package:e_parent_kit/core/api/api_service.dart';
import 'package:e_parent_kit/core/models/authentication/authentication.model.dart';
import 'package:e_parent_kit/core/models/student/select_student.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/core/notifiers/authentication.notifier.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/core/view_models/bottom_nav_bar_VM.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:e_parent_kit/meta/utils/hive_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParentNotifier extends ChangeNotifier{
  // Data Variables
  SelectStudentsModel myStudents = SelectStudentsModel();
  StudentModel? selectedStudentProfile = StudentModel();

  bool get checkStudentsSelections => myStudents.data == null || myStudents.data!.isEmpty ? false : myStudents.data!.where((element) => element.selected == true,).isNotEmpty;
  List<StudentModel> get getAllSelectedStudents => myStudents.data!.where((element) => element.selected == true,).toList();

  void setStudentProfile(BuildContext context, {StudentModel? student}){
    if(student == null){
      selectedStudentProfile = context.read<AuthenticationNotifier>().authModel.parentData?.students?.first;
    }else{
      selectedStudentProfile = student;
      notifyListeners();
    }
    // TODO :: Fetch data against selected student

  }

  Future<SelectStudentsModel> fetchStudentsFromNumber(String completePhoneNumber) async {
    var response = await ApiService.request("${ApiPaths.fetchStudents}$completePhoneNumber", method: RequestMethod.GET);
    if(response != null){
      log("$response");
      myStudents = SelectStudentsModel.fromJson(response);
      selectedStudentProfile = myStudents.data?[0];
      notifyListeners();
    }
    return myStudents;
  }

  Future<void> addStudents(BuildContext context, {required String parentId, required List<String> studentIds}) async {

    var data = {
      "parent_id" : parentId,
      "students": studentIds
    };

    var response = await ApiService.request("${ApiPaths.addStudents}", method: RequestMethod.POST, data: data);

    if(response != null){
      if(response['success'] == true){
        await context.read<AuthenticationNotifier>().fetchProfile();

        BaseHelper.showSnackBar('${response['message']}');
      }else{
        BaseHelper.showSnackBar('${response['message']}');
      }
    }
  }


}