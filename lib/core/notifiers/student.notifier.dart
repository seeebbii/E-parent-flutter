import 'dart:developer';

import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/core/api/api_paths.dart';
import 'package:e_parent_kit/core/api/api_service.dart';
import 'package:e_parent_kit/core/models/class/class.model.dart';
import 'package:e_parent_kit/core/models/course/course.model.dart';
import 'package:e_parent_kit/core/models/course/select_course.model.dart';
import 'package:e_parent_kit/core/models/student/enrollment.model.dart';
import 'package:e_parent_kit/core/models/student/student.model.dart';
import 'package:e_parent_kit/meta/utils/base_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication.notifier.dart';

class StudentNotifier extends ChangeNotifier{

  SelectCoursesModel studentCourses = SelectCoursesModel();
  EnrollmentModel enrollmentModel = EnrollmentModel();
  List<CourseModel>? filterCourses = <CourseModel>[];

  List<StudentModel>? filterStudents = <StudentModel>[];

  List<CourseModel> get getAllSelectedCourses => studentCourses.data!.where((element) => element.selected == true,).toList();
  bool get checkCourseSelections => studentCourses.data == null || studentCourses.data!.isEmpty ? false : studentCourses.data!.where((element) => element.selected == true,).isNotEmpty;

  bool get checkStudentSelected => filterStudents == null || filterStudents!.isEmpty ? false : filterStudents!.where((element) => element.selected == true,).isNotEmpty;

  int get totalSelectedCourses {
    int count = 1;
    studentCourses.data?.forEach((element){
      if(element.selected == true){
        count ++;
      }
    });
    return count;
  }

  Future<void> manageEnrollment(BuildContext context, {required String studentId, required List<String> courseIds}) async {

    var data = {
      "student_id" : studentId,
      "courses": courseIds
    };

    var response = await ApiService.request("${ApiPaths.manageEnrollment}", method: RequestMethod.POST, data: data);

    if(response != null){
      if(response['success'] == true){
        await fetchStudentsSearch(query: '');
        navigationController.goBack();
        BaseHelper.showSnackBar('${response['message']}');
      }else{
        BaseHelper.showSnackBar('${response['message']}');
      }
    }
  }


  Future<void> createStudent({required String fullName, required String phone, required String dob, required String classId}) async {

    var data = {
      "full_name" : fullName,
      "parent_phone" : phone,
      "dob" : dob,
      'class_id': classId
    };

    var response = await ApiService.request("${ApiPaths.createStudent}",
        method: RequestMethod.POST, data: data);

    if (response != null ) {
      if(response['success'] == true){
        navigationController.goBack();
        BaseHelper.showSnackBar(response['message']);
      }else{
        BaseHelper.showSnackBar(response['message']);
      }
    }
  }

  Future<EnrollmentModel> fetchStudentsSearch({required String query, ClassModel? selectedClass = null}) async {

    var response = await ApiService.request("${ApiPaths.fetchStudentsForEnrollment}$query",
        method: RequestMethod.GET);

    if (response != null ) {
      enrollmentModel = EnrollmentModel.fromJson(response);
      enrollmentModel.students?.forEach((element) {element.selected = false;});
      filterStudents = enrollmentModel.students;

      if(selectedClass != null){
        filterStudents?.forEach((student) {

          selectedClass.studentsEnrolled?.forEach((classStudent) {
            if(student.sId == classStudent.sId){
              student.selected = true;
            }
          });

        });
      }

      notifyListeners();
    }

    return enrollmentModel;
  }


  Future<SelectCoursesModel> fetchAllCourses(StudentModel currentStudent) async {
    var response = await ApiService.request("${ApiPaths.fetchCourses}", method: RequestMethod.GET);

    if(response != null && response['success'] == true){
      studentCourses = SelectCoursesModel.fromJson(response);

      studentCourses.data?.forEach((course) {
        // If current course id exists in students curses module, mark it as selected->true
        int? status = currentStudent.coursesEnrolled?.indexWhere((currentStudentCourse) => currentStudentCourse.sId == course.sId);
        if(status != null && status != -1){
          course.selected = true;
          notifyListeners();
        }

      });

      filterCourses = studentCourses.data;

      notifyListeners();
    }
    return studentCourses;
  }

}