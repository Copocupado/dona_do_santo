import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto/crypto.dart';
import 'package:dona_do_santo/auth/firebase_auth/auth_util.dart';
import 'package:dona_do_santo/backend/schema/pedidos_record.dart';
import 'package:dona_do_santo/backend/schema/structs/index.dart';
import 'package:dona_do_santo/custom_code/actions/convertDoubleToString.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_theme.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;
import 'package:dona_do_santo/pages/home_page/home_page_widget.dart' as homePage;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend/schema/reverse_store_record.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import 'checkout_model.dart';

class Checkout extends StatelessWidget {

  final List<ReverseStoreRecord> itemsList;

  final String address;
  final String image;
  final String formattedAddress;

  final String cpf;


  const Checkout({
    super.key,
    required this.itemsList,
    required this.address,
    required this.image,
    required this.formattedAddress,
    required this.cpf,
  });

  @override
  Widget build(BuildContext context) {

    double total = 0;
    for(var item in itemsList){
      total += item.price;
    }
    final double fee = total * (components.ConfigClass.fee / 100);
    final totalToPay = total + fee;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    components.AppBarWithGoBackArrow(
                      mainColor: FlutterFlowTheme.of(context).primaryText,
                      secondaryColor: FlutterFlowTheme.of(context).tertiary,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Section(
                            title: 'Produtos',
                            icon: FontAwesomeIcons.shirtsinbulk,
                            children: [
                              CheckoutListBuilder<ReverseStoreRecord>(
                                items: itemsList,
                                itemBuilder: (item) => SizedBox(
                                  height: 70,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: components.ImageWithPlaceholder(image: item.image),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
                                              overflow: TextOverflow.ellipsis,
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Readex Pro',
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              'Tamanho: ${item.size}',
                                              overflow: TextOverflow.ellipsis,
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Readex Pro',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        ShippingData(
                          context: context,
                          child: ShippingSection(itemsList: itemsList, formattedAddress: formattedAddress),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Section(
                            title: 'Pagamento',
                            icon: FontAwesomeIcons.moneyBill,
                            children: [
                              CheckoutListBuilder<ReverseStoreRecord>(
                                items: itemsList,
                                itemBuilder: (item) => SizedBox(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 17,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'R\$${convertDoubleToString(item.price)}',
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 17,
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                        ),
                                      ),
                                    ].divide(const SizedBox(width: 12)),
                                  ),
                                ),
                              ),
                              InfoRow(contentLeft: 'Taxas + Frete: ', contentRight: 'R\$${convertDoubleToString(fee)}'),
                              const InfoRow(contentLeft: 'Método de pagamento: ', contentRight: 'Pix'),
                              Divider(color: FlutterFlowTheme.of(context).primaryText),
                              InfoRow(contentLeft: 'Você pagará', contentRight: 'R\$${convertDoubleToString(totalToPay)}'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Section(
                            title: 'Dados Adicionais',
                            icon: FontAwesomeIcons.userGroup,
                            children: [
                              InfoRow(contentLeft: 'Comprador:', contentRight: currentUserDisplayName),
                              InfoRow(contentLeft: 'Email:', contentRight: currentUserEmail),
                              InfoRow(contentLeft: 'CPF:', contentRight: cpf),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Após a compra dos produtos, você terá 7 dias para retorná-los. Sua compra é segura!",
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              fontSize: 14,
                              color: FlutterFlowTheme.of(context).warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryText,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(36),
                  child: FFButtonWidget(
                    onPressed: () async {

                      final List<String> externalReferences = itemsList.map((item) => generateCustomId(currentUserReference!.id, item.reference.id)).toList();
                      final List<String> itemNames = itemsList.map((item) => item.title).toList();

                      print(externalReferences);

                      try {
                        final qrCodeData = await createPixQRCode(
                          transactionAmount: 0.01,//double.parse(totalToPay.toStringAsFixed(2)),
                          description: 'Pagamento dos produtos ${itemNames.join(', ')}',
                          paymentMethodId: 'pix',
                          email: currentUserEmail,
                          identificationType: 'CPF',
                          number: cpf.replaceAll('.', '').replaceAll('-', ''),
                          firstName: currentUserDisplayName.split(' ')[0],
                          lastName: currentUserDisplayName.split(' ')[currentUserDisplayName.split(' ').length - 1],
                          externalReference: externalReferences.join(','),
                        );

                        final String qrCode = qrCodeData['point_of_interaction']['transaction_data']['qr_code'];

                        for(var item in itemsList) {
                          await PedidosRecord.collection.doc(
                              generateCustomId(currentUserReference!.id, item.reference.id)).set(
                            createPedidosRecordData(
                              buyer: currentUserReference,
                              buyerEmail: currentUserEmail,
                              buyerStore: StoreStruct(
                                address: address,
                                storeImage: image,
                                formattedAddress: formattedAddress,
                              ),
                              companyShare: item.price * (components.ConfigClass.fee / 100),
                              createdTime: DateTime.now(),
                              estimatedArrivalTime: ShippingWidget.calculateShippingTime(
                                  item.store.formattedAddress, formattedAddress),
                              expirationTime: ShippingWidget.addOnlyBussinessDays(
                                  DateTime.now(), components.ConfigClass.dispatchProductTime),
                              itemImage: item.image,
                              itemTitle: item.title,
                              itemToPay: item.reference,
                              paymentStatus: "Não pago",
                              paymentValue: item.price * (1 + (components.ConfigClass.fee / 100)),
                              vendor: item.createdBy,
                              vendorEmail: item.createdByEmail,
                              vendorStore: item.store,
                              qrCode: qrCode,
                            ),
                          );
                        }

                        if(context.mounted){
                          context.pushNamed('QrCode',
                            queryParameters: {
                              'qrcode' : serializeParam(
                                qrCode,
                                ParamType.String,
                                isList: false,
                              ),
                            }.withoutNulls,
                          );
                        }

                      } catch (error) {
                        print('Error: $error');
                      }
                    },
                    text: 'Confirmar Compra',
                    icon: const Icon(
                      Icons.check_circle,
                      size: 24,
                    ),
                    options: FFButtonOptions(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).success,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String generateCustomId(String buyerId, String itemId) {
    String combined = buyerId + itemId;

    var bytes = utf8.encode(combined);
    var digest = sha256.convert(bytes);

    String hexString = digest.toString().toUpperCase();

    return hexString.substring(0, 6);
  }
}

class InfoRow extends StatelessWidget {
  final String contentLeft;
  final String contentRight;

  const InfoRow({
    super.key,
    required this.contentLeft,
    required this.contentRight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          contentLeft,
          textAlign: TextAlign.left,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Readex Pro',
            fontSize: 17,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
        ),
        Text(
          contentRight,
          textAlign: TextAlign.left,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Readex Pro',
            fontSize: 17,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
        ),
      ],
    );
  }
}

class ShippingWidget extends StatelessWidget {
  final String itemName;
  final String vendorAddress;
  final String buyerAddress;
  final int currentShippingStatus;

  const ShippingWidget({
    super.key,
    required this.itemName,
    required this.currentShippingStatus,
    required this.vendorAddress,
    required this.buyerAddress
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        homePage.HeaderTexts(title: itemName, icon: FontAwesomeIcons.car),
        Expanded(
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildShippingSteps(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: buildContainerSteps(),
                ),
              ),
            ].divide(const SizedBox(width: 12)),
          ),
        ),
        Text(
          'Tempo estimado de chegada: ${dateTimeFormat('MMMMEEEEd', calculateShippingTime(vendorAddress, buyerAddress),  locale: FFLocalizations.of(context).languageCode)}',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Readex Pro',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: FlutterFlowTheme.of(context).secondaryText
          ),
        ),
      ],
    );
  }
  List<Widget> buildContainerSteps() {
    List<Widget> steps = [];
    for(int i = 0; i < components.ConfigClass.shippingList.length; i++){
      steps.add(ShippingContainer(activationStatus: (currentShippingStatus - i), index: i));
    }
    return steps;
  }

  List<Widget> buildShippingSteps() {
    List<Widget> steps = [];

    for (int i = 0; i < components.ConfigClass.shippingList.length; i++) {
      steps.add(ShippingDot(activationStatus: (currentShippingStatus - i)));

      // Add a ShippingLine if it's not the last step
      if (i < components.ConfigClass.shippingList.length - 1) {
        steps.add(ShippingLine(activationStatus: (currentShippingStatus - i)));
      }
    }
    return steps;
  }

  static DateTime calculateShippingTime(vendorAddress, buyerAddress){
    DateTime newDate = DateTime.now();
    newDate = addOnlyBussinessDays(newDate, 3);
    if(vendorAddress != buyerAddress) {
      newDate = addOnlyBussinessDays(newDate, 5);
    }
    return newDate;
  }

  static DateTime addOnlyBussinessDays(DateTime dateBefore, int daysToAdd){
    int counter = 0;
    while (counter < daysToAdd){
      dateBefore = dateBefore.add(const Duration(days: 1));
      if(dateBefore.weekday <= 5){
        counter++;
      }
    }
    return dateBefore;
  }
}

class ShippingSection extends StatelessWidget {
  final List<ReverseStoreRecord> itemsList;
  final String formattedAddress;

