import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'package:encrypter/widgets/drawer.dart';
import 'package:encrypter/widgets/app_bar.dart';
import 'package:encrypter/widgets/key_choser_spinner.dart';

class FilesEncryptPage extends StatefulWidget {
  const FilesEncryptPage({Key? key}) : super(key: key);

  @override
  _FilesEncryptPageState createState() => _FilesEncryptPageState();
}

class _FilesEncryptPageState extends State<FilesEncryptPage> {
  /// Variable used to keep the actual icon for the theme changer
  late IconData themeIconController;

  /// Key for accesing the dropdown's state
  final GlobalKey<KeysSpinnerState> _dropDownKey = GlobalKey();

  /// Style used by the action buttons on this page
  late ButtonStyle buttonStyle;

  String selectetFileString = ' ';

  @override
  Widget build(BuildContext context) {
    // Sets the icon controller depending on current brightness
    themeIconController =
        ThemeProvider.of(context)!.brightness == Brightness.light
            ? Icons.brightness_4
            : Icons.brightness_7;

    buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith(
        (s) {
          return Theme.of(context).primaryColor;
        },
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    return ThemeSwitchingArea(
        child: Scaffold(
      appBar: MainAppBar(context, themeIconController, "Encrypt files"),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 20.0,
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).accentColor),
                        ),
                        onPressed: () {
                          /* TODO: implement file selecting and validating after Google finishes implementing file_selector*/
                        },
                        child: const Text("Select file"),
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      Text("Selected file: $selectetFileString")
                    ],
                  ),
                )),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    // Label for drop down button
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      "Key",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  KeysSpinner(key: _dropDownKey),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(
                            () {
                              _dropDownKey.currentState!.validate();
                            },
                          );
                        },
                        child: Text("Encrypt".toUpperCase()),
                        style: buttonStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(
                            () {
                              _dropDownKey.currentState!.validate();
                            },
                          );
                        },
                        child: Text("Decrypt".toUpperCase()),
                        style: buttonStyle,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
