import 'package:dona_do_santo/custom_code/actions/index.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;
import 'package:dona_do_santo/custom_code/widgets/home_page.dart' as homePage;
import 'package:dona_do_santo/flutter_flow/flutter_flow_theme.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../flutter_flow/flutter_flow_widgets.dart';

class QrCodeView extends StatelessWidget {
  final String qrcode;

  const QrCodeView({
    super.key,
    required this.qrcode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              components.AppBarWithGoBackArrow(
                mainColor: FlutterFlowTheme.of(context).primaryText,
                secondaryColor: FlutterFlowTheme.of(context).tertiary,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Image.asset('assets/images/pix.png'),
                    ),
                    Text(
                      'Escaneie o qr code ou copie e cole o texto para realizar o pagamento, notificaremos você assim que o pagamento for confirmado',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const homePage.HeaderTexts(title: 'QR Code', icon: Icons.qr_code_2),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child:  QrImageView(
                          data: qrcode,
                          version: QrVersions.auto,
                          size: 200.0,
                          gapless: true,
                        ),
                      ),
                    ),
                    const homePage.HeaderTexts(title: 'Copia e Cola', icon: Icons.paste),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12, right: 12),
                              child: Text(
                                qrcode,
                                overflow: TextOverflow.ellipsis,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Readex Pro',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: FFButtonWidget(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: qrcode));
                                showSnackbar(context, "Texto copiado!");
                              },
                              text: '',
                              icon: const Icon(
                                Icons.copy,
                              ),
                              options: FFButtonOptions(
                                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                                iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context).secondary,
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Readex Pro',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                ),
                                height: double.infinity,
                                elevation: 0,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(100),
                                  bottomRight: Radius.circular(100),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Você tem até 24 horas para realizar o pagamento',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: "Readex Pro",
                        fontSize: 12,
                        color: FlutterFlowTheme.of(context).error,
                      ),
                    ),
                  ].divide(const SizedBox(height: 12)),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}