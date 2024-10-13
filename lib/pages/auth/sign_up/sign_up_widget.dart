import 'package:dona_do_santo/custom_code/actions/index.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:dona_do_santo/pages/auth/generate_rich_text.dart';
import 'package:dona_do_santo/pages/auth/layout_model.dart';
import 'package:flutter/material.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../auth_text_field.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({super.key});

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
        body: const LayoutModel(
          label: 'Registrar',
          children: [
            FormFields(),
            GenerateRichText(
                normalText: "Já tem uma conta? ",
                highlightedText: "Clique aqui",
                pageToNavigateTo: "Login")
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

  TextEditingController nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();

  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();

    nameController.dispose();
    nameFocusNode.dispose();

    passwordController.dispose();
    passwordFocusNode.dispose();

    confirmPasswordController.dispose();
    confirmPasswordFocusNode.dispose();

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
          AuthTextField(
            controller: nameController,
            focusNode: nameFocusNode,
            label: 'Nome de usuário',
            icon: Icons.person_2_rounded,
            autoFillHints: const [AutofillHints.name],
            isPasswordField: false,
          ),
          AuthTextField(
            controller: passwordController,
            focusNode: passwordFocusNode,
            label: 'Senha',
            icon: Icons.password_rounded,
            autoFillHints: const [AutofillHints.password],
            isPasswordField: true,
          ),
          AuthTextField(
            controller: confirmPasswordController,
            focusNode: confirmPasswordFocusNode,
            label: 'Confirmar senha',
            icon: Icons.check_circle_outline_rounded,
            isPasswordField: true,
          ),
          const SizedBox(height: 10),
          FFButtonWidget(
            onPressed: () async {
              await signup(
                context,
                emailController.text,
                passwordController.text,
                confirmPasswordController.text,
                nameController.text,
              );
            },
            text: 'Cadastrar-se',
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
