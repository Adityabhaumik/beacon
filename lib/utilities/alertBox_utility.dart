import 'package:flutter/material.dart';
import '../screens/currentfollowingBeacon_screen.dart';

Future<void> AlertBox(BuildContext context, int index) {
  TextEditingController controller = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter Id of Beacon Carrier'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
                color: Colors.white24,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  controller: controller,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Pass Key",
                    labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                    focusColor: Colors.black,
                    hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(0.0)),
            child: Text('Submit',style: TextStyle(color: Colors.white),),
            onPressed: () {
              print(controller.text);
              // controller.text="";
              Navigator.of(context).pop();
              Navigator.pushNamed(context, CurrentfollowingBeacon.id,
                  arguments: controller.text);
            },
          ),
        ],
      );
    },
  );
}
