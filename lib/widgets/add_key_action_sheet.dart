import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:encrypter/utilities/shared_preferences_keys.dart';

/// Enum type for error types in key input text field
enum _inputError {
  empty,
  badLenght,
  notBasicCharacters,
  none,
}

class AddKeyActionSheet extends StatefulWidget {
  const AddKeyActionSheet(
      {Key? key, required List<String> list, required this.parentSetter})
      : _listKeys = list,
        super(key: key);

  final List<String> _listKeys;
  final Function parentSetter;

  @override
  _AddKeyActionSheetState createState() => _AddKeyActionSheetState();
}

class _AddKeyActionSheetState extends State<AddKeyActionSheet> {
  _inputError textFieldError = _inputError.none;

  final textFieldControler = TextEditingController();

  void _onAddKey(String key, List<String> keysArray) {
    if (key.isEmpty) {
      textFieldError = _inputError.empty;
    } else if (key.length != key.runes.length) {
      textFieldError = _inputError.notBasicCharacters;
    } else if (key.length != 16) {
      textFieldError = _inputError.badLenght;
    } else {
      textFieldError = _inputError.none;
    }

    textFieldError == _inputError.none
        ? () {
            keysArray.add(key);
            SharedPreferences.getInstance().then((prefs) {
              prefs.setString(keysArrayPrefsKey, json.encode(keysArray)).then(
                (s) {
                  widget.parentSetter();
                },
              );
            });
            Navigator.pop(context);
          }.call()
        : setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add a new key",
              style: Theme.of(context).textTheme.headline3,
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 30,
                top: 30,
              ),
              child: TextField(
                controller: textFieldControler,
                decoration: InputDecoration(
                  labelText: "The key",
                  errorText: () {
                    switch (textFieldError) {
                      case _inputError.empty:
                        return "Key cannot be empty";
                      case _inputError.badLenght:
                        int l = textFieldControler.text.length;
                        return "Key should be 16 characters(you have $l)";
                      case _inputError.notBasicCharacters:
                        return "Nice key, but it should be only text";
                      default:
                        return null;
                    }
                  }.call(),
                ),
                onEditingComplete: () {
                  _onAddKey(textFieldControler.text, widget._listKeys);
                },
              ),
            ),
            MaterialButton(
              child: const Text("Add key"),
              color: Theme.of(context).accentColor,
              padding: const EdgeInsets.all(15),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              minWidth: double.infinity,
              onPressed: () {
                _onAddKey(textFieldControler.text, widget._listKeys);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    textFieldControler.dispose();
    super.dispose();
  }
}
