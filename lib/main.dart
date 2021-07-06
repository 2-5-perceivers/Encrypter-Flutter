import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'package:encrypter/utilities/themes.dart';

import 'package:encrypter/pages/aboutPage.dart';
import 'package:encrypter/home.dart';

void main() => runApp(Encrypter());

class Encrypter extends StatelessWidget {
  const Encrypter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    final isPlatformDark =
        WidgetsBinding.instance!.window.platformBrightness == Brightness.dark;
    final initTheme = isPlatformDark ? darkTheme : lightTheme;
    return ThemeProvider(
      initTheme: initTheme,
      builder: (_, myTheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Encrypter",
          theme: myTheme,
          initialRoute: '/home',
          routes: {
            '/home': (context) => Home(),
            '/about': (context) => AboutPage()
          },
        );
      },
    );
  }
}
