import 'package:flutter/material.dart';

class AppColors {
  static const pureWhiteColor = Color(0xffffffff);
  static const purpleColor = Color(0xff7C4DFF);
  static const darkPurpleColor = Color(0xff6240C0);
  static const darkGrayTextL = Color.fromARGB(255, 167, 167, 167);
  static const darkGrayTextH = Color(0xff262626);
  static const pureBlack = Color(0xff000000);
  static const lightLineColor = Color.fromARGB(255, 224, 224, 224);
  static const darkLineColor = Color(0xff5D5D5D);
  static const lightGrayTxtColor = Color(0xff5E5D5D);
  static const appBarColor = Color(0xffF8F8F8);

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
      Color(0xFF3897F0),
      Color(0xFF3897F0).withOpacity(0.7),
      Color(0xFFF65421),
    ],
    begin: FractionalOffset.centerLeft,
    end: FractionalOffset.centerRight,
  );
}
