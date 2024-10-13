import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../reverse/reverse/reverse_widget.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../../../auth/firebase_auth/auth_util.dart';

class DuvidasFrequentesWidget extends StatelessWidget {
  DuvidasFrequentesWidget({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      drawer: const Drawer(
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: ReverseDrawer(),
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const components.HeaderWidget(
                imagePath:
                'assets/images/about/about_stylist.jpeg',
                title: 'Personal Stylist',
                description:
                'Converse com nossas estilistas para dicas de moda e dúvidas sobre combinações de peças',
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    StreamBuilder<List<DuvidasFrequentesRecord>>(
                      stream: FFAppState().fAQs(
                        uniqueQueryKey: 'FAQs',
                        requestFn: () => queryDuvidasFrequentesRecord(
                          queryBuilder: (duvidasFrequentesRecord) =>
                              duvidasFrequentesRecord.orderBy('created_time',
                                  descending: true),
                        ),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const components.LoadingIcon();
                        }

                        List<components.SectionModel> sections = [];

                        for (var data in snapshot.data!) {
                          sections.add(
                            components.SectionModel(
                              expandableTitle: data.title,
                              title: '',
                              description: data.description,
                            ),
                          );
                        }

                        return sections.isNotEmpty
                            ? components.Sections(
                          sectionsName: "Dúvidas frequentes",
                          icon: FontAwesomeIcons.circleQuestion,
                          listOfSections: sections,
                          hasGifs: false,
                        )
                            : components.DataNotFound(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            title: 'Nenhuma dúvida frequente encontrada');
                      },
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Não achou sua dúvida?\nConverse com a nossa personal stylist agora',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 15,
                        letterSpacing: 0,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          final encodedMessage = Uri.encodeComponent(
                              'Olá, me chamo $currentUserDisplayName, e vim pelo seu aplicativo pedir algumas dicas de moda!');
                          final whatsappUrl = Uri.parse(
                              'https://wa.me/${components.ConfigClass.personalStylistNumber}?text=$encodedMessage');

                          await launchUrl(whatsappUrl);
                        } catch (e) {
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            duration: const Duration(seconds: 3),
                            content: components.CustomSnackBar(
                              title: "Erro!",
                              message: "O seguinte erro ocorreu: $e",
                              contentType: "failure",
                              width: 300,
                              height: 150,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        }
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.black,
                              size: 35,
                            ),
                            Text(
                              'Clique aqui',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: 'Readex Pro',
                                color: Colors.black,
                                fontSize: 17,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ]
                              .addToStart(const SizedBox(width: 10))
                              .addToEnd(const SizedBox(width: 10)),
                        ),
                      ),
                    ),
                  ].divide(const SizedBox(height: 10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
