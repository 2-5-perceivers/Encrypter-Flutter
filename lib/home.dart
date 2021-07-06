import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'package:encrypter/widgets/drawer.dart';
import 'package:encrypter/widgets/appBar.dart';
import 'package:encrypter/widgets/addKeyActionSheet.dart';
import 'package:encrypter/utilities/sharedPreferencesKeys.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late IconData
      themeIconController; //variable used to keep the actual icon for the theme changer

  List<String> keys = [];
  String selectedKey = '';

  final inpTextController = TextEditingController();
  final outTextController = TextEditingController();

  bool textInputError = false;
  bool keySelectError = false;

  bool validText(String text) {
    //Returns true if is valid
    return text.isNotEmpty;
  }

  late ButtonStyle buttonStyle;

  @override
  Widget build(BuildContext context) {
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

    _prefs.then((prefs) {
      keys = List<String>.from(
          json.decode(prefs.getString(keysArrayPrefsKey) ?? '[]'));
      selectedKey = keys.length > 0
          ? keys.first
          : ''; //Sets the  selected value to the first key available or to an empty character
      setState(() {});
    });

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
                padding: const EdgeInsets.all(6),
                child: Text(
                  "Key",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Theme.of(context).accentColor,
                  buttonTheme: Theme.of(context).buttonTheme.copyWith(
                        alignedDropdown: true,
                      ),
                ),
                child: DropdownButton<String>(
                  value: selectedKey == ''
                      ? null
                      : selectedKey, //Defaults to nothing if there are no keys
                  items: keys.map((String value) {
                        return DropdownMenuItem(
                          child: ListTile(
                            title: Text(value),
                          ),
                          value: value,
                        );
                      }).toList() +
                      [
                        DropdownMenuItem(
                          value: null,
                          child: ListTile(
                            leading: Icon(Icons.add),
                            title: Text("Add new key"),
                            onTap: () {
                              Navigator.pop(context); //This closes the dropdown
                              showModalBottomSheet(
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                ),
                                context: context,
                                builder: (context) {
                                  return AddKeyActionSheet(
                                    listKeys: keys,
                                    parentSetter: () {
                                      setState(() {
                                        selectedKey = keys.last;
                                      });
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        )
                      ],
                  isExpanded: true,
                  underline: Container(
                    height: 2,
                    //Selects between the primaryColor, accentColor and the errorColor depending
                    //on the theme in order to match the text fields around it or on the state
                    color: keySelectError
                        ? Theme.of(context).errorColor
                        : (ThemeProvider.of(context)!.brightness ==
                                Brightness.light
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).accentColor),
                  ),
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                  itemHeight: 70,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedKey = newValue!;
                      keySelectError = selectedKey == '';
                    });
                  },
                ),
              ),
              Expanded(
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
                                    keySelectError = selectedKey == '';
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
                                    keySelectError = selectedKey == '';
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

  @override
  void dispose() {
    inpTextController.dispose();
    outTextController.dispose();
    super.dispose();
  }
}
