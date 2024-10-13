import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;

Future<void> customLaunchUrl(String string, BuildContext context) async {
  try {
    final url = Uri.parse(string);
    await launchUrl(url);

  } catch (e) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 3),
      content: components.CustomSnackBar(
        title: "Erro!",
        message: "O seguinte erro ocorreu: $e",
        contentType: "failure",
        width: 300,
        height: 150,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}