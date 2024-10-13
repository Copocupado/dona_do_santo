import 'package:auto_size_text/auto_size_text.dart';
import 'package:dona_do_santo/auth/firebase_auth/auth_util.dart';
import 'package:dona_do_santo/backend/schema/notifications_record.dart';
import 'package:dona_do_santo/backend/schema/pedidos_record.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../backend/backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/nav/serialization_util.dart';
import '../reverse/reverse/reverse_widget.dart';

class NotificationsWidget extends StatelessWidget {
  NotificationsWidget({super.key});
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
          primary: true,
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const SizedBox(height: 150),
                    StreamBuilder<List<NotificationsRecord>>(
                      stream: FFAppState().storeNotifications(
                        uniqueQueryKey: currentUserReference?.id,
                        requestFn: () => queryNotificationsRecord(
                          queryBuilder: (notificationsRecord) =>
                              notificationsRecord
                                  .orderBy('created_time', descending: true)
                                  .where(
                                'belongs_to',
                                isEqualTo: currentUserReference,
                              ),
                        ),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const components.LoadingIcon();
                        }
                        List<NotificationsRecord> list = snapshot.data!;
                        return snapshot.data!.isEmpty
                            ? SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height - 250, child: const components.DataNotFound(title: 'Nenhuma notificação encontrada', icon: Icons.notifications_off))
                            : ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const Separator(),
                          itemBuilder: (context, listViewIndex) {
                            return Notification(
                              notification: list[listViewIndex],
                              visibilityDetectorKey: listViewIndex,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: components.AppBarWithGoBackArrow(
                  mainColor: FlutterFlowTheme.of(context).primaryText,
                  secondaryColor: FlutterFlowTheme.of(context).tertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Notification extends StatelessWidget {
  final int visibilityDetectorKey;
  final NotificationsRecord notification;

  const Notification({
    super.key,
    required this.visibilityDetectorKey,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    double notificationWidth = MediaQuery.of(context).size.width;
    const double notificationHeight = 100;

    return InkWell(
      onTap: () {
        if(notification is DocumentReference) {
          context.pushNamed(
            notification.dynamicRoute,
            queryParameters: {
              getParamName(notification.paramsForRoute) : serializeParam(
                notification.paramsForRoute,
                ParamType.DocumentReference,
              ),
            }.withoutNulls,
          );
        } else {
          context.pushNamed(
            notification.dynamicRoute,
            queryParameters: {
              getParamName(notification.paramsForRoute['reference']) : serializeParam(
                notification.paramsForRoute,
                ParamType.Document,
              ),
            }.withoutNulls,
            extra: <String, dynamic>{
              getParamName(notification.paramsForRoute['reference']): PedidosRecord.getDocumentFromData(notification.paramsForRoute, notification.paramsForRoute['reference'])
            },
          );
        }
      },
      child: VisibilityDetector(
        key: Key('visibility-detector-$visibilityDetectorKey'),
        onVisibilityChanged: (visibilityInfo) {
          if (!notification.viewed) {
            try {
              notification.reference
                  .update(createNotificationsRecordData(viewed: true));
            } catch (e) {
              print(e);
            } finally {
              print('updated record');
            }
          }
        },
        child: Column(
          children: [
            SizedBox(
              width: notificationWidth,
              height: notificationHeight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: components.ImageWithPlaceholder(
                          image: notification.image,
                          width: 1,
                          height: notificationHeight,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    notification.title.maybeHandleOverflow(
                                      maxChars: 29,
                                      replacement: '…',
                                    ),
                                    minFontSize: 12,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily: 'Readex Pro',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: AutoSizeText(
                                      dateTimeFormat(
                                        getCurrentTimestamp.day ==
                                            notification.createdTime?.day
                                            ? 'relative'
                                            : 'd/M',
                                        notification.createdTime,
                                        locale: FFLocalizations.of(context)
                                            .languageCode,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      maxFontSize: 10,
                                      minFontSize: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Readex Pro',
                                      ),
                                    ),
                                  ),
                                ].divide(const SizedBox(width: 5)),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  notification.description,
                                  minFontSize: 8,
                                  maxFontSize: 10,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ].divide(const SizedBox(height: 10)),
                        ),
                      ),
                    )
                  ].divide(const SizedBox(width: 10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Separator extends StatelessWidget {
  const Separator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Colors.black),
    );
  }
}

String getParamName(DocumentReference? docRef){
  String path = docRef!.path;

  if(path.startsWith('solicitacoes')){
    return 'solicitacao';
  }
  if(path.startsWith('reverse_store')){
    return 'reverseStoreDoc';
  }
  if(path.startsWith('novidades')){
    return 'novidade';
  }
  if(path.startsWith('pedidos')){
    return 'pedido';
  }
  else{
    return 'paramsForRoute';
  }
}
