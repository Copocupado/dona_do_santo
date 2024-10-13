import 'package:auto_size_text/auto_size_text.dart';
import 'package:dona_do_santo/backend/backend.dart';
import 'package:dona_do_santo/backend/schema/pedidos_record.dart';
import 'package:dona_do_santo/custom_code/actions/convertDoubleToString.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;
import 'package:dona_do_santo/custom_code/widgets/home_page.dart' as homePage;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../app_state.dart';
import '../../../../auth/firebase_auth/auth_util.dart';
import '../../../../flutter_flow/flutter_flow_util.dart';

class Historicos extends StatelessWidget {

  final bool shouldQueryAsBuyer;

  const Historicos({
    super.key,
    required this.shouldQueryAsBuyer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              components.AppBarWithGoBackArrow(
                mainColor: FlutterFlowTheme.of(context).primaryText,
                secondaryColor: FlutterFlowTheme.of(context).tertiary,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      homePage.HeaderTexts(title: 'Histórico de ${shouldQueryAsBuyer ? 'Compras' : 'Vendas'}', icon: shouldQueryAsBuyer ? FontAwesomeIcons.coins : Icons.sell),
                      Expanded(
                        child: StreamBuilder<List<PedidosRecord>>(
                          stream: FFAppState().pedidosRequest(
                            uniqueQueryKey: '${currentUserReference?.id}$shouldQueryAsBuyer',
                            requestFn: () => queryPedidosRecord(
                              queryBuilder: (queryPedidosRecord) {
                                final baseQuery = queryPedidosRecord
                                    .orderBy('created_time', descending: true);

                                // Check if the user should be queried as a buyer or vendor
                                if (shouldQueryAsBuyer) {
                                  return baseQuery.where('buyer', isEqualTo: currentUserReference);
                                } else {
                                  return baseQuery.where('vendor', isEqualTo: currentUserReference);
                                }
                              },
                            ),
                          ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const components.LoadingIcon();
                            }
                            if(snapshot.data!.isEmpty) {
                              return components.DataNotFound(title: 'Nenhuma ${shouldQueryAsBuyer ? 'compra' : 'venda'} encontrada', icon: FontAwesomeIcons.cartShopping);
                            }
                            return ListView.separated(
                              padding: const EdgeInsets.only(top: 24),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                return PedidoContainer(pedido: snapshot.data![index]);
                              },
                            );
                          },
                        ),
                      ),                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PedidoContainer extends StatelessWidget {
  final PedidosRecord pedido;

  const PedidoContainer({
    super.key,
    required this.pedido,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed('Order', queryParameters: {
        'orderRef' : serializeParam(
          pedido.reference,
          ParamType.DocumentReference,
        ),
      }.withoutNulls),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 160,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryText,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0xA2000000),
                offset: Offset(
                  0,
                  2,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateTimeFormat(
                        "relative",
                        pedido.createdTime,
                        locale: FFLocalizations.of(context).languageCode,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                    ),
                    Text(
                      pedido.paymentStatus,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: getPaymentColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: components.ImageWithPlaceholder(image: pedido.itemImage),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: AutoSizeText(
                                pedido.itemTitle,
                                minFontSize: 12,
                                textAlign: TextAlign.left,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Readex Pro',
                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Flexible(
                              child: AutoSizeText(
                                'R\$${convertDoubleToString(pedido.paymentValue)}',
                                minFontSize: 12,
                                textAlign: TextAlign.left,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Readex Pro',
                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ].divide(const SizedBox(height: 4)),
                        ),
                      ),
                    ].divide(const SizedBox(width: 12)),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
  Color? getPaymentColor(BuildContext context){
    switch(pedido.paymentStatus){
      case 'Não pago':
        return FlutterFlowTheme.of(context).error;
      case 'Pago':
        return FlutterFlowTheme.of(context).success;
      case 'Pago em definitivo':
        return FlutterFlowTheme.of(context).warning;
    }
    return null;
  }
}

