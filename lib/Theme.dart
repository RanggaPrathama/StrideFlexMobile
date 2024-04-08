import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      useMaterial3: true,
      fontFamily: MyFont.primaryFont,
      appBarTheme: const AppBarTheme(
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black)),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black),
      ),
      // inputDecorationTheme: const InputDecorationTheme(
      //   floatingLabelBehavior: FloatingLabelBehavior.always,
      //   contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      //   // enabledBorder: outlineInputBorder,
      //   // focusedBorder: outlineInputBorder,
      //   // border: outlineInputBorder,
      // ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: MyColor.primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
    );
  }
}

// const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
//   borderRadius: BorderRadius.all(Radius.circular(28)),
//   borderSide: BorderSide(color: kTextColor),
//   gapPadding: 10,
// );

const headingText = TextStyle(
  color: Colors.black,
  fontSize: 24,
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
);

const judul = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

const paragraf = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

final headingAuth = TextStyle(
    fontSize: 20, color: Colors.grey.shade600, fontWeight: FontWeight.bold);

final textkecil = TextStyle(
    fontSize: 15, color: Colors.grey.shade600, fontWeight: FontWeight.bold);

class MyColor {
  static Color primaryColor = Colors.blue.shade700;
  static Color secondaryColor = Colors.blue.shade500;
  static Color ternaryColor = Colors.grey.shade600;
  static Color textAreaColor = Colors.grey.shade600;
}

class MyFont {
  static String primaryFont = 'Poppins';
  static String secondaryFont = 'Quicksand';
}
