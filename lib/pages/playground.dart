/*
// Automatic FlutterFlow imports
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_icon_button.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import '../../../custom_code/actions/convertDoubleToString.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:url_launcher/url_launcher.dart';

import '/backend/backend.dart';
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../../auth/firebase_auth/auth_util.dart';
import '../../backend/schema/notifications_record.dart';
import 'package:super_tooltip/super_tooltip.dart';
import '../../pages/notifications/notifications_widget.dart';
import 'package:dona_do_santo/backend/schema/reverse_store_record.dart';
import '/flutter_flow/upload_data.dart';
import '../../custom_code/actions/deleteImagesFromStorage.dart';
import 'package:dona_do_santo/backend/schema/structs/favs_by_user_struct.dart';

class NotificationBadge extends StatelessWidget {
  final Color mainColor;
  final Color secondaryColor;

  const NotificationBadge({super.key,
    required this.mainColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (GoRouterState.of(context).uri.toString() != "/notifications") {
          context.pushNamed('Notifications');
        }
      },
      child: StreamBuilder<List<NotificationsRecord>>(
        stream: FFAppState().storeNotifications(
          uniqueQueryKey: currentUserReference?.id,
          requestFn: () => queryNotificationsRecord(
            queryBuilder: (notificationsRecord) => notificationsRecord
                .orderBy('created_time', descending: true)
                .where(
              'belongs_to',
              isEqualTo: currentUserReference,
            ),
          ),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingIcon();
          }
          List<NotificationsRecord> list = snapshot.data!;
          return SizedBox(
            width: 35,
            height: 35,
            child: badges.Badge(
              position: badges.BadgePosition.topEnd(top: -5, end: 0),
              showBadge: shouldShowBadge(list),
              ignorePointer: false,
              badgeContent: const Text(""),
              badgeAnimation: const badges.BadgeAnimation.scale(
                animationDuration: Duration(seconds: 1),
                colorChangeAnimationDuration: Duration(seconds: 1),
                loopAnimation: false,
                curve: Curves.fastOutSlowIn,
                colorChangeAnimationCurve: Curves.easeInCubic,
              ),
              badgeStyle: badges.BadgeStyle(
                shape: badges.BadgeShape.circle,
                badgeColor: secondaryColor,
                padding: const EdgeInsets.all(5),
                elevation: 3,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: mainColor,
                size: 30,
              ),
            ),
          );
        },
      ),
    );
  }

  bool shouldShowBadge(List<NotificationsRecord> list) {
    for (var notification in list) {
      if (notification.viewed == false) {
        return true;
      }
    }
    return false;
  }
}

class ConfigClass {
  // taxa cobrada pela loja
  static const fee = 10;
  static const personalStylistNumber = '+5554999686749';
  static const staffNumber = '5554999686749';

  static final shippingList = [
    'Com o vendedor',
    'Produto despachado pelo vendedor',
    'Em trânsito',
    "Disponínel para retirada",
    "Entregue",
  ];

  static const dispatchProductTime = 3;
  static const storeTimeToShip = 5;
}

class AppBar extends StatelessWidget {
  final String imageVariant;
  final Color mainColor;
  final Color secondaryColor;
  final IconData? menuIcon;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const AppBar({
    super.key,
    required this.imageVariant,
    required this.mainColor,
    required this.secondaryColor,
    this.menuIcon,
    this.scaffoldKey,
  });

  Widget returnStoreLogo() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AssetImage(
          assetPath: imageVariant == "default"
              ? "assets/images/logo_as_text.png"
              : "assets/images/logo_as_text_alternate.png",
          width: 200,
          height: 24,
        ));
  }

  Widget returnAppBarIcon(IconData icon, BuildContext context) {
    return InkWell(
      onTap: () {
        if (GoRouterState.of(context).uri.toString() != "/favs") {
          context.pushNamed('Favs');
        }
      },
      child: Icon(
        icon,
        color: mainColor,
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 30),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          returnStoreLogo(),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              returnAppBarIcon(Icons.shopping_bag_outlined, context),
              menuIcon == null
                  ? NotificationBadge(
                  mainColor: mainColor, secondaryColor: secondaryColor)
                  : InkWell(
                onTap: () {
                  try {
                    scaffoldKey!.currentState!.openDrawer();
                  } catch (e) {
                    showSnackBar(
                        context, 'Erro!', e.toString(), 'failure');
                  }
                },
                child: Icon(
                  menuIcon!,
                  color: mainColor,
                  size: 30,
                ),
              ),
            ].divide(const SizedBox(width: 30)),
          ),
        ],
      ),
    );
  }
}

class AppBarWithGoBackArrow extends StatelessWidget {
  final Color mainColor;
  final Color secondaryColor;

  const AppBarWithGoBackArrow({super.key,
    required this.mainColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Align(
            alignment: const Alignment(-1, 0),
            child: InkWell(
              onTap: () {
                context.safePop();
              },
              child: Icon(
                FontAwesomeIcons.arrowLeft,
                color: mainColor,
                size: 24,
              ),
            ),
          ),
          AppBar(
            imageVariant: mainColor == FlutterFlowTheme.of(context).primaryText
                ? "default"
                : "variant",
            mainColor: mainColor,
            secondaryColor: secondaryColor,
          ),
        ],
      ),
    );
  }
}

class LoadingIcon extends StatelessWidget {
  final Color? altColor;

  const LoadingIcon({
    super.key,
    this.altColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            altColor ?? FlutterFlowTheme.of(context).tertiary,
          ),
        ),
      ),
    );
  }
}

class AssetImage extends StatelessWidget {
  final String assetPath;
  final double width;
  final double height;

  const AssetImage({super.key,
    required this.width,
    required this.height,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}

class ImageWithPlaceholder extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;

  const ImageWithPlaceholder({super.key,
    required this.image,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return width != null || height != null ? OctoImage(
      placeholderBuilder: (_) => const SizedBox.expand(
        child: Image(
          image: BlurHashImage('LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
          fit: BoxFit.cover,
        ),
      ),
      image: CachedNetworkImageProvider(
        image,
      ),
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/error_image.png',
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    ) : OctoImage(
      placeholderBuilder: (_) => const SizedBox.expand(
        child: Image(
          image: BlurHashImage('LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
          fit: BoxFit.cover,
        ),
      ),
      image: CachedNetworkImageProvider(
        image,
      ),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        'assets/images/error_image.png',
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}

class DataNotFound extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final IconData? icon;

  const DataNotFound({super.key,
    required this.title,
    this.height,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return height == null
        ? Center(
      child: content(context),
    )
        : SizedBox(
      width: width,
      height: height,
      child: content(context),
    );
  }
  Widget content(BuildContext context){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon ?? FontAwesomeIcons.circleExclamation,
          color: const Color(0x7B343533),
          size: 80,
        ),
        Text(
          title,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Readex Pro',
            color: const Color(0x7B343533),
            fontSize: 15,
            letterSpacing: 0,
            fontWeight: FontWeight.w900,
          ),
        ),
      ].divide(const SizedBox(height: 10)),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const HeaderWidget({super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.of(context).size.height *
        0.7; //Mude o valor para mudar o tamanho do header

    return Stack(
      children: [
        ApplyBackGroundStyles(
          imagePath: imagePath,
          widgetWidth: MediaQuery.of(context).size.width,
          widgetHeight: headerHeight,
        ),
        AppBarWithGoBackArrow(
            mainColor: FlutterFlowTheme.of(context).primaryBackground,
            secondaryColor: FlutterFlowTheme.of(context).secondary),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: headerHeight - 50,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: (headerHeight - 50) * 0.6,
                  child: Align(
                    alignment: const AlignmentDirectional(0, 1),
                    child: AutoSizeText(
                      title,
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color:
                        FlutterFlowTheme.of(context).primaryBackground,
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: (headerHeight - 50) * 0.2,
                  child: Align(
                    alignment: const AlignmentDirectional(0, 1),
                    child: AutoSizeText(
                      description,
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color:
                        FlutterFlowTheme.of(context).primaryBackground,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Sections extends StatelessWidget {
  final String sectionsName;
  final IconData icon;
  final List<SectionModel> listOfSections;
  final bool hasGifs;

  const Sections(
      {super.key, required this.sectionsName,
        required this.icon,
        required this.listOfSections,
        required this.hasGifs});

  TextStyle returnSectionsStyle(BuildContext context) {
    return FlutterFlowTheme.of(context).bodyMedium.override(
      fontFamily: 'Readex Pro',
      color: FlutterFlowTheme.of(context).tertiary,
      fontSize: 25,
      letterSpacing: 0,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              sectionsName,
              style: returnSectionsStyle(context),
            ),
            Icon(
              icon,
              color: FlutterFlowTheme.of(context).tertiary,
              size: 30,
            ),
          ].divide(const SizedBox(width: 10)),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: listOfSections.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Section(
                  model: listOfSections[index],
                  hasGif: hasGifs,
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class SectionModel {
  final String expandableTitle;
  final String title;
  final String description;
  final String gifPath;

  const SectionModel({
    required this.title,
    required this.description,
    this.gifPath = "",
    required this.expandableTitle,
  });
}

class Section extends StatelessWidget {
  final SectionModel model;
  final bool hasGif;

  const Section({super.key,
    required this.model,
    required this.hasGif,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        shape: const Border(),
        title: Text(
          model.expandableTitle,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Readex Pro',
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (model.title != "")
                  Text(
                    model.title,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).secondary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  model.description,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: FlutterFlowTheme.of(context).alternate,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (hasGif)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: OctoImage(
                      placeholderBuilder: (_) => const SizedBox.expand(
                        child: Image(
                          image:
                          BlurHashImage('LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      image: NetworkImage(
                        model.gifPath,
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      height: 500,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                            'assets/images/error_image.png',
                            width: MediaQuery.sizeOf(context).width,
                            height: 500,
                            fit: BoxFit.fill,
                          ),
                    ),
                  ),
              ].divide(const SizedBox(height: 10)),
            ),
          ),
        ],
      ),
    );
  }
}

class ApplyBackGroundStyles extends StatelessWidget {
  final String imagePath;
  final double widgetWidth;
  final double widgetHeight;

  const ApplyBackGroundStyles(
      {super.key,
        required this.imagePath,
        required this.widgetWidth,
        required this.widgetHeight});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRect(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 2,
              sigmaY: 2,
            ),
            child: isAssetImage()
                ? AssetImage(
                width: widgetWidth,
                height: widgetHeight,
                assetPath: imagePath)
                : CachedNetworkImage(
              fadeInDuration: const Duration(milliseconds: 0),
              fadeOutDuration: const Duration(milliseconds: 0),
              imageUrl: imagePath,
              width: widgetWidth,
              height: widgetHeight,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
        Container(
          width: widgetWidth,
          height: widgetHeight,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  bool isAssetImage() {
    String firstPart = imagePath.split("/")[0];
    return firstPart == "assets";
  }
}

//Texto acima apenas boneco, começa a contar agora

class CustomCarrousel extends StatelessWidget {
  const CustomCarrousel({
    super.key,
    required this.width,
    required this.height,
    required this.imgList,
  });

  final double width;
  final double height;
  final List<String> imgList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CarouselSlider(
        items: imgList
            .map((item) => ApplyBackGroundStyles(
          imagePath: item,
          widgetWidth: double.infinity,
          widgetHeight: double.infinity,
        ))
            .toList(),
        options: CarouselOptions(
          initialPage: 0,
          viewportFraction: 1.0,
          disableCenter: true,
          enlargeCenterPage: true,
          enlargeFactor: 0.25,
          enableInfiniteScroll: true,
          scrollDirection: Axis.horizontal,
          autoPlay: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 500),
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayCurve: Curves.linear,
          pauseAutoPlayOnTouch: true,
        ),
      ),
    );
  }
}

class CustomStepper extends StatefulWidget {
  final List<String>? stepTitles;
  final List<String>? stepDescriptions;
  final List<String>? stepFiles;
  final List<Step>? listOfSteps;

  const CustomStepper({
    super.key,
    this.stepTitles,
    this.stepDescriptions,
    this.stepFiles,
    this.listOfSteps,
  });

  @override
  State<CustomStepper> createState() => CustomStepperState();
}

class CustomStepperState extends State<CustomStepper> {
  int currentStep = 0;
  late int stepperSize;

  List<Step> createSteps() {
    List<Step> stepList = [];
    for (int i = 0; i < widget.stepTitles!.length; i++) {
      stepList.add(
        Step(
          state: currentStep > i ? StepState.complete : StepState.indexed,
          isActive: currentStep >= i,
          title: returnStepTitle('Etapa ${i + 1}'),
          content: Column(
            children: [
              Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Text(
                  widget.stepTitles![i],
                  textAlign: TextAlign.start,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: FlutterFlowTheme.of(context).tertiary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                widget.stepDescriptions![i],
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageWithPlaceholder(
                  image: widget.stepFiles![i],
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                ),
              ),
            ].divide(const SizedBox(height: 10)),
          ),
        ),
      );
    }
    return stepList;
  }

  Text returnStepTitle(String title) {
    return Text(
      title,
      style: FlutterFlowTheme.of(context).bodyMedium.override(
        fontFamily: 'Readex Pro',
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.listOfSteps != null) {
      stepperSize = widget.listOfSteps!.length;
    } else {
      stepperSize = widget.stepTitles!.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: FlutterFlowTheme.of(context).primaryBackground,
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: FlutterFlowTheme.of(context).secondary,
          surface: FlutterFlowTheme.of(context).secondaryText,
          secondary: const Color.fromARGB(255, 79, 76, 175),
        ),
      ),
      child: Stepper(
        physics: const ClampingScrollPhysics(),
        steps: widget.listOfSteps ?? createSteps(),
        currentStep: currentStep,
        onStepContinue: () {
          if (currentStep != stepperSize - 1) {
            setState(() {
              currentStep += 1;
            });
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() {
              currentStep -= 1;
            });
          }
        },
        controlsBuilder: (context, ControlsDetails) {
          return Container(
            margin: const EdgeInsets.only(top: 50),
            child: Row(
              children: [
                if (currentStep >= 1)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      onPressed: ControlsDetails.onStepCancel,
                      child: Text(
                        'VOLTAR',
                        style: FlutterFlowTheme.of(context)
                            .labelMedium
                            .override(
                            fontFamily: 'Readex Pro',
                            fontSize: 13,
                            color:
                            FlutterFlowTheme.of(context).primaryText),
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                if (currentStep != stepperSize - 1)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FlutterFlowTheme.of(context).secondary,
                      ),
                      onPressed: ControlsDetails.onStepContinue,
                      child: Text(
                        'PRÓXIMO',
                        style: FlutterFlowTheme.of(context)
                            .labelMedium
                            .override(
                            fontFamily: 'Readex Pro',
                            fontSize: 13,
                            color:
                            FlutterFlowTheme.of(context).primaryText),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ContainerWithBorder extends StatelessWidget{
  const ContainerWithBorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          )
      ),
    );
  }
}

BoxDecoration returnBorder(){
  return BoxDecoration(
      border: Border.all(
        color: Colors.black,
      )
  );
}

class CustomSnackBar extends StatefulWidget {
  const CustomSnackBar({
    super.key,
    this.width,
    this.height,
    required this.title,
    required this.message,
    required this.contentType,
  });

  final double? width;
  final double? height;
  final String title;
  final String message;
  final String contentType;

  @override
  State<CustomSnackBar> createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<CustomSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: AwesomeSnackbarContent(
        title: widget.title,
        message: widget.message,
        contentType: _returnContentType(widget.contentType),
      ),
    );
  }

  ContentType _returnContentType(String contentType) {
    switch (contentType) {
      case "success":
        return ContentType.success;
      case "failure":
        return ContentType.failure;
      case "help":
        return ContentType.help;
      default:
        return ContentType.warning;
    }
  }
}

class CardRoupaComponent extends StatefulWidget {
  const CardRoupaComponent({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    this.userRef,
    this.isNegated,
    this.explanation,
    required this.docRef,
  });

  final String title;
  final double price;
  final String image;
  final DocumentReference<Object?>? userRef;
  final bool? isNegated;
  final String? explanation;
  final DocumentReference docRef;

  @override
  State<CardRoupaComponent> createState() => _CardRoupaComponentState();
}

class _CardRoupaComponentState extends State<CardRoupaComponent>
    with TickerProviderStateMixin {
  bool toggle = false;

  final _controller = SuperTooltipController();
  bool isTooltipBeingShown = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          onTap: () {
            print(getParamName(widget.docRef));
            context.pushNamed(
              "ReverseStoreItem",
              queryParameters: {
                getParamName(widget.docRef) : serializeParam(
                  widget.docRef,
                  ParamType.DocumentReference,
                ),
              }.withoutNulls,
            );
          },
          //height: 300,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ImageWithPlaceholder(
                      image: widget.image,
                      width: 200,
                      height: 250,
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(-1, 0),
                    child: Text(
                      'R\$ ${convertDoubleToString(widget.price)}',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 2,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(-1, 0),
                    child: Text(
                      widget.title.maybeHandleOverflow(
                        maxChars: 25,
                        replacement: '…',
                      ),
                      maxLines: 1,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).alternate,
                        fontSize: 12,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
              if(widget.userRef == currentUserReference && widget.isNegated != null)
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: WillPopScope(
                        onWillPop: popToolTip,
                        child: GestureDetector(
                          onTap: () async {
                            await _controller.showTooltip();
                          },
                          child: SuperTooltip(
                              backgroundColor: widget.isNegated! ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).warning,
                              elevation: 10,
                              borderColor: Colors.transparent,
                              popupDirection: TooltipDirection.up,
                              hasShadow: false,
                              showBarrier: true,
                              controller: _controller,
                              content: Text(
                                widget.isNegated! ? "Seu anúncio foi negado pelo motivo de \"${widget.explanation}\" e deve ser editado para poder ser reavaliado" : "Seu anúncio está em avaliação, volte novamente mais tarde",
                                softWrap: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              child: Icon(
                                Icons.warning_rounded,
                                color: widget.isNegated! ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).warning,
                                size: 30,
                              )
                          ),
                        )),
                  ),
                ),
              if(getParamName(widget.docRef) != 'novidade')
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: widget.userRef != currentUserReference
                        ? ToggleHeartIcon(docRef: widget.docRef, buttonSize: 30, iconSize: 15)
                        : OptionsIcon(docRef: widget.docRef),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
  Future<bool> popToolTip() async {
    // If the tooltip is open we don't pop the page on a backbutton press
    // but close the ToolTip
    if (_controller.isVisible) {
      await _controller.hideTooltip();
      return false;
    }
    return true;
  }
}
class OptionsIcon extends StatelessWidget {
  final double buttonSize;
  final double iconSize;
  final DocumentReference<Object?> docRef;

  const OptionsIcon({super.key,
    this.buttonSize = 30,
    this.iconSize = 15,
    required this.docRef,
  });

  @override
  Widget build(BuildContext context){
    return FlutterFlowIconButton(
      borderColor: FlutterFlowTheme.of(context).alternate,
      borderRadius: 8,
      buttonSize: buttonSize,
      fillColor: const Color(0x8B484848),
      icon: Icon(
        FontAwesomeIcons.ellipsisVertical,
        color: Colors.white,
        size: iconSize,
      ),
      onPressed: () async {
        await showAlignedDialog(
          context: context,
          isGlobal: false,
          avoidOverflow: true,
          targetAnchor:
          const AlignmentDirectional(-1, 0).resolve(Directionality.of(context)),
          followerAnchor:
          const AlignmentDirectional(0, 0).resolve(Directionality.of(context)),
          builder: (dialogContext) {
            return Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () => FocusScope.of(dialogContext).unfocus(),
                child: OptionsDialog(docRef: docRef),
              ),
            );
          },
        );
      },
    );
  }
}
class OptionsDialog extends StatelessWidget {
  final DocumentReference<Object?> docRef;

  const OptionsDialog({
    super.key,
    required this.docRef,
  });

  @override
  Widget build(BuildContext context){
    return Container(
        width: 150,
        height: 84,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Option(function: () => context.pushNamed(
                  'CreateAnuncio',
                  queryParameters: {
                    docRef.path.startsWith('solicitacoes/') ? 'solicitacao' : 'reverseStoreDoc' : serializeParam(
                      docRef,
                      ParamType.DocumentReference,
                    ),
                  }.withoutNulls,
                ), icon: Icons.edit, text: 'Editar'),
                Option(
                  function: () async {

                    bool isConfirmed =
                    await confirmationDialog(context);
                    if (!isConfirmed) return;

                    try{
                      showUploadMessage(
                        context,
                        'Excluindo arquivo...',
                        showLoading: true,
                      );
                      await excluirAnuncio();
                    }
                    finally {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      showSnackBar(context, 'Sucesso', 'Arquivo excluído', "success");
                      context.pushNamed('HomePage');
                    }
                  },
                  icon: Icons.delete,
                  text: 'Excluir',
                ),
              ].divide(const SizedBox(height: 20)),
            )
        )
    );
  }
  Future<void> excluirAnuncio() async {
    List<String> imageList = [];
    print('excluindo...');

    if(docRef.path.startsWith('reverse_store')){
      ReverseStoreRecord doc = await ReverseStoreRecord.getDocumentOnce(docRef);
      imageList = doc.images;
      print('excluindo doc...');
      await doc.reference.delete();
    }
    else{
      SolicitacoesRecord doc = await SolicitacoesRecord.getDocumentOnce(docRef);
      imageList = doc.images;
      print('excluindo doc...');
      await doc.reference.delete();
    }
    await deleteImagesFromStorage(imageList);
  }
}
class Option extends StatelessWidget {
  final dynamic function;
  final IconData icon;
  final String text;

  const Option({
    super.key,
    required this.function,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: function,
      child: Row(
        children: [
          Icon(
            icon,
            color: text == 'Excluir' ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).primaryText,
            size: 20,
          ),
          Text(
            text,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Readex Pro',
              color: text == 'Excluir' ? FlutterFlowTheme.of(context).error : FlutterFlowTheme.of(context).primaryText,
            ),
          ),
        ].divide(const SizedBox(width: 10)),
      ),
    );
  }
}

class ToggleHeartIcon extends StatefulWidget{
  final double buttonSize;
  final double iconSize;
  final DocumentReference<Object?> docRef;

  const ToggleHeartIcon({
    super.key,
    this.buttonSize = 46,
    this.iconSize = 25,
    required this.docRef,
  });

  @override
  State<StatefulWidget> createState() => ToggleHeartIconState();
}

class ToggleHeartIconState extends State<ToggleHeartIcon> with TickerProviderStateMixin {
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();

    animationsMap.addAll({
      'toggleIconOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.elasticOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.2, 1.2),
          ),
          ScaleEffect(
            curve: Curves.elasticOut,
            delay: 300.0.ms,
            duration: 300.0.ms,
            begin: const Offset(1.2, 1.2),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
      anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<DocumentReference>?>(
      valueListenable: FFAppState().userFavedItems,
      builder: (context, favRefs, _) {
        return FlutterFlowIconButton(
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderRadius: 8,
          buttonSize: widget.buttonSize,
          fillColor: const Color(0x8B484848),
          icon: Icon(
            favRefs!.contains(widget.docRef) ? Icons.shopping_bag : Icons.shopping_bag_outlined,
            color: Colors.white,
            size: widget.iconSize,
          ),
          onPressed: () async {
            final currentList = List<DocumentReference>.from(FFAppState().userFavedItems.value!);
            if (currentList.contains(widget.docRef)) {
              currentList.remove(widget.docRef);
              try {
                showSnackbar(context, 'Item removido do carrinho');
              } catch (e) {
                print(e);
              }
            } else {
              currentList.add(widget.docRef);
              try {
                showSnackbar(context, 'Item adicionado ao carrinho');
              } catch (e) {
                print(e);
              }
            }
            FFAppState().userFavedItems.value = currentList;
            FavsByUserStruct newFavsByUser = FavsByUserStruct(user: currentUserReference, reverseStoreItems: FFAppState().userFavedItems);
            for(var item in FFAppState().favsByUserMap){
              print(item.user);
              if(item.user == currentUserReference){
                FFAppState().removeFromFavsByUserMap(item);
                FFAppState().addToFavsByUserMap(newFavsByUser);
              }
            }
            if (animationsMap['toggleIconOnActionTriggerAnimation'] != null) {
              await animationsMap['toggleIconOnActionTriggerAnimation']!
                  .controller
                  .forward(from: 0.0);
            }
          },
        ).animateOnActionTrigger(
          animationsMap['toggleIconOnActionTriggerAnimation']!,
        );
      },
    );
  }
}

class NoticiasCardComponent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final DateTime created_time;
  final Uri link;

  const NoticiasCardComponent({super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.created_time,
    required this.link,
  });

  Widget returnBackGroundImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: ImageWithPlaceholder(
          image: imagePath, width: double.infinity, height: double.infinity),
    );
  }

  Widget returnTextInfo(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 25,
          child: Align(
            alignment: const AlignmentDirectional(-1, 0),
            child: AutoSizeText(
              title,
              minFontSize: 8,
              overflow: TextOverflow.ellipsis,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                fontSize: 17,
                letterSpacing: 0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
          child: Align(
            alignment: const AlignmentDirectional(-1, 0),
            child: AutoSizeText(
              minFontSize: 5,
              description,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 17,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget returnDateTimeText(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: const AlignmentDirectional(-1, 1),
          child: Text(
            DateFormat('dd MMM yyyy', 'pt_BR').format(created_time),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Readex Pro',
              letterSpacing: 0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryText,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Text(
          dateTimeFormat(
            'relative',
            created_time,
            locale: FFLocalizations.of(context).languageCode,
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Readex Pro',
            fontSize: 12,
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ].divide(const SizedBox(width: 5)),
    );
  }

  Widget returnKnowMoreButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await canLaunchUrl(link)) {
          await launchUrl(link);
        } else {
          showSnackBar(
              context,
              'Falha ao acessar link',
              'Verifique sua conexão com a internet e tente novamente',
              'failure');
        }
      },
      child: Container(
        width: 120,
        height: 40,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryText,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Saiba Mais',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  letterSpacing: 0,
                ),
              ),
              FaIcon(
                FontAwesomeIcons.arrowRight,
                color: FlutterFlowTheme.of(context).primary,
                size: 18,
              ),
            ].divide(const SizedBox(width: 5)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        returnBackGroundImage(),
        Align(
          alignment: const AlignmentDirectional(0, 1),
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xE9B9B9B9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  returnTextInfo(context),
                  Container(
                    width: double.infinity,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0x00B9B9B9),
                    ),
                    child: Stack(
                      children: [
                        returnDateTimeText(context),
                        Align(
                          alignment: const AlignmentDirectional(1, 1),
                          child: returnKnowMoreButton(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
*/
