import 'package:dona_do_santo/custom_code/widgets/components.dart'
    as components;
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:dona_do_santo/pages/auth/generate_rich_text.dart';
import 'package:dona_do_santo/pages/auth/layout_model.dart';
import 'package:flutter/material.dart';

import '../../../auth/firebase_auth/auth_util.dart';
import '../../../backend/firebase/firebase_config.dart';
import '../../../custom_code/actions/login.dart';
import '../../../custom_code/actions/show_snack_bar.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../auth_text_field.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

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
          label: 'Entrar',
          children: [
            const FormFields(),
            const GenerateRichText(normalText: "Não tem uma conta? ", highlightedText: "Cadastre-se agora", pageToNavigateTo: "SignUp"),
            const SizedBox(height: 10),
            Text(
              'Ou continue com',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Outfit',
                    color: const Color(0xFFB6B6B6),
                    fontSize: 15,
                    letterSpacing: 0,
                  ),
            ),
            const GoogleContainer(),
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

  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();

    passwordController.dispose();
    passwordFocusNode.dispose();
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
            controller: passwordController,
            focusNode: passwordFocusNode,
            label: 'Senha',
            icon: Icons.password_rounded,
            autoFillHints: const [AutofillHints.password],
            isPasswordField: true,
          ),
          const Align(
            alignment: AlignmentDirectional(-1, 0),
            child: GenerateRichText(normalText: "Esqueceu sua senha? ", highlightedText: "Clique aqui", pageToNavigateTo: "ResetPassword")
          ),
          const SizedBox(height: 10),
          FFButtonWidget(
            onPressed: () async {
              throw Exception();
              await login(
                context,
                emailController.text,
                passwordController.text,
              );
            },
            text: 'Fazer login',
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

class GoogleContainer extends StatefulWidget {
  const GoogleContainer({super.key});

  @override
  State<StatefulWidget> createState() => GoogleContainerState();
}

class GoogleContainerState extends State<GoogleContainer> {
  bool isLogingWithGoogle = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            setState(() {
              isLogingWithGoogle = true;
            });

            String title = "";
            String message = "";
            String contentType = "";

            try {
              GoRouter.of(context).prepareAuthEvent();
              final user = await authManager.signInWithGoogle(context);
              if (user == null) {
                return;
              }
              title = "Sucesso!";
              message = "Login com o google feito com sucesso";
              contentType = "success";
            } catch (e) {
              title = "Erro!";
              message = "O seguinte erro ocorreu: $e";
              contentType = "failure";
              setState(() {
                isLogingWithGoogle = false;
              });
            }
            showSnackBar(context, title, message, contentType);
            print(message);

            setState(() {
              isLogingWithGoogle = false;
            });
            context.goNamedAuth('HomePage', context.mounted);
          },
          child: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLogingWithGoogle
                    ? const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(),
                      )
                    : Row(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: const components.AssetImage(
                                assetPath: 'assets/images/auth/google_logo.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                          Text(
                            'Google',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 17,
                                  letterSpacing: 0,
                                ),
                          ),
                        ].divide(const SizedBox(width: 10)),
                      ),
              ].divide(const SizedBox(width: 10)),
            ),
          ),
        ),
      ],
    );
  }
}
