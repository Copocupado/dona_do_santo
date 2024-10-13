import 'package:auto_size_text/auto_size_text.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:dona_do_santo/pages/reverse_store_dummy_docs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../auth/firebase_auth/auth_util.dart';
import '../../backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;
import '/flutter_flow/custom_functions.dart'
as functions;

class HomePageWidget extends StatelessWidget{

  final scaffoldKey = GlobalKey<ScaffoldState>();
  HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ), //Margem para não interferir com a AppBar
                    /*FloatingActionButton(
                      onPressed: _generateDummyDocs,
                      child: const Text('Generate Reverse Store Docs'),
                    ),*/
                    const WelcomeWidget(),
                    const InfoContainers(),
                    const SizedBox(height: 20), //margin top 20
                    const StoreNews(),
                    const GeneralNews(),
                  ].divide(const SizedBox(height: 10)),
                ),
                components.AppBar(
                  imageVariant: "default",
                  mainColor: FlutterFlowTheme.of(context).primaryText,
                  secondaryColor: FlutterFlowTheme.of(context).tertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _generateDummyDocs() async {
    for(int i = 0; i < 10; i++){
      await SolicitacoesRecord.collection.doc().set(createDummyDoc());
      print('generated doc');
    }
    print('END!!!!!!!!!!!!!!!');
  }
}
class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(-1, 0),
      child: Text(
        'Como vai ${functions.returnFirstName(currentUserDisplayName)}?',
        style: FlutterFlowTheme.of(context).bodyMedium.override(
          fontFamily: 'Readex Pro',
          color: FlutterFlowTheme.of(context).tertiary,
          fontSize: 17,
          letterSpacing: 0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

//containers start
class InfoContainers extends StatelessWidget {
  const InfoContainers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: const AlignmentDirectional(1, 1),
          children: [
            ClipRRect(
              borderRadius:
              BorderRadius.circular(InfoContainer.getBorderRadius()),
              child: InfoContainer.returnImage(
                "assets/images/home_page/image_container1.webp",
              ),
            ),
            const InfoContainer(
              imageUrl: 'None',
              header: 'Reverse',
              icon: FontAwesomeIcons.rev,
              description:
              'Revenda peças de roupa da nossa loja que não usará mais com nosso sistema exclusivo de intermediação',
              buttonText: 'Saiba mais',
              hasGradient: true,
              pageName: 'AboutReverse',
            ),
          ],
        ),
        const InfoContainer(
          imageUrl:
          "assets/images/home_page/image_container2.png",
          header: 'Personal Stylist',
          icon: Icons.face_2,
          description:
          'Converse com nossas estilistas para dicas de moda e dúvidas sobre combinações de peças',
          buttonText: 'Dúvidas frequentes',
          hasGradient: false,
          pageName: 'DuvidasFrequentes',
        ),
        const InfoContainer(
          imageUrl:
          "assets/images/home_page/image_container3.png",
          header: 'Bazar solidário',
          icon: FontAwesomeIcons.circleDollarToSlot,
          description:
          'Conheça nossas recomendações de instituições de adoção e contribua com suas roupas usadas',
          buttonText: 'Vamos-lá',
          hasGradient: false,
          pageName: 'BazarSolidario',
        ),
      ].divide(const SizedBox(height: 20)),
    );
  }
}

class InfoContainer extends StatelessWidget {
  final String imageUrl;
  final String header;
  final IconData icon;
  final String description;
  final String buttonText;
  final bool hasGradient;
  final String pageName;

  const InfoContainer({
    super.key,
    required this.imageUrl,
    required this.header,
    required this.icon,
    required this.description,
    required this.buttonText,
    required this.hasGradient,
    required this.pageName,
  });

  static double getBorderRadius() {
    return 12;
  }

  static BoxDecoration returnBoxDecoration(
      BuildContext context, bool hasGradient) {
    Color containerColor = FlutterFlowTheme.of(context).tertiary;

    return BoxDecoration(
      color: !hasGradient ? containerColor : null,
      borderRadius: BorderRadius.circular(getBorderRadius()),
      gradient: hasGradient
          ? LinearGradient(
        colors: [
          Colors.transparent,
          containerColor,
        ],
        stops: const [0, 0.45],
        begin: const AlignmentDirectional(1, 0),
        end: const AlignmentDirectional(-1, 0),
      )
          : null,
    );
  }

  static TextStyle returnHeaderStyle(BuildContext context) {
    return FlutterFlowTheme.of(context).bodyMedium.override(
      fontFamily: 'Outfit',
      color: FlutterFlowTheme.of(context).primaryBackground,
      fontSize: 20,
      letterSpacing: 0,
    );
  }

  static FaIcon returnIcon(BuildContext context, IconData icon) {
    return FaIcon(
      icon,
      color: FlutterFlowTheme.of(context).primaryBackground,
      size: 24,
    );
  }

