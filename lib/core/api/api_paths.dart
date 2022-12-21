

class ApiPaths {
  static String liveBaseURL = "https://socialapp.e_parent_kit.com/api/";
  static String baseURL = liveBaseURL;

  // endpoints
  // static String rider = "rider/";

  // User Auth Apis
  static String login =  "${baseURL}login";
  static String socialLogin =  "${baseURL}social_login";
  static String register =  "${baseURL}register";
  static String requestOtp =  "${baseURL}request_otp";
  static String verifyOtp =  "${baseURL}verify_otp";
  static String resetPassword =  "${baseURL}reset_password";
  static String logout =  "${baseURL}logout";

  // User Profile Apis
  static String checkUsername =  "${baseURL}check_username";
  static String checkNumber =  "${baseURL}check_number";
  static String checkEmail =  "${baseURL}check_email";
  static String getUserProfile =  "${baseURL}get_user_profile";
  static String getOtherUserProfile =  "${baseURL}get_profile";
  static String followUnfollow =  "${baseURL}follow_unfollow";
  static String updateUserProfileImage =  "${baseURL}update_profile_image";
  static String updateUserProfile =  "${baseURL}update_profile";
  static String fetchUserFollowing =  "${baseURL}following/list";
  static String fetchUserFollowers =  "${baseURL}followers/list";

  // Chat Apis
  static String getUserChats =  "${baseURL}getContacts";
  static String getMessages =  "${baseURL}fetchMessages";
  static String sendMessages =  "${baseURL}sendMessage";

  // Feed Apis
  static String fetchPosts =  "${baseURL}get_all_post";
  static String fetchAnonymousPosts =  "${baseURL}get_all_anonymous_post";
  static String fetchExplore =  "${baseURL}get_all_post_images";
  static String fetchReels =  "${baseURL}get_all_post_vedios";
  static String fetchReportList =  "${baseURL}report/message/list";
  static String reportAbuse =  "${baseURL}abuse/report/post";
  static String deletePost =  "${baseURL}delete_post";
  static String fetchStories =  "${baseURL}new_get_stories";
  static String postComments =  "${baseURL}post_comments";
  static String addComment =  "${baseURL}comment_add";
  static String likePost =  "${baseURL}like_post";

  // Upload Apis
  static String uploadPost =  "${baseURL}create_user_post";
  static String updatePost =  "${baseURL}update_user_post";
  static String uploadAnonymousPost = "${baseURL}create_anonymous_post";
  static String uploadStory =  "${baseURL}save_user_story";

  // Tag apis
  static String searchTag =  "${baseURL}search_tag";
  static String searchMentions =  "${baseURL}get_users";


}
