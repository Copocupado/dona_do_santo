import 'package:dona_do_santo/flutter_flow/flutter_flow_theme.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;
import 'package:dona_do_santo/custom_code/widgets/home_page.dart' as homePage;
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../backend/schema/reverse_store_record.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import '../options/create_anuncio/create_anuncio_widget.dart';

class ExtraDetails extends StatefulWidget {

  final List<ReverseStoreRecord> itemsList;

  const ExtraDetails({
    super.key,
    required this.itemsList,
  });

  @override
  State<StatefulWidget> createState() => ExtraDetailsState();
}

class ExtraDetailsState extends State<ExtraDetails> {
  final GlobalKey<SearchableDropDownState> searchableDropDownKey = GlobalKey<SearchableDropDownState>();
  final formKey = GlobalKey<FormState>();

  final controller = MaskedTextController(mask: '000.000.000-00');
  final focusNode = FocusNode();

  bool canGoToCheckout = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SingleChildScrollView(
          child: Column(
            children: [
              components.AppBarWithGoBackArrow(
                mainColor: FlutterFlowTheme.of(context).primaryText,
                secondaryColor: FlutterFlowTheme.of(context).tertiary,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const homePage.HeaderTexts(title: "Endereço de entrega", icon: Icons.delivery_dining_outlined),
                    Text(
                      'Insira uma loja de retirada. Este será o endereço que você deverá buscar o produto quando estiver perto de você',
                      style: FlutterFlowTheme
                          .of(context)
                          .bodyMedium
                          .override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme
                            .of(context)
                            .secondaryText,
                        fontSize: 12,
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 270,
                      child: SearchableDropDown(
                        key: searchableDropDownKey,
                      ),
                    ),
                    const homePage.HeaderTexts(title: "CPF", icon: FontAwesomeIcons.addressCard),
                    Form(
                      key: formKey,
                      child: TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          'controller',
                          const Duration(milliseconds: 1),
                              () => setState(() => canGoToCheckout = formKey.currentState!.validate()),
                        ),
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Seu CPF...',
                          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily: 'Readex Pro',
                            letterSpacing: 0.0,
                          ),
                          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily: 'Readex Pro',
                            letterSpacing: 0.0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryText,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).secondary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0.0,
                        ),
                        cursorColor: FlutterFlowTheme.of(context).primaryText,
                        validator: (value) {
                          // CPF must be 11 digits (excluding mask characters)
                          if (value == null || value.isEmpty) {
                            return 'Digite seu CPF';
                          } else if (!_validateCPF(value)) {
                            return 'CPF inválido';
                          }
                          return null;
                        },
                      ),
                    ),
                    FFButtonWidget(
                      onPressed: canGoToCheckout ? () => context.pushNamed(
                        'Checkout',
                        queryParameters: {
                          'itemsList': serializeParam(
                            widget.itemsList,
                            ParamType.Document,
                            isList: true,
                          ),
                          'address' : serializeParam(
                            searchableDropDownKey
                                .currentState
                                ?.storesDict[searchableDropDownKey
                                .currentState?.selectedValue]
                                ?.address,
                            ParamType.String,
                            isList: false,
                          ),
                          'formattedAddress' : serializeParam(
                            searchableDropDownKey.currentState!.selectedValue,
                            ParamType.String,
                            isList: false,
                          ),
                          'image' : serializeParam(
                            searchableDropDownKey.currentState!.selectedValueImage,
                            ParamType.String,
                            isList: false,
                          ),
                          'cpf' : serializeParam(
                            controller.text,
                            ParamType.String,
                            isList: false,
                          ),
                        }.withoutNulls,
                        extra: <String, dynamic>{
                          'itemsList': widget.itemsList,
                        },
                      ) : null,
                      text: 'Check Out',
                      icon: const Icon(
                        Icons.shopping_cart_checkout,
                        size: 24,
                      ),
                      options: FFButtonOptions(
                        width: MediaQuery.sizeOf(context).width,
                        height: 70,
                        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).secondary,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                        ),
                        elevation: 10,
                        borderRadius: BorderRadius.circular(8),
                        disabledColor: FlutterFlowTheme.of(context).secondaryText,
                        disabledTextColor: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                    ),
                  ].divide(const SizedBox(height: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  bool _validateCPF(String value) {
    String cpf = value.replaceAll(RegExp(r'[\.\-]'), ''); // Remove mask
    if (cpf.length != 11) {
      return false;
    }
    // Additional logic to validate CPF digits can be added here.
    return true;
  }
}