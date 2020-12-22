import 'package:flutter/material.dart';

class BaseTheme {
  static final ThemeData baseTheme = ThemeData(
    primaryColor: Colors.deepOrange[400],
    accentColor: Colors.amber[400],
    // buttonColor: Colors.deepOrange[400],
    elevatedButtonTheme: ElevatedButtonThemeData(style: _elevatedButtonStyle),
    floatingActionButtonTheme: _floatingActionButtonThemeData,
    textSelectionTheme: _textSelectionThemeData,
  );

  static final ButtonStyle _elevatedButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.deepOrange[400],
    onPrimary: Colors.black,
    elevation: 20.0,
  );

  static final FloatingActionButtonThemeData _floatingActionButtonThemeData = FloatingActionButtonThemeData(
    foregroundColor: Colors.deepOrange[600],
  );

  static final TextSelectionThemeData _textSelectionThemeData = TextSelectionThemeData(
    cursorColor: Colors.deepOrange[400],
    selectionColor: Colors.amber[300],
    selectionHandleColor: Colors.amber[300]
  );

}
