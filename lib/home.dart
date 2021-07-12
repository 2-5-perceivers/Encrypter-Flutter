import 'package:flutter/material.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'package:encrypter/widgets/drawer.dart';
import 'package:encrypter/widgets/appBar.dart';
import 'package:encrypter/widgets/keyChoserSpinner.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late IconData
      themeIconController; //variable used to keep the actual icon for the theme changer

  final inpTextController = TextEditingController();
  final outTextController = TextEditingController();

  bool textInputError = false;

  /// Style used by the action buttons on this page
  late ButtonStyle buttonStyle;

  GlobalKey<KeysSpinnerState> _dropDownKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Sets the icon controller depending on current brightness
    themeIconController =
        ThemeProvider.of(context)!.brightness == Brightness.light
            ? Icons.brightness_4
            : Icons.brightness_7;

    buttonStyle = ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) {
          return Theme.of(context).primaryColor;
        }),
        textStyle: MaterialStateProperty.all(TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        )));

    return ThemeSwitchingArea(
      child: Scaffold(
        resizeToAvoidBottomInset:
            false, //This prevents the damn keyboard compressing the screen making my lovely buttons look like shit
        appBar: MainAppBar(context, themeIconController, "Encrypter"),
        drawer: MainDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                // Input text
                flex: 4,
                child: TextField(
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: inpTextController,
                  onChanged: (value) {
                    setState(() {
                      textInputError = !validText(value);
                    });
                  },
                  decoration: InputDecoration(
                      labelText: "Input text",
                      fillColor: Theme.of(context).hoverColor,
                      filled: true,
                      errorText: textInputError ? "Please enter text" : null),
                ),
              ),
              Padding(
                // Label for drop down button
                padding: const EdgeInsets.all(6),
                child: Text(
                  "Key",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              KeysSpinner(),
              Expanded(
                // Output text
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: TextField(
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    readOnly: true,
                    controller: outTextController,
                    decoration: InputDecoration(
                      labelText: "Output",
                      fillColor: Theme.of(context).hoverColor,
                      filled: true,
                    ),
                  ),
                ),
              ),
              Expanded(
                // Buttons
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text("Copy Text".toUpperCase()),
                          style: buttonStyle.copyWith(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Theme.of(context).accentColor),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    textInputError =
                                        !validText(inpTextController.text);
                                    _dropDownKey.currentState!.validate();
                                  });
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
                                  setState(() {
                                    textInputError =
                                        !validText(inpTextController.text);
                                    _dropDownKey.currentState!.validate();
                                  });
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
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Returns true if is valid
  bool validText(String text) {
    return text.isNotEmpty;
  }

  @override
  void dispose() {
    inpTextController.dispose();
    outTextController.dispose();
    super.dispose();
  }
}
