// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:dona_do_santo/custom_code/widgets/components.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future signup(
  BuildContext context,
  String email,
  String password,
  String confirmPassword,
  String nome,
) async {
  // Add your function code here!
  String message = '';
  String title = "Erro!";
  String contentType = 'failure';

  if (password == confirmPassword) {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
        'created_time': FieldValue.serverTimestamp(),
        'display_name': nome,
        'photo_url': FFAppState().defaultPfp,
        'uid': userCredential.user?.uid,
        'reverse_credits': 0.0,
      });

      title = "Sucesso";
      message = "Conta criada!";
      contentType = 'success';
      context.pushNamed('HomePage');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'A senha fornecida é fraca demais';
      } else if (e.code == 'email-already-in-use') {
        message = 'Já existe uma conta com este email';
      } else {
        message = 'Ocorreu um erro. Por favor, tente novamente.';
      }
    } catch (e) {
      message = "Um erro inesperado occoreu";
    }
  } else {
    message = "As senhas não coincidem, tente novamente";
  }

  showSnackBar(context, title, message, contentType);
}
