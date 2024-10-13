import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:dona_do_santo/custom_code/actions/index.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:dona_do_santo/pages/home_page/home_page_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../pages/reverse/options/create_anuncio/create_anuncio_widget.dart';

class SearchFiltersDialog extends StatelessWidget{
  const SearchFiltersDialog({super.key});



  static String? gender;
  static String? category;
  static String? size;

  static String? minPrice;
  static String? maxPrice;

  static final minPriceKey = GlobalKey<PriceFilterState>();
  static final maxPriceKey = GlobalKey<PriceFilterState>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const HeaderTexts(title: 'Filtros', icon: Icons.filter_list),
                    FlutterFlowIconButton(
                      borderRadius: 12,
                      borderWidth: 1,
                      buttonSize: 40,
                      icon: Icon(
                        Icons.close,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24,
                      ),
                      onPressed: () async {
                          Navigator.pop(context, false);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                StepInformacoesPeca(
                  shouldDisplaAll: true,
                  genderInitialValue: SearchFiltersDialog.gender,
                  categoryInitialValue: SearchFiltersDialog.category,
                  sizeInitialValue: SearchFiltersDialog.size,
                ),
                const HeaderTexts(title: 'Preço:', icon: null),
                SizedBox(
                  height: 65,
                  child: Row(
                    children: [
                      PriceFilter(key: SearchFiltersDialog.minPriceKey, labelText: 'Mínimo'),
                      Expanded(child: Container(height: 1, decoration: returnBorder())),
                      PriceFilter(key: SearchFiltersDialog.maxPriceKey, labelText: "Máximo"),
                    ].divide(const SizedBox(width: 5)),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FFButtonWidget(
                    onPressed: () async {
                      if(minPriceKey.currentState!.validateForm() && maxPriceKey.currentState!.validateForm()){
                        Navigator.pop(context, true);
                        return;
                      }
                    },
                    text: 'Aplicar',
                    options: FFButtonOptions(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).secondary,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 14,
                        letterSpacing: 0,
                      ),
                      elevation: 3,
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ].divide(const SizedBox(height: 20)),
            ),
          ),
        ),
      ),
    );
  }
  bool validatePriceInput(String value){
    return PriceField.validationPattern.hasMatch(value);
  }
}


class PriceFilter extends StatefulWidget{

  const PriceFilter({
    super.key,
    required this.labelText,
  });

  final String labelText;

  @override
  State<StatefulWidget> createState() => PriceFilterState();

}

class PriceFilterState extends State<PriceFilter> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  Color? borderColor;

  @override
  void initState() {
    super.initState();
    controller.text = widget.labelText == 'Mínimo' ? SearchFiltersDialog.minPrice ?? '' : SearchFiltersDialog.maxPrice ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    focusNode.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            autofocus: false,
            obscureText: false,
            onChanged: (_) => EasyDebounce.debounce(
                'controller',
                const Duration(milliseconds: 1),
                    () => widget.labelText == 'Mínimo' ? SearchFiltersDialog.minPrice = controller.text : SearchFiltersDialog.maxPrice = controller.text,
            ),
            decoration: InputDecoration(
              isDense: true,
              labelText: widget.labelText,
              labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                fontFamily: 'Readex Pro',
                letterSpacing: 0,
              ),
              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                fontFamily: 'Readex Pro',
                letterSpacing: 0,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor ?? FlutterFlowTheme.of(context).alternate,
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
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Readex Pro',
              fontSize: 14,
              letterSpacing: 0,
            ),
            keyboardType: TextInputType.number,
          ),
          if(borderColor == FlutterFlowTheme.of(context).error)
            Text(
              'Preço inválido',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                color: FlutterFlowTheme.of(context).error,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }

  bool isPriceValid(){
    if(controller.text.isEmpty) return true;
    return PriceField.validationPattern.hasMatch(controller.text);
  }

  bool validateForm(){
    if(isPriceValid()){
      setState(() {
        borderColor = FlutterFlowTheme.of(context).alternate;
      });
      return true;
    }
    setState(() {
      borderColor = FlutterFlowTheme.of(context).error;
    });
    return false;
  }
}