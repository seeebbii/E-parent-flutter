import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color green = Colors.green;
  static const Color lightGreen = Color(0xFF9FFF99);
  static const Color red = Colors.red;
  static const Color lightRed = Color(0xFFEE9281);
  static const Color orange = Colors.deepOrange;
  static const Color blue = Color(0xFF6C63FF);
  static const Color lightBlue = Color(0xFF81B6EE);
  static const Color lightPurple = Color(0xFF6E85B6);
  static const Color darkPurple = Color(0xFF370BAC);
  static const Color yellow = Colors.yellow;
  static const Color lightYellow = Color(0xFFEEE981);
  static const Color black = Colors.black;

  static const Color lightLineColor = Color.fromARGB(255, 224, 224, 224);

  static Color appColor = const Color(0xFFCCFF01);
  static Color appBGColor = const Color(0xFF353535);
  static Color firstTop = const Color(0xFF0056A6);
  static Color firstBottom = const Color(0xFF0C81B4);
  static Color secondTop = const Color(0xFF7FC53A);
  static Color secondBottom = const Color(0xFF6CA116);
  static Color thirdTop = const Color(0xFFFF7043);
  static Color thirdBottom = const Color(0xFFFA3E03);
  static Color fourthTop = const Color(0xFFF254CF);
  static Color fourthBottom = const Color(0xFFC811A0);
  static Color orderPriceBorder = const Color(0xFF8EB103);
  static Color orderPriceBG = const Color(0xFF98F500);
  static Color dialogBG = const Color(0xFFECFFA1);
  static Color appBackgroundColor = Colors.grey.shade200;

  static const Color darkBackgroundColor = Color(0xFF181C1E);
  static const Color lightGray = Color(0xFFE1E1E1);
  static const Color lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color lightComponentsColor = Color(0xFF40CAFF);
  static const Color lightCardColor = Color(0xFFF4F8FA);

  static const Color errorColor = Color(0xFFD60000);
  static const Color btnColor = Color(0xFFFF9900);
  static const Color lightTextColor = Color(0xFFF4F8FA);
  static const Color fieldTextColor = Color(0xFFF2F2F2);
  static const Color dotTextColor = Color(0xFF707070);
  static const Color darkTextColor = Color(0xFF181C1E);
  static const Color boxShadowColor = Color(0x1F000000);
  static const Color splashColor = Color(0x1F000000);
  static const Color splashScreenBgColor = Color(0xFFF37D71);
  static const Color graphColorPurple = Color(0xFFC855CB);
  static const Color graphColorOrange = Color(0xFFFF9900);

  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF1F1F1F);
  static Color fieldOutlineColor = Colors.grey.shade200;
  static const Color searchHintColor = Color(0xFF888888);
  static const Color textFieldFillColor = Color(0xFFFBFBFB);
  static const Color buyNowButtonColor = Color(0xFFD1F3DD);
  static const Color hintColor = Color(0xFF959595);
  static const Color textFieldUnderline = Color(0xFFDFDFDF);
  static const Color postBodyBackgroundColor = Color(0xFFF5F5F5);
  static const Color homeScreenHorizontalListviewBg = Color(0xFF353536);
  static const Color unSelectedCategoryColor = Color(0xFF4A4A4B);
  static const Color dividerColor = Color(0xFF000000);
  static const Color darkDividerColor = Color(0xFFD9D9D9);

  static const Color animalsContainerColor = Color(0xFFD0D6FF);
  static const Color animalsBorderColor = Color(0xFF475BE4);
  static const Color foodContainerColor = Color(0xFFFFE1BD);
  static const Color foodBorderColor = Color(0xFFDC9949);
  static const Color accessoriesContainerColor = Color(0xFFA6F6E8);
  static const Color accessoriesBorderColor = Color(0xFF3B9686);

  static const Color screenBackgroundColor = Color(0xFFF5F5F5);
  static const Color bottomNavBarBackground = Color(0xFFFFFFFF);
  static const Color selectedNavBarItemColor = Color(0xFFB59E5C);
  static const Color appointmentsCardColor = Color(0xFFE4F2FF);

  // static const Color primaryColor = Color(0xFF7C4DFF);
  // static const Color primaryColor = Color(0xFF111344);
  // static const Color primaryColor = Color(0xFF304675);
  static const Color primaryColor = Color(0xFFF37D71);
  // static const Color darkPrimaryColor = Color(0xFF4A9CE2);
  static const Color darkPrimaryColor = Color(0xFF111344);

  static LinearGradient primaryColorGradient = const LinearGradient(
    colors: [
      Color(0xFFEA4C46),
      Color(0xFFF07470),
    ],
    begin: FractionalOffset.centerLeft,
    end: FractionalOffset.centerRight,
  );

  static const Color subtitleLightGreyColor = Color(0xFF8391A1);
  static const Color shadowColorHomePage = Color(0xFF000000);
  static const Color unselectedItemColor = Color(0xFF777777);
  static const Color noImageColor = Color(0xFFD9D9D9);
  static const Color viewsContainerColor = Color(0xFFFFF9EF);
  static const Color imageCountContainerColor = Color(0xFF414141);
  static const Color containerBackgroundColor = Color.fromRGBO(0, 0, 0, 0.08);
  static const Color statusTextColor = Color(0xFFB8B5B5);

  static const Color approveNotificationColor = Color(0xFF27D94E);
  static const Color successColor = Color(0xFF24DF4D);

  static const Color declineNotificationColor = Color(0xFFFF4A3F);
  static const Color cancelledAppointment = Color(0xFFD73A49);
  static const Color profileListTileColor = Color(0xFFE4EFF6);

  static const Color selectedNavBarBackgroundColor = Color(0xFF282828);
  static const Color selectedYellowColor = Color(0xFFFFCB74);
  static const Color reviewStarColor = Color(0xFFFFC107);
  static const Color reviewPostColor = Color(0xFF0085E3);

  static const Color unSelectedNavBarItemColor = Color(0xFF979797);

  static SweepGradient storyContainerGradient = const SweepGradient(
    colors: [
      Color(0xFF0F9DA6),
      Color(0xFF1AD94F),
      Color(0xFFF4921A),
      Color(0xFF0F9DA6),
      Color(0xFFF4921A),
    ],
  );

  static LinearGradient liveContainerGradient = LinearGradient(
    colors: [
      const Color(0xFF3897F0),
      const Color(0xFF3897F0).withOpacity(0.7),
      const Color(0xFFF65421),
    ],
    begin: FractionalOffset.centerLeft,
    end: FractionalOffset.centerRight,
  );

  static LinearGradient homeContainerGradient = const LinearGradient(
    colors: [
      Color(0xFFABFFEC),
      Color(0xFF7080B8),
    ],
    begin: FractionalOffset.centerLeft,
    end: FractionalOffset.centerRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      // useMaterial3: true,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        displayMedium: TextStyle(
          fontSize: 23.sp,
          color: blackColor,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
            fontSize: 17.sp, color: blackColor, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(
          fontSize: 14.sp,
          color: blackColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 12.sp,
          color: blackColor,
        ),
      ),
      primaryColor: lightBackgroundColor,
      scaffoldBackgroundColor: lightBackgroundColor,
      primaryColorLight: const Color(0xFFF1F1F1),
      splashColor: splashColor,
      brightness: Brightness.light,
      highlightColor: splashColor,
      focusColor: primaryColor,
      iconTheme: const IconThemeData(color: Colors.black),
      fontFamily: GoogleFonts.lato().fontFamily,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: bottomNavBarBackground, elevation: 3),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          color: hintColor,
          fontSize: 12,
        ),
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: primaryColor,
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: primaryColor), colorScheme: ColorScheme.fromSwatch()
          .copyWith(
            secondary: const Color(0xFF79A6DC),
            brightness: Brightness.light,
          )
          .copyWith(secondary: primaryColor)
          .copyWith(secondary: primaryColor).copyWith(background: lightBackgroundColor).copyWith(error: errorColor),
    );
  }
}

extension MyThemeData on ThemeData {
  bool get isDarkTheme => brightness == Brightness.dark;

  bool get isLightTheme => brightness == Brightness.light;
}
