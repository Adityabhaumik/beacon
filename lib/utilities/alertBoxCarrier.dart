import 'package:flutter/material.dart';

Future<void> alertBoxCarrier(context, String message1, String message2) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('${message1}',style:Theme.of(context).textTheme.headline2,),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('${message2}',style:Theme.of(context).textTheme.headline3),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(

            child: Text('OK',style: Theme.of(context).textTheme.subtitle2,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
