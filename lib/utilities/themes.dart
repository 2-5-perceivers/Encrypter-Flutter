import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  //Dark theme
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple[300],
  accentColor: Colors.green[300],
  errorColor: Colors.red[300],
);

ThemeData lightTheme = ThemeData(
  //Light theme
  brightness: Brightness.light,
  primaryColor: Colors.deepPurple[800],
  accentColor: Colors.green[400],
  textTheme: const TextTheme(
    headline2: TextStyle(
      color: Color.fromRGBO(55, 55, 55, 1.0),
    ),
  ),
);
