import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import '../../backend/backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

class GenerateRichText extends StatelessWidget {
  final String normalText;
  final String highlightedText;
  final String pageToNavigateTo;

  const GenerateRichText({
    super.key,
    required this.normalText,
    required this.highlightedText,
    required this.pageToNavigateTo,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textScaler: MediaQuery.of(context).textScaler,
      text: TextSpan(
        children: [
          TextSpan(
            text: normalText,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          TextSpan(
            text: highlightedText,
            style: TextStyle(
              color: FlutterFlowTheme.of(context).secondary,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              fontStyle: FontStyle.normal,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.pushNamed(pageToNavigateTo);
              },
          ),
        ],
        style: FlutterFlowTheme.of(context).bodyMedium.override(
          fontFamily: 'Readex Pro',
          color: FlutterFlowTheme.of(context).primaryBackground,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
