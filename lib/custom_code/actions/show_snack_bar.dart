// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:dona_do_santo/custom_code/widgets/components.dart'
    as components;

Future showSnackBar(
  BuildContext context,
  String title,
  String message,
  String contentType,
) async {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    duration: Duration(seconds: 3),
    content: components.CustomSnackBar(
      title: title,
      message: message,
      contentType: contentType,
      width: 300,
      height: 200,
    ),
  );

  ScaffoldMessenger.of(context)
    //..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
