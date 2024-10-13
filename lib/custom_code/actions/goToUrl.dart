import 'package:url_launcher/url_launcher.dart';
import 'package:dona_do_santo/custom_code/actions/show_snack_bar.dart';
import 'package:flutter/material.dart';

Future<void> goToUrl(BuildContext context, String url) async {
  Uri link = Uri.parse(url);
  if (await canLaunchUrl(link)) {
    await launchUrl(link);
  } else {
    showSnackBar(
        context,
        'Falha ao acessar link',
        'Verifique sua conexão com a internet e tente novamente',
        'failure');
  }
}