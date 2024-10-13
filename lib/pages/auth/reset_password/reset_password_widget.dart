import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:dona_do_santo/pages/auth/generate_rich_text.dart';
import 'package:dona_do_santo/pages/auth/layout_model.dart';
import 'package:flutter/material.dart';

import '/flutter_flow/custom_functions.dart'
as functions;
import '../../../auth/firebase_auth/auth_util.dart';
import '../../../custom_code/actions/show_snack_bar.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../auth_text_field.dart';

class ResetPasswordWidget extends StatelessWidget {
  const ResetPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final unfocusNode = FocusNode();
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return GestureDetector(
      onTap: () => unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0x00FFFFFF),
        body: LayoutModel(
          label: "Resetar senha",
          children: [
            Text(
              'Esqueceu sua senha?',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
            ),
            Text(
              'Sem problemas, enviaremos instruções para a redefinição por email',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
            ),
            const FormFields(),
            const GenerateRichText(normalText: "Lembrou da sua senha? ", highlightedText: "Volte aqui", pageToNavigateTo: "Login")
          ],
        ),
      ),
    );
  }
}

class FormFields extends StatefulWidget {
  const FormFields({super.key});

  @override
  State<StatefulWidget> createState() => FormFieldsState();
}

class FormFieldsState extends State<FormFields> {
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          AuthTextField(
            controller: emailController,
            focusNode: emailFocusNode,
            label: 'Email',
            icon: Icons.email_rounded,
            autoFillHints: const [AutofillHints.email],
            isPasswordField: false,
          ),
          const SizedBox(height: 10),
          FFButtonWidget(
            onPressed: () async {
              String title = "Erro!";
              String message = "";
              String contentType = "failure";

              if (emailController.text.isEmpty) {
                message = "Email necessário!";
              } else if (!functions.isEmailValid(emailController.text)) {
                message = "Email inválido";
              } else {
                try {
                  await authManager.resetPassword(
                    email: emailController.text,
                    context: context,
                  );

                  title = "Sucesso!";
                  message = "Redefinição enviada para o email informado";
                  contentType = "success";
                } catch (e) {
                  message = "Erro: $e";
                }
              }
              showSnackBar(context, title, message, contentType);
            },
            text: 'Enviar',
            options: FFButtonOptions(
              width: MediaQuery.sizeOf(context).width * 0.5,
              height: 50,
              padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
              iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Outfit',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 20,
                    letterSpacing: 0,
                  ),
              elevation: 3,
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ].divide(const SizedBox(height: 10)),
      ),
    );
  }
}
