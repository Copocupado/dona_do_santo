
import 'package:auto_size_text/auto_size_text.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:dona_do_santo/auth/firebase_auth/auth_util.dart';
import 'package:dona_do_santo/backend/backend.dart';
import 'package:dona_do_santo/backend/schema/reverse_store_record.dart';
import 'package:dona_do_santo/components/reverse_builder.dart';
import 'package:dona_do_santo/custom_code/actions/convertDoubleToString.dart';
import 'package:dona_do_santo/custom_code/actions/goToUrl.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;
import 'package:dona_do_santo/custom_code/widgets/index.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import '../../../custom_code/widgets/components.dart';
import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';

class ReverseStoreItem extends StatelessWidget {
  const ReverseStoreItem({
    super.key,
    this.solicitacao,
    this.reverseStoreDoc,
    this.novidade,
  });

  final DocumentReference? solicitacao;
  final DocumentReference? reverseStoreDoc;
  final DocumentReference? novidade;

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: SafeArea(
        top: true,
        child: reverseStoreDoc != null
            ? StreamBuilder<ReverseStoreRecord>(
          stream: FFAppState().reverseStoreItem(
            uniqueQueryKey: reverseStoreDoc!.id,
            requestFn: () =>
                ReverseStoreRecord.getDocument(reverseStoreDoc!),
          ),
          builder: (context, snapshot) {
            // Customize what your widget looks like when it's loading.
            if (!snapshot.hasData) {
              return components.LoadingIcon();
            }
            CardViewLayout.doc = snapshot.data!;
            return const CardViewLayout();
          },
        )
            : solicitacao != null
            ? StreamBuilder<SolicitacoesRecord>(
            stream: FFAppState().storeRequest(
              uniqueQueryKey: solicitacao?.id,
              requestFn: () =>
                  SolicitacoesRecord.getDocument(solicitacao!),
            ),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return components.LoadingIcon();
              }
              CardViewLayout.doc = snapshot.data!;
              return const CardViewLayout();
            })
            : StreamBuilder<NovidadesRecord>(
            stream: FFAppState().storeNewsItem(
              uniqueQueryKey: novidade?.id,
              requestFn: () =>
                  NovidadesRecord.getDocument(novidade!),
            ),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return components.LoadingIcon();
              }
              CardViewLayout.doc = snapshot.data!;
              return const CardViewLayout();
            }),
      ),
    );
  }
}

class CardViewLayout extends StatelessWidget {
  static late GeneralInfo doc;

