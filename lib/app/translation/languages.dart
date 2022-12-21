import 'package:e_parent_kit/app/constants/controller.constant.dart';
import 'package:e_parent_kit/core/router/router_generator.dart';
import 'package:e_parent_kit/meta/utils/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

class Languages extends Translations {

  static final Locale locale = Locale('en', 'US');
  static final Locale fallbackLocale = Locale('en', 'US');
  static Locale currentLocale = locale;

  static const String english = "English";
  static const String arabic = "عربى";

  static final List<Locale> locales = <Locale>[
    Locale('en', 'US'),
    Locale('ar', 'IQ'),
  ];

  static void changeLocale(String language) {
    switch (language) {
      case english:
        updateLocale(locales[0]);
        break;
      case arabic:
        updateLocale(locales[1]);
        break;
      default:
        updateLocale(locales[0]);
        break;
    }
  }

  static LocaleType getLocaleType() {
    switch (currentLocale.toLanguageTag()) {
      case "en-US":
        return LocaleType.en;
      case "ar-IQ":
        return LocaleType.ar;
      default:
        return LocaleType.en;
    }
  }

  static void init() {
    Locale prefLocale = Locale(
        SharedPref().pref.getString(SharedPref.languageCode) ?? 'en',
        SharedPref().pref.getString(SharedPref.countryCode) ?? 'US');
    Get.updateLocale(prefLocale);
    currentLocale = prefLocale;
  }

  static void updateLocale(Locale locale) {
    Get.updateLocale(locale);
    currentLocale = locale;
    SharedPref().pref.setString(SharedPref.languageCode, locale.languageCode);
    SharedPref().pref.setString(SharedPref.countryCode, locale.countryCode ?? "");

    navigationController.getOffAll(RouteGenerator.lastRoute);
  }

  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        // ENGLISH (USA)
        'en_US': {
          'change_language': 'Change Language',
          'welcome_back': 'Welcome Back',
          'mobile_number': "Mobile Number",
          'mobile_error_text': "Please provide your mobile number",
          'password': 'Password',
          'required': 'Required',
          'password_error_text_1': 'Password is required',
          'password_error_text_2': 'The password must be at least 8 characters',
          'keep_logged_in': 'Keep me logged in',
          'login': 'Log in',
          'forgot_password': 'Forgot Password?',
          'or_continue_with': 'Or continue with',
          'dont_have_an_account': 'Don\'t have an account?',
          'signup': ' Sign Up',
          'phone_number': 'Phone Number',
          'invalid_number': 'Invalid Number',
          'search_country': 'Search your country',
          'email': 'Email',
          'please_provide_email': 'Please provide your Email',
          'invalid_email': 'Invalid email',
          'sign_in': 'SIGN IN',
          'sign_in_low': ' Sign in',
          'forgot_password_title': 'Forgot Password',
          'forgot_password_subtitle':
              'Enter your email or phone below to reset your password',
          'mobile': 'Mobile',
          'send_otp': 'Send OTP',
          'enter_four_digit_code': 'Enter 4 Digit code',
          'enter_four_digit_code_email':
              'Enter the 4 digits code that you received on your email.',
          'continue': 'Continue',
          'reset_password': 'Reset Password',
          'set_new_password':
              'Set the new password for your account so you can login',
          'confirm_password': 'Confirm Password',
          'password_doesnt_match': 'Passwords doesn\'t match',
          'full_name': 'Full name',
          'please_provider_full_name': 'Please provide your Full Name',
          'gender': 'Gender',
          'male': 'Male',
          'female': 'Female',
          'or_register_via': 'Or Register via',
          'already_have_an_account': 'Already have an account?',
          'by_clicking_sign_up': 'By clicking Sign Up, you agree to our',
          'terms': ' Terms,',
          'data_policy': ' Data Policy ',
          'and': 'and',
          'cookie_policy': ' Cookie Policy',
          'receive_sms':
              '. You may receive SMS notifications from us and can opt out at any time',
          'dob': 'Date of Birth',
          'post_ad': 'Post Ad',
          'home': 'Home',
          'you': 'You',
          'location': 'Location',
          'liked_by': 'Liked by',
          'others': 'others',
          'Add_a_comment': 'Add a comment',
          'Image': 'Image',
          'Text': 'Text',
          'Video': 'Video',
          'Audio': 'Audio',
          'Gif_embed': 'Gif',
          'Capture_from_camera': 'Capture from camera',
          'Load_from_media': 'Load from media',
          'Record_from_camera': 'Record from camera',
          'No_file_selected': 'No file selected',
          'Upload_Image': 'Upload Image',
          'Next': 'Next',
          'Caption': 'Caption',
          'Publish': 'Publish',
          'Cannot_be_empty': 'Cannot be empty',
          'Add_post_caption,_#hashtag_or_@mention': 'Add post caption, #hashtag or @mention',
          'Please_select_files_before_you_proceed': 'Please select files before you proceed',
          'Please_select_a_GIF_first': 'Please select a GIF first',
          'Posts': 'Posts',
          'Reels': 'Reels',
          'Texts': 'Texts',
          'Followers': 'Followers',
          'Following': 'Following',
          'Follow': 'Follow',
          'Message': 'Message',
          'Edit_Profile': 'Edit Profile',
          'Edit_Your_Profile': 'Edit Your Profile',
          'Change_your_profile_image': 'Change your profile image',
          'Full_Name': 'Full Name',
          'Please_enter_your_name': 'Please enter your name',
          'Username': 'Username',
          'Please_enter_your_username': 'Please enter your username',
          'Username_should_be_more_3_characters_long': 'Username should be more 3 characters long',
          'Bio': 'Bio',
          'Please_enter_your_bio': 'Please enter your bio...',
          'Website': 'Website',
          'Save': 'Save',
          '': '',
          '': '',
          '': '',
          '': '',
          '': '',
          '': '',
        },

