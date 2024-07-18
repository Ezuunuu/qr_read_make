import 'package:flutter/material.dart';

ThemeData initThemeData({required Brightness brightness}) {
  if (brightness == Brightness.light) {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        background: Color(0xFF1A2926),
        primary: Colors.redAccent, // 주요 색상
        secondary: Colors.orange, // 보조 색상
      ),
    );
  } else {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF1A2926),
        primary: Colors.blueAccent, // 주요 색상
        secondary: Colors.greenAccent, // 보조 색상
      ),
    );
  }
}