  const ShippingSection({
    super.key,
    required this.itemsList,
    required this.formattedAddress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ShippingData.of(context)!.containerHeight * components.ConfigClass.shippingList.length + 120,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: itemsList.length,
        itemBuilder: (context, index) {
          ShippingData.of(context)!.vendorStore = itemsList[index].store.formattedAddress;
          ShippingData.of(context)?.buyerStore = formattedAddress;
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ShippingWidget(itemName: itemsList[index].title, currentShippingStatus: -1, vendorAddress: itemsList[index].store.formattedAddress, buyerAddress:formattedAddress),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  List<Widget> buildContainerSteps() {
    List<Widget> steps = [];
    for(int i = 0; i < components.ConfigClass.shippingList.length; i++){
      steps.add(ShippingContainer(activationStatus: (-1 - i), index: i));
    }
    return steps;
  }

  List<Widget> buildShippingSteps() {
    List<Widget> steps = [];

    for (int i = 0; i < components.ConfigClass.shippingList.length; i++) {
      steps.add(ShippingDot(activationStatus: (-1 - i)));

      // Add a ShippingLine if it's not the last step
      if (i < components.ConfigClass.shippingList.length - 1) {
        steps.add(ShippingLine(activationStatus: (-1 - i)));
      }
    }
    return steps;
  }
}

class CheckoutListBuilder<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T) itemBuilder;

  const CheckoutListBuilder({
    super.key,
    required this.items,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(items[index]);
      },
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const Section({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: homePage.HeaderTexts(title: title, icon: icon),
            ),
            ...children,
          ].divide(const SizedBox(height: 12)),
        ),
      ),
    );
  }
}