  static TextStyle returnDescriptionStyle(BuildContext context) {
    return FlutterFlowTheme.of(context).bodyMedium.override(
      fontFamily: 'Readex Pro',
      color: FlutterFlowTheme.of(context).secondaryBackground,
      fontSize: 12,
      letterSpacing: 0,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle returnKnowMoreStyle(BuildContext context) {
    return FlutterFlowTheme.of(context).bodyMedium.override(
      fontFamily: 'Readex Pro',
      color: FlutterFlowTheme.of(context).primary,
      letterSpacing: 0,
      fontStyle: FontStyle.italic,
    );
  }

  static Widget returnImage(String imageUrl) {
    return components.AssetImage(
      assetPath: imageUrl,
      width: 180,
      height: 150,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(pageName);
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
        child: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: returnBoxDecoration(context, hasGradient),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Text(
                                header,
                                style: returnHeaderStyle(context),
                              ),
                            ),
                            returnIcon(context, icon),
                          ].divide(const SizedBox(width: 10)),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Align(
                          alignment: const AlignmentDirectional(-1, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.48,
                            decoration: const BoxDecoration(
                              color: Color(0x00FFFFFF),
                            ),
                            child: Align(
                              alignment: const AlignmentDirectional(-1, -1),
                              child: Text(
                                description,
                                style: returnDescriptionStyle(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(-1, 0),
                        child: Text(
                          buttonText,
                          style: returnKnowMoreStyle(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (imageUrl != "None")
              Align(
                alignment: const AlignmentDirectional(1, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: returnImage(imageUrl),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
//containers widget end

class HeaderTexts extends StatelessWidget {
  final String title;
  final IconData? icon;

  const HeaderTexts({
    super.key,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: AutoSizeText(
            title,
            minFontSize: 10,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Outfit',
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Icon(
          icon,
          color: FlutterFlowTheme.of(context).primaryText,
          size: 25,
        ),
      ].divide(const SizedBox(width: 10)),
    );
  }
}

class HomePageCarousel extends StatelessWidget {
  final bool isCardRoupa;
  final bool isNoticiasWidget;
  final List itemList;

  const HomePageCarousel({
    super.key,
    required this.isCardRoupa,
    required this.isNoticiasWidget,
    required this.itemList,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 320,
      child: CarouselSlider(
        items: itemList
            .asMap()
            .entries
            .map(
              (entry) => isCardRoupa
              ? components.CardRoupaComponent(
            key: Key(
              'Keyr8n_${entry.key.toString()}',
            ),
            title: entry.value.title,
            price: entry.value.price,
            image: entry.value.image,
            docRef: entry.value.reference,
          )
              : components.NoticiasCardComponent(
            imagePath: entry.value.image,
            title: entry.value.title,
            description: entry.value.description,
            created_time: entry.value.createdTime,
            link: Uri.parse(entry.value.link),
          ),
        )
            .toList(),
        options: isCardRoupa
            ? CarouselOptions(
          initialPage: 1,
          viewportFraction: 0.5,
          disableCenter: true,
          enlargeCenterPage: true,
          enlargeFactor: 0.25,
          enableInfiniteScroll: false,
          scrollDirection: Axis.horizontal,
          autoPlay: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayInterval: const Duration(milliseconds: (800 + 20000)),
          autoPlayCurve: Curves.linear,
          pauseAutoPlayInFiniteScroll: false,
        )
            : CarouselOptions(
          initialPage: 1,
          viewportFraction: 1,
          disableCenter: true,
          enlargeCenterPage: true,
          enlargeFactor: 0.25,
          enableInfiniteScroll: false,
          scrollDirection: Axis.horizontal,
          autoPlay: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayInterval: const Duration(milliseconds: (800 + 20000)),
          autoPlayCurve: Curves.linear,
          pauseAutoPlayInFiniteScroll: true,
        ),
      ),
    );
  }
}

//StoreNews start
class StoreNews extends StatelessWidget {
  const StoreNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderTexts(title: 'Novidades da loja', icon: FontAwesomeIcons.shirt),
        StreamBuilder<List<NovidadesRecord>>(
            stream: FFAppState().storeNews(
              uniqueQueryKey: 'storeNews',
              requestFn: () => queryNovidadesRecord(
                queryBuilder: (novidadesRecord) =>
                    novidadesRecord.orderBy('created_time', descending: true),
              ),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const components.LoadingIcon();
              }
              return snapshot.data!.isNotEmpty
                  ? HomePageCarousel(
                isCardRoupa: true,
                isNoticiasWidget: false,
                itemList: snapshot.data!,
              )
                  : components.DataNotFound(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  title: 'Nenhuma novidade encontrada');
            }),
      ].divide(const SizedBox(height: 10)),
    );
  }
}
//StoreNews end

//GeneralNews starts
class GeneralNews extends StatelessWidget {
  const GeneralNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderTexts(title: 'Notícias', icon: Icons.newspaper_rounded),
        StreamBuilder<List<NoticiasRecord>>(
          stream: FFAppState().generalNews(
            uniqueQueryKey: 'generalNews',
            requestFn: () => queryNoticiasRecord(
              queryBuilder: (noticiasRecord) =>
                  noticiasRecord.orderBy('created_time', descending: true),
            ),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const components.LoadingIcon();
            }
            return snapshot.data!.isNotEmpty
                ? HomePageCarousel(
              isCardRoupa: false,
              isNoticiasWidget: true,
              itemList: snapshot.data!,
            )
                : components.DataNotFound(
                width: MediaQuery.of(context).size.width,
                height: 200,
                title: 'Nenhuma noticia encontrada');
          },
        ),
      ].divide(const SizedBox(height: 10)),
    );
  }
}

