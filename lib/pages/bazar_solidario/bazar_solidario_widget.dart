import '../reverse/reverse/reverse_widget.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;
import 'package:dona_do_santo/pages/home_page/home_page_widget.dart' as homePage;

class BazarSolidarioWidget extends StatelessWidget {
  BazarSolidarioWidget({super.key});

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
                'assets/images/about/about_bazar.jpeg',
                title: 'Bazar Solidário',
                description:
                'Conheça nossas recomendações de instituições de adoção e contribua com suas roupas usadas',
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    StreamBuilder<List<RecomendacoesRecord>>(
                      stream: FFAppState().storeRecomendations(
                        uniqueQueryKey: 'storeRecomendations',
                        requestFn: () => queryRecomendacoesRecord(
                          queryBuilder: (recomendacoesRecord) => recomendacoesRecord
                              .orderBy('created_time', descending: true),
                        ),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return components.LoadingIcon();
                        }
                        return snapshot.data!.isNotEmpty
                            ? homePage.HomePageCarousel(
                          isCardRoupa: false,
                          isNoticiasWidget: true,
                          itemList: snapshot.data!,
                        )
                            : components.DataNotFound(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            title: 'Nenhuma recomendação encontrada');
                      },
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

