// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:dona_do_santo/auth/firebase_auth/auth_util.dart';

import 'package:dona_do_santo/custom_code/widgets/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:dona_do_santo/custom_code/actions/show_snack_bar.dart";
import '../../../backend/firebase/firebase_config.dart';

// Assume you have the CustomSnackBar widget implemented as shown before

Future login(
  BuildContext context,
  String email,
  String password,
) async {
  String message = '';
  String title = "Erro!";
  String contentType = 'failure';

  try {
    GoRouter.of(context).prepareAuthEvent();
    final user = await authManager.signInWithEmail(
      context,
      email,
      password,
    );
    if (user == null) {
      ScaffoldMessenger.of(context)..hideCurrentSnackBar();
      message = "Email ou senha incorreto";
    } else {
      title = "Sucesso";
      message = "Login bem-sucedido!";
      contentType = 'success';

      context.goNamedAuth('HomePage', context.mounted);
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      message = 'Nenhum usuário encontrado para este email.';
    } else {
      message = 'Email ou senha incorreto';
    }
  } catch (e) {
    message = "Um erro inesperado ocorreu";
  }

  showSnackBar(context, title, message, contentType);
}