  const CardViewLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: CarouselSlider(
                            items: doc.nullableImages!
                                .map(
                                  (image) => components.ImageWithPlaceholder(
                                image: image,
                              ),
                            )
                                .toList(),
                            options: CarouselOptions(
                              initialPage: 0,
                              viewportFraction: 1,
                              disableCenter: true,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.25,
                              enableInfiniteScroll: true,
                              scrollDirection: Axis.horizontal,
                              autoPlay: true,
                              autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                              autoPlayInterval:
                              const Duration(milliseconds: (800 + 20000)),
                              autoPlayCurve: Curves.linear,
                              pauseAutoPlayInFiniteScroll: true,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: IconButtons(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          constraints: const BoxConstraints(
                            maxHeight: 50,
                          ),
                          child: Text(
                            doc.title,
                            overflow: TextOverflow.ellipsis,
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                              fontFamily: 'Outfit',
                              color:
                              FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                        ),
                        if(doc is! NovidadesRecord)
                          StreamBuilder<UsersRecord>(
                            stream: FFAppState().userInfo(
                              uniqueQueryKey: doc.createdBy.toString(),
                              requestFn: () =>
                                  UsersRecord.getDocument(doc.createdBy!),
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return components.LoadingIcon();
                              }
                              return Container(
                                constraints: const BoxConstraints(
                                  maxHeight: 30,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Sendo vendido por: ${snapshot.data!.displayName}',
                                  overflow: TextOverflow.ellipsis,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            },
                          ),
                        Container(
                          constraints: const BoxConstraints(
                            maxHeight: 30,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'R\$${convertDoubleToString(doc.price)}',
                            overflow: TextOverflow.ellipsis,
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                              fontFamily: 'Outfit',
                              color:
                              FlutterFlowTheme.of(context).primaryText,
                              fontSize: 21,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          constraints: const BoxConstraints(
                            maxHeight: 100,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            doc.description,
                            //overflow: TextOverflow.ellipsis,
                            style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context)
                                  .secondaryText,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: doc is! NovidadesRecord ? 40 : null,
                          child: doc is! NovidadesRecord ? Row(
                            children: [
                              Expanded(child: Chip(text: doc.gender ?? 'Não Informado')),
                              Expanded(child: Chip(text: doc.category ?? 'Não Informado')),
                              Expanded(child: Chip(text: doc.size ?? 'Não Informado')),
                            ].divide(const SizedBox(width: 5)),
                          ) : GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 2.5,
                            ),
                            scrollDirection: Axis.vertical,
                            itemCount: doc.sizes!.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 1000,
                                width: 1000,
                                child: Chip(text: doc.sizes![index]),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          constraints: const BoxConstraints(
                            maxHeight: 400,
                          ),
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.2,
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: doc.nullableImages?.length,
                            itemBuilder: (context, listIndex) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  onTap: () => context.pushNamed(
                                    'Gallery',
                                    queryParameters: {
                                      'index' : serializeParam(
                                        listIndex,
                                        ParamType.int,
                                      ),
                                      'images' : serializeParam(
                                        doc.nullableImages,
                                        ParamType.String,
                                        isList: true,
                                      ),
                                    }.withoutNulls,
                                  ),
                                  child: ImageWithPlaceholder(
                                      image: doc.nullableImages![listIndex]),
                                ),
                              );
                            },
                          ),
                        ),
                      ].divide(const SizedBox(height: 10)),
                    ),
                  ),
                ],
              ),
            )),
        if (doc.createdBy != currentUserReference && (doc is ReverseStoreRecord || doc is NovidadesRecord))
          Expanded(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryText,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: FFButtonWidget(
                  onPressed: () async {
                    if (doc is ReverseStoreRecord){
                      context.pushNamed(
                        'ExtraDetails',
                        queryParameters: {
                          'itemsList': serializeParam(
                            [doc as ReverseStoreRecord],
                            ParamType.Document,
                            isList: true,
                          ),
                        }.withoutNulls,
                        extra: <String, dynamic>{
                          'itemsList': [doc as ReverseStoreRecord],
                        },
                      );
                    } else {
                      await goToUrl(context, doc.webstoreLink ?? '');
                    }
                  },
                  text: doc is ReverseStoreRecord ? 'Comprar via pix' : 'Comprar em nosso site',
                  icon: Icon(
                    doc is ReverseStoreRecord ? Icons.pix_rounded : Icons.store,
                    size: 27,
                    color: doc is ReverseStoreRecord ? Colors.white : FlutterFlowTheme.of(context).primaryText,
                  ),
                  options: FFButtonOptions(
                    color: doc is ReverseStoreRecord ? const Color(0xFF00B488) : FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Outfit',
                      color: doc is ReverseStoreRecord ? Colors.white : FlutterFlowTheme.of(context).primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    elevation: 12,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool isReverseStoreDoc() {
    return doc.docRef.path.startsWith('reverse_store/');
  }
}

class Chip extends StatelessWidget {
  final String text;

  const Chip({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: FlutterFlowTheme.of(context).tertiary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: AutoSizeText(
          text,
          minFontSize: 10,
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).headlineMedium.override(
            fontFamily: 'Outfit',
            color: FlutterFlowTheme.of(context).primary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class IconButtons extends StatelessWidget {
  const IconButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        returnButton(context, Icons.arrow_back_rounded, () => context.pop()),
        if(CardViewLayout.doc is! NovidadesRecord)
          CardViewLayout.doc.createdBy == currentUserReference ? components.OptionsIcon(docRef: CardViewLayout.doc.docRef, iconSize: 25, buttonSize: 46) : components.ToggleHeartIcon(docRef: CardViewLayout.doc.docRef),
      ],
    );
  }
}

FlutterFlowIconButton returnButton(
    BuildContext context, IconData icon, dynamic function) {
  return FlutterFlowIconButton(
    borderColor: FlutterFlowTheme.of(context).alternate,
    borderRadius: 8,
    buttonSize: 46,
    fillColor: const Color(0x8B484848),
    icon: Icon(
      icon,
      color: Colors.white,
      size: 25,
    ),
    onPressed: function,
  );
}


