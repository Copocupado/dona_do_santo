import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dona_do_santo/auth/firebase_auth/auth_util.dart';
import 'package:dona_do_santo/backend/schema/pedidos_record.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_theme.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;
import 'package:dona_do_santo/custom_code/widgets/home_page.dart' as homePage;
import 'package:url_launcher/url_launcher.dart';

import '../../../app_state.dart';
import '../../../custom_code/actions/convertDoubleToString.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../checkout/checkout.dart';

class Order extends StatelessWidget {
  final DocumentReference? orderRef;

  const Order({
    super.key,
    required this.orderRef,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            components.AppBarWithGoBackArrow(
              mainColor: FlutterFlowTheme.of(context).primaryText,
              secondaryColor: FlutterFlowTheme.of(context).tertiary,
            ),
            Expanded(
              child: StreamBuilder<PedidosRecord>(
                stream: FFAppState().pedidoItem(
                  uniqueQueryKey: orderRef!.id,
                  requestFn: () =>
                      PedidosRecord.getDocument(orderRef!),
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const components.LoadingIcon();
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(
                                "Código: ${snapshot.data!.reference.id}",
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                "Este código deverá ser informado na loja para validarmos a autenticidade da compra, não o compartilhe com ninguém",
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.w300,
                                  color: FlutterFlowTheme.of(context).error,
                                  fontSize: 12,
                                ),
                              ),
                            ].divide(const SizedBox(height: 12)),
                          )
                        ),
                        if(snapshot.data!.deliveryStatus == 'Entregue')
                          Column(
                            children: [
                              Divider(color: FlutterFlowTheme.of(context).primaryText, thickness: 1),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  'Pedido entregue dia: ${dateTimeFormat(
                                    "d/M",
                                    snapshot.data!.deliveryDate,
                                    locale: FFLocalizations.of(context).languageCode,
                                  )}',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    fontWeight: FontWeight.w500,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Divider(color: FlutterFlowTheme.of(context).primaryText, thickness: 1),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 130,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: components.ImageWithPlaceholder(image: snapshot.data!.itemImage),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: AutoSizeText(
                                          snapshot.data!.itemTitle,
                                          minFontSize: 12,
                                          textAlign: TextAlign.left,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Readex Pro',
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: AutoSizeText(
                                          'R\$${convertDoubleToString(snapshot.data!.paymentValue)}',
                                          minFontSize: 12,
                                          textAlign: TextAlign.left,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Readex Pro',
                                            color: FlutterFlowTheme.of(context).primaryText,
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
                        Divider(color: FlutterFlowTheme.of(context).primaryText, thickness: 1),
                        ShippingData(
                          context: context,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: ShippingSection(pedido: snapshot.data!),
                          ),
                        ),
                        Divider(color: FlutterFlowTheme.of(context).primaryText, thickness: 1),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              if(shouldDisplayRefundButton(snapshot.data!))
                                FFButtonWidget(
                                  onPressed: () async {
                                    try {
                                      final encodedMessage = Uri.encodeComponent(
                                          'Olá, me chamo $currentUserDisplayName, sou o ${snapshot.data!.buyer == currentUserReference ? 'comprador' : 'vendedor'} do pedido ${snapshot.data!.reference.id} e vim pedir o cancelamento da compra');
                                      final whatsappUrl = Uri.parse(
                                          'https://wa.me/${components.ConfigClass.staffNumber}?text=$encodedMessage');

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
                                  text: 'Cancelar compra',
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    size: 24,
                                  ),
                                  options: FFButtonOptions(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                    color: FlutterFlowTheme.of(context).error,
                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              Text(
                                'Como o ${snapshot.data!.buyer == currentUserReference ? 'comprador, você tem até 7 dias após a entrega para cancelar a compra' : "vendedor, você pode cancelar a compra até despachar o produto na loja combinada"}',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.w500,
                                  color: FlutterFlowTheme.of(context).error,
                                  fontSize: 12,
                                ),
                              ),
                            ].divide(const SizedBox(height: 12)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool shouldDisplayRefundButton(PedidosRecord pedido){
    if(pedido.paymentStatus != 'Pago') return false;
    if (pedido.buyer != currentUserReference && pedido.deliveryStatus != 'Com o vendedor') {
      return false;
    }
    return true;
  }
}

class ShippingSection extends StatelessWidget {
  final PedidosRecord pedido;

  const ShippingSection({
    super.key,
    required this.pedido,
  });

  @override
  Widget build(BuildContext context) {
    ShippingData.of(context)?.buyerStore = pedido.buyerStore.formattedAddress;
    ShippingData.of(context)?.vendorStore = pedido.vendorStore.formattedAddress;
    return SizedBox(
      height: ShippingData.of(context)!.containerHeight * components.ConfigClass.shippingList.length + 120,
      child: ShippingWidget(itemName: pedido.itemTitle, currentShippingStatus: getShippingStatus(), vendorAddress: pedido.vendorStore.formattedAddress, buyerAddress: pedido.buyerStore.formattedAddress),
    );
  }
  int getShippingStatus(){
    if(pedido.deliveryStatus == "Entregue") return 5;
    for(int i = 0; i < components.ConfigClass.shippingList.length; i++){
      if(components.ConfigClass.shippingList[i] == pedido.deliveryStatus){
        return i;
      }
    }
    return -1;
  }
}