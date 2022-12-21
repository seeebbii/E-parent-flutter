import 'package:flutter/material.dart';

extension ExtensionWidgets on Widget {
  Widget center() {
    return Center(
      child: this,
    );
  }

  Widget padding(double height, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.02, horizontal: width * 0.06),
      child: this,
    );
  }
}

extension StringCasingExtension on String {
  String firstCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.firstCapitalized()).join(' ');
}
