import 'dart:ui';
import 'package:flutter/material.dart';

class AppColors {
  static const Color appPrimaryColor = Color.fromARGB(255, 251, 190, 48);
  static const LinearGradient appPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
    colors: [
      Color(0xFFFFB508),
      Color(0xFFF6D365),
    ],
  );
  static const Color alertColor = Color(0xFFE88D0E);
  static const Color appSecondaryColor = Color(0xFFFFE4A4);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color headerColor = Color(0xFF504F4B);
  static const Color black = Color(0xFF000000);
  static const Color textFieldBorderColor = Color(0xFFE7E7E7);
  static const Color textColor = Color(0xFF25221D);
  static const Color textFieldBg = Color.fromARGB(255, 252, 252, 251);
  static const Color bottomColorBg = Color(0xFFF9F9F8);
  static const Color bottomTabInactiveColor = Color(0xFF474642);
  static const Color borderColor = Color(0xFFC4C5C1);
  static const Color textGrey = Color(0xFF8C8C8C);
  static const Color rewardsText = Color(0xFF828282);
  static const Color textBlue = Color(0xFF2164B2);
  static const Color textGreen = Color(0xFF3A6431);
}
