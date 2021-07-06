import 'package:flutter/material.dart';

enum _inputError {
  EMPTY,
  BAD_LENGHT,
  NOT_BASIC_CHARACTERS,
  NONE,
}

class AddKeyActionSheet extends StatefulWidget {
  const AddKeyActionSheet({Key? key}) : super(key: key);

  @override
  _AddKeyActionSheetState createState() => _AddKeyActionSheetState();
}

class _AddKeyActionSheetState extends State<AddKeyActionSheet> {
  _inputError textFieldError = _inputError.NONE;

  final textFieldControler = TextEditingController();

  void _onAddKey(String key) {
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
        ? Navigator.pop(context)
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
                bottom: 6,
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
                        return "Key should be 16 characters";
                      case _inputError.NOT_BASIC_CHARACTERS:
                        return "Nice key, but it should be only text";
                      default:
                        return null;
                    }
                  }.call(),
                ),
                onEditingComplete: () {
                  _onAddKey(textFieldControler.text);
                },
              ),
            ),
            MaterialButton(
              child: Text("Add key"),
              color: Theme.of(context).accentColor,
              padding: EdgeInsets.all(20),
              onPressed: () {
                _onAddKey(textFieldControler.text);
              },
            )
          ],
        ),
      ),
    );
  }
}
