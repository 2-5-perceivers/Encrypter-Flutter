import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'package:encrypter/utilities/themes.dart';

// ignore: non_constant_identifier_names
PreferredSizeWidget? MainAppBar(context, themeIconController, String title) {
  return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      elevation: 0,
      actions: [
        ThemeSwitcher(
          builder: (context) {
            return IconButton(
              onPressed: () {
                ThemeSwitcher.of(context)!.changeTheme(
                  theme:
                      ThemeProvider.of(context)!.brightness == Brightness.light
                          ? darkTheme
                          : lightTheme,
                );
              },
              icon: Icon(themeIconController),
            );
          },
        )
      ]);
}
