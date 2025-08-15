import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'themes.dart';

// class AppTheme {
//   static ThemeData LightTheme(String name) {
//     switch(name) {
//       case 'Default':
//         return FlexThemeData.light(
//           colorScheme: defaultLightScheme,
//           useMaterial3: true,
//         );
//     }
//   }
// }

class AppTheme {
  static ThemeData fromName(String name) {
    switch (name) {
      case 'Default':
        return FlexThemeData.light(
          colorScheme: defaultLightScheme,
          useMaterial3: true,
        );
      // ... other themes
      default:
        return FlexThemeData.light(
          colorScheme: defaultLightScheme,
          useMaterial3: true,
        );
    }
  }

  static ThemeData fromNameDark(String name) {
    switch (name) {
      case 'Default':
        return FlexThemeData.dark(
          colorScheme: defaultDarkScheme,
          useMaterial3: true,
        );
      // ... other themes
      default:
        return FlexThemeData.dark(
          colorScheme: defaultDarkScheme,
          useMaterial3: true,
        );
    }
  }
}