        // ARABIC (IQ)
        'ar_IQ': {
          'change_language': 'تغيير اللغة',
          'welcome_back': 'مرحبًا بعودتك',
          'mobile_number': "رقم الهاتف المحمول",
          'mobile_error_text': "يرجى تقديم رقم هاتفك المحمول",
          'password': 'كلمة المرور',
          'required': 'مطلوب',
          'password_error_text_1': 'كلمة المرور مطلوبة',
          'password_error_text_2':
              'يجب أن تتكون كلمة المرور من ٨ أحرف على الأقل',
          'keep_logged_in': 'أبقني متصل',
          'login': 'تسجيل الدخول',
          'forgot_password': 'هل نسيت كلمة السر؟',
          'or_continue_with': 'أو تواصل مع',
          'dont_have_an_account': 'ليس لديك حساب؟',
          'signup': ' اشتراك',
          'phone_number': 'رقم الهاتف',
          'invalid_number': 'رقم غير صالح',
          'search_country': 'ابحث في بلدك',
          'email': 'البريد الإلكتروني',
          'please_provide_email': 'يرجى تقديم بريدك الإلكتروني',
          'invalid_email': 'بريد إلكتروني خاطئ',
          'sign_in': 'تسجيل الدخول',
          'sign_in_low': 'تسجيل الدخول ',
          'forgot_password_title': 'هل نسيت كلمة السر',
          'forgot_password_subtitle':
              'أدخل بريدك الإلكتروني أو هاتفك أدناه لإعادة تعيين كلمة المرور الخاصة بك',
          'mobile': 'التليفون المحمول',
          'send_otp': 'أرسل OTP',
          'enter_four_digit_code': 'أدخل الرمز المكون من ٤ أرقام',
          'enter_four_digit_code_email':
              'أدخل الرمز المكون من ٤ أرقام الذي تلقيته على بريدك الإلكتروني.',
          'continue': 'يكمل',
          'reset_password': 'إعادة تعيين كلمة المرور',
          'set_new_password':
              'قم بتعيين كلمة المرور الجديدة لحسابك حتى تتمكن من تسجيل الدخول',
          'confirm_password': 'تأكيد كلمة المرور',
          'password_doesnt_match': 'كلمات المرور غير متطابقة',
          'full_name': 'الاسم الكامل',
          'please_provider_full_name': 'يرجى تقديم اسمك الكامل',
          'gender': 'جنس',
          'male': 'ذكر',
          'female': 'أنثى',
          'or_register_via': 'أو سجل عبر',
          'already_have_an_account': 'هل لديك حساب؟',
          'by_clicking_sign_up': 'بالنقر فوق تسجيل ، فإنك توافق على',
          'terms': ' شروط،',
          'data_policy': ' سياسة البيانات ',
          'and': 'و',
          'cookie_policy': ' سياسة ملفات الارتباط',
          'receive_sms':
              '. قد تتلقى إشعارات عبر الرسائل القصيرة منا ويمكنك إلغاء الاشتراك في أي وقت',
          'dob': 'تاريخ الولادة',
          'post_ad': 'إعلان آخر',
          'home': 'مسكن',
          'you': 'أنت',
          'location': 'موقعك',
          'liked_by': 'اعجب به',
          'others': 'الآخرين',
          'Add_a_comment': 'اضف تعليق',
          'Image': 'صورة',
          'Text': 'نص',
          'Video': 'فيديو',
          'Audio': 'صوتي',
          'Gif_embed': 'GIF',
          'Capture_from_camera': 'التقط من الكاميرا',
          'Load_from_media': 'تحميل من وسائل الإعلام',
          'Record_from_camera': 'سجل من الكاميرا',
          'No_file_selected': 'لم يتم اختيار اي ملف',
          'Upload_Image': 'تحميل الصور',
          'Next': 'التالي',
          'Caption': 'شرح',
          'Publish': 'ينشر',
          'Cannot_be_empty': 'لايمكن ان يكون فارغا',
          'Add_post_caption,_#hashtag_or_@mention': 'أضف تعليقًا للنشر أو #الوسم أو @أشير',
          'Please_select_files_before_you_proceed': 'الرجاء تحديد الملفات قبل المتابعة',
          'Please_select_a_GIF_first': 'الرجاء تحديد صورة GIF أولاً',
          'Posts': 'المشاركات',
          'Reels': 'بكرات',
          'Texts': 'نصوص',
          'Followers': 'متابعون',
          'Following': 'التالية',
          'Follow': 'يتبع',
          'Message': 'رسالة',
          'Edit_Profile': 'تعديل الملف الشخصي',
          'Edit_Your_Profile': 'عدل ملفك الشخصي',
          'Change_your_profile_image': 'تغيير صورة ملف التعريف الخاص بك',
          'Full_Name': 'الاسم الكامل',
          'Please_enter_your_name': 'من فضلك أدخل إسمك',
          'Username': 'اسم المستخدم',
          'Please_enter_your_username': 'الرجاء إدخال اسم المستخدم',
          'Username_should_be_more_3_characters_long': 'يجب أن يكون اسم المستخدم أكثر من 3 أحرف',
          'Bio': 'السيرة الذاتية',
          'Please_enter_your_bio': 'الرجاء إدخال سيرتك الذاتية...',
          'Website': 'موقع الكتروني',
          'Save': 'يحفظ',
          '': '',
          '': '',
          '': '',
          '': '',
          '': '',
          '': '',
        },
      };

  static const List<Locale> supportedLocales = [
    Locale("af"),
    Locale("am"),
    Locale("ar"),
    Locale("az"),
    Locale("be"),
    Locale("bg"),
    Locale("bn"),
    Locale("bs"),
    Locale("ca"),
    Locale("cs"),
    Locale("da"),
    Locale("de"),
    Locale("el"),
    Locale("en"),
    Locale("es"),
    Locale("et"),
    Locale("fa"),
    Locale("fi"),
    Locale("fr"),
    Locale("gl"),
    Locale("ha"),
    Locale("he"),
    Locale("hi"),
    Locale("hr"),
    Locale("hu"),
    Locale("hy"),
    Locale("id"),
    Locale("is"),
    Locale("it"),
    Locale("ja"),
    Locale("ka"),
    Locale("kk"),
    Locale("km"),
    Locale("ko"),
    Locale("ku"),
    Locale("ky"),
    Locale("lt"),
    Locale("lv"),
    Locale("mk"),
    Locale("ml"),
    Locale("mn"),
    Locale("ms"),
    Locale("nb"),
    Locale("nl"),
    Locale("nn"),
    Locale("no"),
    Locale("pl"),
    Locale("ps"),
    Locale("pt"),
    Locale("ro"),
    Locale("ru"),
    Locale("sd"),
    Locale("sk"),
    Locale("sl"),
    Locale("so"),
    Locale("sq"),
    Locale("sr"),
    Locale("sv"),
    Locale("ta"),
    Locale("tg"),
    Locale("th"),
    Locale("tk"),
    Locale("tr"),
    Locale("tt"),
    Locale("uk"),
    Locale("ug"),
    Locale("ur"),
    Locale("uz"),
    Locale("vi"),
    Locale("zh")
  ];

  // static const List localizationsDelegates = [
  //   GlobalMaterialLocalizations.delegate,
  //   GlobalWidgetsLocalizations.delegate,
  //   GlobalCupertinoLocalizations.delegate,
  // ];
}
