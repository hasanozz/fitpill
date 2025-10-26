import 'package:flutter/material.dart';

const colorPrimary = Colors.deepOrangeAccent;
const colorAccent = Colors.orange;

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: colorPrimary,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorAccent
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 40.0,vertical: 20.0)
            ),
            shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0))
            ),
            backgroundColor: WidgetStateProperty.all<Color>(colorAccent)
        )
    ),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),borderSide: BorderSide.none
        ),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.1)
    )
);

ThemeData darkTheme = ThemeData(

  brightness: Brightness.dark,
  hintColor: Colors.white,
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateProperty.all<Color>(Colors.grey),
    thumbColor: WidgetStateProperty.all<Color>(Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),borderSide: BorderSide.none
      ),
      filled: true,
      fillColor: Colors.grey.withValues(alpha: 0.1)
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 40.0,vertical: 20.0)
          ),
          shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
              )
          ),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
          overlayColor: WidgetStateProperty.all<Color>(Colors.black26)
      )
  ),
);