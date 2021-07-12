import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'package:encrypter/widgets/add_key_action_sheet.dart';

import 'package:encrypter/utilities/shared_preferences_keys.dart';

class KeysSpinner extends StatefulWidget {
  const KeysSpinner({required Key? key}) : super(key: key);

  @override
  KeysSpinnerState createState() => KeysSpinnerState();
}

class KeysSpinnerState extends State<KeysSpinner> {
  final Future<SharedPreferences> _prefsFuture =
      SharedPreferences.getInstance();

  ///This is where the saved encryption keys are loaded
  List<String> _keys = ["Loading keys"];
  String _selectedKey = 'Loading keys';

  ///Used for keeping the input error state
  bool keySelectError = false;

  @override
  void initState() {
    super.initState();
    // When shared preferences are loaded it decodes the saved JSON
    _prefsFuture.then(
      (prefs) {
        _keys = List<String>.from(
          json.decode(
            prefs.getString(keysArrayPrefsKey) ?? '[]',
          ),
        );

        //Sets the  selected value to the first key available or to an empty character
        _selectedKey = _keys.isNotEmpty ? _keys.first : '';
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Drop down for encryption key selection
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).accentColor,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              alignedDropdown: true,
            ),
      ),
      child: DropdownButton<String>(
        value: _selectedKey != ''
            ? _selectedKey //Defaults to nothing if there are no keys
            : null,
        onChanged: (String? newValue) {
          setState(
            () {
              _selectedKey = newValue!;
              keySelectError = _selectedKey == '';
            },
          );
        },
        items: _keys.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: GestureDetector(
                  onSecondaryTap: () {
                    _onOpenRemoveSheet(value);
                  },
                  onLongPress: () {
                    _onOpenRemoveSheet(value);
                  },
                  child: ListTile(
                    title: Text(value),
                  ),
                ),
              );
            }).toList() +
            [
              DropdownMenuItem(
                value: null,
                child: ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text("Add new key"),
                  onTap: () {
                    Navigator.pop(context); //This closes the dropdown
                    showModalBottomSheet(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return AddKeyActionSheet(
                          list: _keys,
                          parentSetter: _newKeySetState,
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
              : (ThemeProvider.of(context)!.brightness == Brightness.light
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor),
        ),
        style: const TextStyle(
          fontSize: 16.0,
        ),
        itemHeight: 70,
      ),
    );
  }

  ///Validates input
  void validate() {
    setState(() {
      keySelectError = _selectedKey == '';
    });
  }

  ///Opens an action sheet used for removing keys
  void _onOpenRemoveSheet(
    String value,
  ) {
    // This closes the dropDown if it's open
    if (Navigator.canPop(context)) Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      _keys.remove(value);
                      await SharedPreferences.getInstance().then((prefs) {
                        prefs
                            .setString(keysArrayPrefsKey, json.encode(_keys))
                            .then(
                          (s) {
                            _newKeySetState();
                          },
                        );
                      });
                    },
                    tileColor: Theme.of(context).accentColor,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: Text(
                        "Delete key",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    tileColor: Theme.of(context).errorColor,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: Text(
                        "Cancel",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// To be passed to to widgets that change the array
  void _newKeySetState() {
    setState(() {
      _selectedKey = _keys.isEmpty ? '' : _keys.last;
    });
  }
}
