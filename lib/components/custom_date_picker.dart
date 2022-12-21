import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, DateTime? maxTime, DateTime? minTime, LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    print(currentTime);
    setLeftIndex(this.currentTime.day);
    setMiddleIndex(this.currentTime.month);
    setRightIndex(this.currentTime.year);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < DateTime.now().day) {
      return digits(index+1, 1);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 12) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < DateTime.now().year) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return " ";
  }

  @override
  String rightDivider() {
    return " ";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        currentLeftIndex(),
        currentMiddleIndex(),
        currentRightIndex());
  }
}