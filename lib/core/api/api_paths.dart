

class ApiPaths {
  static String liveBaseURL = "https://e-parent-kit.herokuapp.com/api/";
  static String localBaseUrl = "http://10.0.2.2:8080/api/";
  static String socketBaseUrl = "http://10.0.2.2:8080/";
  // static String socketBaseUrl = "https://e-parent-kit.herokuapp.com/";
  static String baseURL = localBaseUrl;

  // Endpoints
  static String authRoute =  "auth/";
  static String courseRoute =  "course/";
  static String classRoute =  "class/";
  static String teacherRoute =  "teacher/";
  static String studentRoute =  "student/";
  static String parentRoute =  "parent/";
  static String chatRoute =  "chat/";

  // User Auth Apis
  static String login =  "${baseURL}${authRoute}login";
  static String register =  "${baseURL}${authRoute}register";
  static String profile =  "${baseURL}${authRoute}profile";
  static String updateProfile =  "${baseURL}${authRoute}edit_profile";
  static String changePassword =  "${baseURL}${authRoute}change_password";
  static String userNotifications =  "${baseURL}${authRoute}notifications";
  static String updateNotificationStatus =  "${baseURL}${authRoute}update_notification_status";
  static String resendOtp =  "${baseURL}${authRoute}resend";
  static String verifyOtp =  "${baseURL}${authRoute}verify";
  static String resetPassword =  "${baseURL}reset_password";
  static String logout =  "${baseURL}logout";

  // Student Apis
  static String fetchStudents =  "${baseURL}${studentRoute}";
  static String createStudent =  "${baseURL}${studentRoute}add";
  static String manageEnrollment =  "${baseURL}${studentRoute}insert_courses";
  static String fetchStudentsForEnrollment =  "${baseURL}${studentRoute}manage_enrollment/search/";

  // Teacher Apis
  static String addCourses =  "${baseURL}${teacherRoute}add_courses";
  static String getAllTeachers =  "${baseURL}${teacherRoute}";


  // Parent Apis
  static String addStudents =  "${baseURL}${parentRoute}add_students";

  // Course apis
  static String fetchCourses =  "${baseURL}${courseRoute}";
  static String createCourse =  "${baseURL}${courseRoute}insert";

  // Class apis
  static String fetchClasses =  "${baseURL}${classRoute}";
  static String createClass =  "${baseURL}${classRoute}insert";
  static String studentsInClass =  "${baseURL}${classRoute}students_in_class/";
  static String getTeacherClassDiary =  "${baseURL}${classRoute}view_teacher_class_diaries";
  static String getStudentClassDiary =  "${baseURL}${classRoute}view_class_diaries/";
  static String viewDiaryByDate =  "${baseURL}${classRoute}view_diary_date/";
  static String uploadClassDiary =  "${baseURL}${classRoute}create_diary/";
  static String assignStudents =  "${baseURL}${classRoute}assign_students/";
  static String updateClassTeacher =  "${baseURL}${classRoute}update_class_teacher/";
  static String uploadClassAttendance =  "${baseURL}${classRoute}upload_class_attendance/";
  static String viewClassAttendance =  "${baseURL}${classRoute}view_class_attendance/";
  static String viewStudentClassAttendance =  "${baseURL}${classRoute}view_student_attendance/";

  static String requestLeaveFromParent =  "${baseURL}${classRoute}request_leave/";
  static String allLeaveRequests =  "${baseURL}${classRoute}view_request_leave/";
  static String viewParentLeaveRequests =  "${baseURL}${classRoute}view_parent_request_leave/";

  static String acceptRequest =  "${baseURL}${classRoute}accept_request_leave/";
  static String rejectRequest =  "${baseURL}${classRoute}reject_request_leave/";

  static String fetchParent =  "${baseURL}${classRoute}fetch_parent/";

  static String uploadAcademics =  "${baseURL}${classRoute}upload_academics/";
  static String uploadAssignment =  "${baseURL}${classRoute}upload_class_assignment/";
  static String viewAcademics =  "${baseURL}${classRoute}view_academics/";

  // Chat Apis
  static String fetchAdminChats =  "${baseURL}${chatRoute}admin/";
  static String fetchUserChats =  "${baseURL}${chatRoute}";
  static String createChatRoom =  "${baseURL}${chatRoute}create_room";
  static String fetchMessages =  "${baseURL}${chatRoute}messages";
  static String sendMessage =  "${baseURL}${chatRoute}send_message";

}
