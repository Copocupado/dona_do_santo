// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<bool> confirmationDialog(BuildContext context) async {
  bool confirmDialogResponse = await showDialog<bool>(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            title: Text('Confirmação'),
            content: Text(
                'Tem certeza que deseja continuar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext, false),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext, true),
                child: Text(
                  'Confirmar',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ),
            ],
          );
        },
      ) ??
      false;

  return confirmDialogResponse;
}
