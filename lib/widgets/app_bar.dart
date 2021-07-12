import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'package:encrypter/utilities/themes.dart';

// ignore: non_constant_identifier_names
PreferredSizeWidget? MainAppBar(context, themeIconController, String title,
    {addBackButtonToHome = false}) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(color: Theme.of(context).primaryColor),
    ),
    leading: addBackButtonToHome
        ? BackButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          )
        : null,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
    elevation: 0,
    actions: [
      ThemeSwitcher(
        builder: (context) {
          return IconButton(
            tooltip: "Change theme",
            onPressed: () {
              ThemeSwitcher.of(context)!.changeTheme(
                theme: ThemeProvider.of(context)!.brightness == Brightness.light
                    ? darkTheme
                    : lightTheme,
              );
            },
            icon: Icon(themeIconController),
          );
        },
      )
    ],
  );
}
