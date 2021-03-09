import 'package:flutter/material.dart';


//
// Future<bool> alertBoxOnWillPopCarrier(context) async {
//   return showDialog<bool>(
//     context: context,
//     barrierDismissible: false, // user must tap button!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('You Have Started Carrying the Beacon '),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: <Widget>[
//               Text('Ask your Friends To Enter Your Id to Follow '),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: Text('No'),
//             onPressed: () {
//               Navigator.of(context).pop(false);
//             },
//           ),
//           TextButton(
//             child: Text('Yes'),
//             onPressed: () {
//               Navigator.of(context).pop(true);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }