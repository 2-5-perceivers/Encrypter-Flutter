import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:encrypter/utilities/sharedPreferencesKeys.dart';

enum _inputError {
  EMPTY,
  BAD_LENGHT,
  NOT_BASIC_CHARACTERS,
  NONE,
}

class AddKeyActionSheet extends StatefulWidget {
  const AddKeyActionSheet(
      {Key? key, required this.listKeys, required this.parentSetter})
      : super(key: key);

  final List<String> listKeys;
  final Function parentSetter;

  @override
  _AddKeyActionSheetState createState() => _AddKeyActionSheetState();
}

class _AddKeyActionSheetState extends State<AddKeyActionSheet> {
  _inputError textFieldError = _inputError.NONE;

  final textFieldControler = TextEditingController();

  void _onAddKey(String key, List<String> keysArray) {
    if (key.isEmpty) {
      textFieldError = _inputError.EMPTY;
    } else if (key.length != key.runes.length) {
      textFieldError = _inputError.NOT_BASIC_CHARACTERS;
    } else if (key.length != 16) {
      textFieldError = _inputError.BAD_LENGHT;
    } else {
      textFieldError = _inputError.NONE;
    }

    textFieldError == _inputError.NONE
        ? () {
            keysArray.add(key);
            widget.parentSetter.call();
            SharedPreferences.getInstance().then((prefs) {
              prefs.setString(keysArrayPrefsKey, json.encode(keysArray));
            });
            Navigator.pop(context);
          }.call()
        : this.setState(() {});
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
                      case _inputError.EMPTY:
                        return "Key cannot be empty";
                      case _inputError.BAD_LENGHT:
                        int l = textFieldControler.text.length;
                        return "Key should be 16 characters(you have $l)";
                      case _inputError.NOT_BASIC_CHARACTERS:
                        return "Nice key, but it should be only text";
                      default:
                        return null;
                    }
                  }.call(),
                ),
                onEditingComplete: () {
                  _onAddKey(textFieldControler.text, widget.listKeys);
                },
              ),
            ),
            MaterialButton(
              child: Text("Add key"),
              color: Theme.of(context).accentColor,
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              minWidth: double.infinity,
              onPressed: () {
                _onAddKey(textFieldControler.text, widget.listKeys);
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