class ShippingDot extends StatelessWidget {
  final int activationStatus;

  const ShippingDot({
    super.key,
    required this.activationStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ShippingData.of(context)!.dotSize,
      height: ShippingData.of(context)!.dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ShippingData.of(context)!.getWidgetColor(activationStatus),
      ),
    );
  }
}

class ShippingLine extends StatelessWidget {
  final int activationStatus;

  const ShippingLine({
    super.key,
    required this.activationStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ShippingData.of(context)!.lineWidth,
      height: ShippingData.of(context)!.lineHeight,
      decoration: BoxDecoration(
        color: ShippingData.of(context)!.getWidgetColor(activationStatus),
      ),
    );
  }
}

class ShippingContainer extends StatelessWidget {
  final int activationStatus;
  final int index;

  const ShippingContainer({
    super.key,
    required this.activationStatus,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {

    final Color widgetColor = ShippingData.of(context)!.getWidgetColor(activationStatus);

    return SizedBox(
      height: ShippingData.of(context)!.containerHeight,
      child: Row(
        children: [
          Container(
            width: ShippingData.of(context)!.containerHeight * 0.6,
            height: ShippingData.of(context)!.containerHeight * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widgetColor,
            ),
            child: Icon(
              getIcon(),
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  components.ConfigClass.shippingList[index],
                  minFontSize: 12,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: widgetColor,
                  ),
                ),
                AutoSizeText(
                  getDescription(context),
                  minFontSize: 10,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    fontSize: 12,
                    color: widgetColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ].divide(const SizedBox(width: 12)),
      ),
    );
  }
  IconData getIcon(){
    switch(index){
      case 0:
        return FontAwesomeIcons.handshake;
      case 1:
        return FontAwesomeIcons.truck;
      case 2:
        return FontAwesomeIcons.truckFast;
      case 3:
        return FontAwesomeIcons.store;
      default:
        return FontAwesomeIcons.boxOpen;
    }
  }

  String getDescription(BuildContext context){
    switch(index){
      case 0:
        return 'O vendedor tem ${components.ConfigClass.dispatchProductTime} dias úteis para despachar o produto';
      case 1:
        return "O vendedor despachou o seu  produto na loja ${ShippingData.of(context)!.vendorStore}";
      case 2:
        return "Seu pedido encontra-se em trânsito";
      case 3:
        return "Seu pedido já pode ser retirado na loja: ${ShippingData.of(context)!.buyerStore!}";
      default:
        return "Seu pedido foi entregue, esperamos que tenha gostado de comprar conosco";
    }
  }
}

class ShippingData extends InheritedWidget {
  final BuildContext context;

  String? _vendorStore;
  String? _buyerStore;


  ShippingData({
    super.key,
    required super.child,
    required this.context,
  });

  // Getter to retrieve the value
  String? get vendorStore => _vendorStore;

  // Setter to modify the value
  set vendorStore(String? value) => _vendorStore = value;

  String? get buyerStore => _buyerStore;
  set buyerStore(String? value) => _buyerStore = value;

  Color get beforeColor => FlutterFlowTheme.of(context).success;
  Color get duringColor => FlutterFlowTheme.of(context).warning;
  Color get afterColor => FlutterFlowTheme.of(context).secondaryText;

  double get containerHeight => 100;

  double get dotSize => containerHeight * 0.2;

  double get lineWidth => containerHeight * 0.04;
  double get lineHeight => ((containerHeight * (components.ConfigClass.shippingList.length - 1 )) - (dotSize * components.ConfigClass.shippingList.length)) / (components.ConfigClass.shippingList.length - 1);

  static ShippingData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShippingData>();
  }

  Color getWidgetColor(int activationStatus) {
    if(activationStatus < 0) return afterColor;
    if(activationStatus > 0) return beforeColor;
    return duringColor;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}