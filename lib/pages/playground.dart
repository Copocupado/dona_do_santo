
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../custom_code/actions/show_snack_bar.dart';








class PlayGround extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
      },
    );
  }
}


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

