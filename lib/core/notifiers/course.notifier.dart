import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/core/api/api_paths.dart';
import 'package:e_parent_kit/core/api/api_service.dart';
import 'package:e_parent_kit/core/models/teacherr/all_teachers.model.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:flutter/foundation.dart';

class CourseNotifier extends ChangeNotifier {



  Future<void> createCourse({required String courseName, required String courseCode}) async {
    var data = {"course_name": courseName, "course_code": courseCode,};
    var response = await ApiService.request(ApiPaths.createCourse, method: RequestMethod.POST, data: data);
    if (response != null) {
      if(response['success'] == true){
        navigationController.goBack();
        BaseHelper.showSnackBar(response['message']);
      }else{
        BaseHelper.showSnackBar(response['message']);
      }
    }
  }

}
