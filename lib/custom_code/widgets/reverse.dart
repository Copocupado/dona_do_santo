// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:dona_do_santo/auth/firebase_auth/auth_util.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;

import 'package:dona_do_santo/pages/home_page/home_page_widget.dart' as homePage;

class Reverse extends StatefulWidget {
  const Reverse({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<Reverse> createState() => _ReverseState();
}

class _ReverseState extends State<Reverse> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      drawer: Drawer(
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: ReverseDrawer(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 100,
                  ), //Margem para não interferir com a AppBar
                ].divide(SizedBox(height: 10)),
              ),
              components.AppBar(
                imageVariant:
                "default",
                mainColor: FlutterFlowTheme.of(context).primaryText,
                secondaryColor: FlutterFlowTheme.of(context).tertiary,
                scaffoldKey: _scaffoldKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReverseDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        children: [
          ProfileSlot(),
          Padding(padding: EdgeInsets.all(24), child: DrawerSlots()),
        ],
      ),
    );
  }
}

class ProfileSlot extends StatelessWidget {
  final double profilePicSize = 80;

  @override
  Widget build(BuildContext context) {
    return AuthUserStreamWidget(
      builder: (context) => Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondary,
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: profilePicSize,
                height: profilePicSize,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: components.ImageWithPlaceholder(
                    image: currentUserPhoto,
                    width: profilePicSize,
                    height: profilePicSize),
              ),
              Column(
                children: [
                  Text(
                    currentUserDisplayName.maybeHandleOverflow(
                      maxChars: 25,
                      replacement: '…',
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    currentUserEmail.maybeHandleOverflow(
                      maxChars: 35,
                      replacement: '…',
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).alternate,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ].divide(SizedBox(height: 10)),
          ),
        ),
      ),
    );
  }
}

class DrawerSlots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        DrawerSlot(
          title: 'Notificações',
          icon: Icons.notifications,
          navigate: () {
            context.pushNamed('Notifications');
          },
        ),
        DrawerSlot(
          title: 'Inserir Anúncio',
          icon: Icons.add_circle_outline,
          navigate: () {
            context.pushNamed('CreateAnuncio');
          },
        ),
        DrawerSlot(
          title: 'Gerenciar Anúncios',
          icon: Icons.book_outlined,
          navigate: () {
            context.pushNamed('BazarSolidario');
          },
        ),
        DrawerSlot(
          title: 'Histórico de Vendas',
          icon: Icons.sell_outlined,
          navigate: () {
            context.pushNamed('BazarSolidario');
          },
        ),
        DrawerSlot(
          title: 'Histórico de Compras',
          icon: Icons.paid_outlined,
          navigate: () {
            context.pushNamed('BazarSolidario');
          },
        ),
      ].divide(SizedBox(height: 35)),
    );
  }
}

class DrawerSlot extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback navigate;

  const DrawerSlot({
    required this.title,
    required this.icon,
    required this.navigate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: navigate,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          title == 'Notificações'
              ? components.NotificationBadge(
            mainColor: FlutterFlowTheme.of(context).primaryText,
            secondaryColor: FlutterFlowTheme.of(context).tertiary,
          )
              : Icon(
            icon,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30,
          ),
          Text(
            title,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Readex Pro',
              fontSize: 15,
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ].divide(SizedBox(width: 35)),
      ),
    );
  }
}
