import 'package:flutter/material.dart';

Future<void> alertBoxCarrier(context, String message1, String message2) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('${message1}'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('${message2}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
