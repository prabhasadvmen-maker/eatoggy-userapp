import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xff11110f);
  static const Color surface = Color(0xff191714);
  static const Color primaryGold = Color(0xFFD9A24F);
  static const Color lightGold = Color(0xFFF1CC8A);
  static const Color primaryText = Color(0xfffff1d2);
  static const Color secondaryText = Color(0xffb8b4ae);
  static const Color muted = Color(0xff77736d);
  static const Color success = Color(0xff22c55e);
  static const Color error = Color(0xffd9534f);

  // Gradient definitions
  static const LinearGradient goldGradient = LinearGradient(
    colors: [primaryGold, lightGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [surface, background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}



// jkglkdjgl