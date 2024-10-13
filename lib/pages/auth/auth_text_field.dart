import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? parentFunction;
  final Iterable<String>? autoFillHints;
  final String label;
  final IconData icon;
  final bool isPasswordField;

  const AuthTextField({
    super.key,
    this.parentFunction,
    this.autoFillHints,
    required this.label,
    required this.icon,
    required this.isPasswordField,
    required this.controller,
    required this.focusNode,
  });

  @override
  State<StatefulWidget> createState() => AuthTextFieldState();
}

class AuthTextFieldState extends State<AuthTextField> {
  bool passwordVisibility = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      autofocus: false,
      autofillHints: widget.autoFillHints,
      onChanged: widget.parentFunction != null
          ? (_) => EasyDebounce.debounce(
        'controller-debounce',
        const Duration(milliseconds: 2000),
        widget.parentFunction!,
      )
          : null,
      obscureText: widget.isPasswordField && !passwordVisibility,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
          fontFamily: 'Readex Pro',
          color: const Color(0xFFB6B6B6),
          fontSize: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFB6B6B6),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).error,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(
          widget.icon,
          color: FlutterFlowTheme.of(context).secondaryBackground,
          size: 25,
        ),
        suffixIcon: widget.isPasswordField
            ? InkWell(
          onTap: () => setState(() => passwordVisibility = !passwordVisibility),
          focusNode: FocusNode(skipTraversal: true),
          child: Icon(
            passwordVisibility
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 24,
              color: const Color(0xFFB6B6B6),
          ),
        )
            : null,
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
        fontFamily: 'Readex Pro',
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
