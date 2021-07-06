import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:encrypter/widgets/drawer.dart';
import 'package:encrypter/widgets/appBar.dart';

const _url = 'https://github.com/2-5-perceivers';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late IconData themeIconController;

  @override
  Widget build(BuildContext context) {
    themeIconController =
        ThemeProvider.of(context)!.brightness == Brightness.light
            ? Icons.brightness_4
            : Icons.brightness_7;
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: MainAppBar(context, themeIconController, "About"),
        drawer: MainDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await launch(_url);
          },
          child: Icon(Icons.messenger_outline),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(30),
            margin: EdgeInsets.all(30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 3)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Encrypter",
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .apply(fontSizeFactor: 0.9),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Flutter version of Encrypter, a simple encryption method similar with AES",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline2!.color,
                    fontWeight: FontWeight.w200,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Made by 2.5 perceivers\nPublished by Adorkw",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline2!.color,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
