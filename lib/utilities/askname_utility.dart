import 'package:flutter/material.dart';
import '../screens/currentfollowingBeacon_screen.dart';
import 'package:provider/provider.dart';
import '../provider/name_provider.dart';

AlertBoxAskName(BuildContext context) {
  TextEditingController controller = TextEditingController();
  var Nameprovider = Provider.of<NameNotifier>(context);
  void saveName(String value){
    Nameprovider.saveName(value);
  }
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:10.0),
          child: Text(
            'WELCOME 🙌',
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height*0.18,
        ),
        Container(
          child: TextFormField(
            onFieldSubmitted: (value){
              saveName(controller.text);
            },

            controller: controller,
            cursorColor: Theme.of(context).secondaryHeaderColor,
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
            ),
            decoration: InputDecoration(
              fillColor: Theme.of(context).primaryColor,
              filled: true,
              labelText:"Enter Name",
              labelStyle: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor, fontSize: 15),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).secondaryHeaderColor, width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusColor: Theme.of(context).primaryColor,
              hintText:'Enter Name',
              hintStyle: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor, fontSize: 15),
            ),

          ),
        ),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () {
              print(controller.text);
              // controller.text="";
              saveName(controller.text);

            },
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    ),
  );
}
//           actions: <Widget>[
//             ElevatedButton(
//               style: ButtonStyle(
//                   elevation: MaterialStateProperty.all<double>(0.0)),
//               child: Text('Submit', style: TextStyle(color: Colors.white),),
// onPressed: () {
// print(controller.text);
// // controller.text="";
// Nameprovider.saveName(controller.text);
// Navigator.of(context).pop();
// },
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }
