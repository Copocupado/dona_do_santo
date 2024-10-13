import 'package:dona_do_santo/backend/backend.dart';
import 'package:dona_do_santo/backend/schema/reverse_store_record.dart';
import 'package:dona_do_santo/components/reverse_builder.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import '../../../../auth/firebase_auth/auth_util.dart';
import '../../../../flutter_flow/flutter_flow_button_tabbar.dart';
import '../../../../flutter_flow/flutter_flow_drop_down.dart';
import '../../../../flutter_flow/flutter_flow_theme.dart';
import '../../../../flutter_flow/form_field_controller.dart';

class GerenciarAnunciosWidget extends StatefulWidget {
 const GerenciarAnunciosWidget({super.key});

 @override
 State<GerenciarAnunciosWidget> createState() =>
     GerenciarAnunciosWidgetState();
}

class GerenciarAnunciosWidgetState extends State<GerenciarAnunciosWidget>
    with SingleTickerProviderStateMixin {
 late TabController tabController;
 final scaffoldKey = GlobalKey<ScaffoldState>();

 @override
 void initState() {
  super.initState();
  tabController = TabController(length: 2, vsync: this);
 }

 @override
 void dispose() {
  super.dispose();
  tabController.dispose();
 }

 @override
 Widget build(BuildContext context) {
  return Scaffold(
   key: scaffoldKey,
   backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
   body: SafeArea(
    top: true,
    child: Padding(
     padding: const EdgeInsets.all(12),
     child: SingleChildScrollView(
      child: Stack(
       children: [
        SizedBox(
         width: MediaQuery.of(context).size.width,
         height: MediaQuery.of(context).size.height - 55,
         child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
           const SizedBox(height: 150),
           FlutterFlowButtonTabBar(
            useToggleButtonStyle: true,
            labelStyle:
            FlutterFlowTheme.of(context).titleMedium.override(
             fontFamily: 'Readex Pro',
             fontSize: 18,
             letterSpacing: 0,
            ),
            unselectedLabelStyle: const TextStyle(),
            labelColor: FlutterFlowTheme.of(context).primaryText,
            unselectedLabelColor:
            FlutterFlowTheme.of(context).primaryBackground,
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            unselectedBackgroundColor:
            FlutterFlowTheme.of(context).secondaryText,
            borderColor: FlutterFlowTheme.of(context).secondary,
            unselectedBorderColor:
            FlutterFlowTheme.of(context).secondary,
            borderWidth: 2,
            borderRadius: 8,
            labelPadding:
            const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
            buttonMargin:
            const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
            //padding: const EdgeInsets.all(12),
            tabs: const [
             Tab(
              text: 'Anúncios',
             ),
             Tab(
              text: 'Solicitações',
             ),
            ],
            controller: tabController,
           ),
           const SizedBox(height: 50),
           Expanded(
            child: TabBarView(
             controller: tabController,
             children: const [
              TabViewLayout(collectionName: 'reverse_store'),
              TabViewLayout(collectionName: 'solicitacoes'),
             ],
            ),
           ),
          ],
         ),
        ),
        components.AppBarWithGoBackArrow(
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
}

class TabViewLayout extends StatefulWidget {
 final String collectionName;

 const TabViewLayout({
  super.key,
  required this.collectionName,
 });

 @override
 State<TabViewLayout> createState() => TabViewLayoutState();
}

class TabViewLayoutState extends State<TabViewLayout> {
 String dropDownValue = "Mais Atuais";
 FormFieldController<String>? dropDownValueController =
 FormFieldController<String>('Mais Atuais');
 List<String> optionList = ['Mais Atuais', 'Mais Antigos', 'Ordem Alfabética'];

 GeneralInfoList<ReverseStoreRecord> maisAtualReverse = GeneralInfoList();
 GeneralInfoList<ReverseStoreRecord> maisAntigoReverse = GeneralInfoList();
 GeneralInfoList<ReverseStoreRecord> ordemAlfabeticaReverse =
 GeneralInfoList();

 GeneralInfoList<SolicitacoesRecord> maisAtualSolicitacao = GeneralInfoList();
 GeneralInfoList<SolicitacoesRecord> maisAntigoSolicitacao = GeneralInfoList();
 GeneralInfoList<SolicitacoesRecord> ordemAlfabeticaSolicitacao =
 GeneralInfoList();
 GeneralInfoList<SolicitacoesRecord> pendentesListSolicitacao =
 GeneralInfoList();
 GeneralInfoList<SolicitacoesRecord> negadosListSolicitacao =
 GeneralInfoList();

 GeneralInfoList<ReverseStoreRecord> mainListReverse = GeneralInfoList();
 GeneralInfoList<SolicitacoesRecord> mainListSolicitacao = GeneralInfoList();

 @override
 void initState() {
  super.initState();
  if (widget.collectionName == "solicitacoes") {
   optionList.addAll(['Pendentes', 'Negadas']);
  }
 }

 @override
 Widget build(BuildContext context) {
  return Column(
   children: [
    Row(
     mainAxisAlignment: MainAxisAlignment.end,
     children: [
      Expanded(
       flex: 5,
       child: Text(
        'Ordenar por:',
        textAlign: TextAlign.end,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
         fontFamily: 'Readex Pro',
         fontSize: 13,
        ),
       ),
      ),
      Expanded(
       flex: 3,
       child: FlutterFlowDropDown<String>(
        controller: dropDownValueController,
        options: optionList,
        onChanged: (val) {
         switch (val) {
          case 'Mais Antigos':
           widget.collectionName == 'reverse_store' ? orderByMaisAntigo(maisAntigoReverse, mainListReverse) : orderByMaisAntigo(maisAntigoSolicitacao, mainListSolicitacao);
           return;

          case 'Ordem Alfabética':
           widget.collectionName == 'reverse_store' ? orderByAlfabeticOrder(ordemAlfabeticaReverse, mainListReverse) : orderByAlfabeticOrder(ordemAlfabeticaSolicitacao, mainListSolicitacao);
           return;

          case 'Pendentes':
           orderByPendentes();
           return;

          case 'Negadas':
           orderByNegadas();
           return;

          default:
           widget.collectionName == 'reverse_store' ? orderByMaisAtual(maisAtualReverse, mainListReverse) : orderByMaisAtual(maisAtualSolicitacao, mainListSolicitacao);
           return;
         }
        },
        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
         fontFamily: 'Readex Pro',
         fontSize: 10,
         color: FlutterFlowTheme.of(context).primaryText,
        ),
        icon: Icon(
         Icons.keyboard_arrow_down_rounded,
         color: FlutterFlowTheme.of(context).primaryText,
         size: 16,
        ),
        fillColor: FlutterFlowTheme.of(context).secondary,
        elevation: 2,
        borderColor: Colors.transparent,
        borderWidth: 2,
        borderRadius: 8,
        margin: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
        hidesUnderline: true,
        isOverButton: true,
        isSearchable: false,
        isMultiSelect: false,
       ),
      ),
     ].divide(const SizedBox(width: 10)),
    ),
    widget.collectionName == 'reverse_store'
        ? StreamBuilder<List<ReverseStoreRecord>>(
     stream: FFAppState().reverseStoreRequest(
      uniqueQueryKey: currentUserReference?.id,
      requestFn: () => queryReverseStoreRecord(
       queryBuilder: (reverseStoreRecord) => reverseStoreRecord
           .orderBy('created_time', descending: true)
           .where(
            'created_by',
            isEqualTo: currentUserReference,
           )
           .where(
            'sold',
            isEqualTo: false,
           ),
      ),
     ),
     builder: (context, snapshot) {
      if (!snapshot.hasData) {
       return components.LoadingIcon();
      }
      if (mainListReverse.list == null) {
       mainListReverse.list = List.from(snapshot.data!);
       maisAtualReverse.list = List.from(snapshot.data!);
      }
      return snapshot.data!.isEmpty
          ? const Expanded(child: components.DataNotFound(
          title: 'Nenhum anúncio encontrado'))
          : Expanded(child: ReverseBuilder(list: mainListReverse.list!));
     },
    )
        : StreamBuilder<List<SolicitacoesRecord>>(
     stream: FFAppState().storeRequests(
      uniqueQueryKey: currentUserReference?.id,
      requestFn: () => querySolicitacoesRecord(
       queryBuilder: (solicitacoesRecord) => solicitacoesRecord
           .orderBy('created_time', descending: true)
           .where(
        'created_by',
        isEqualTo: currentUserReference,
       ),
      ),
     ),
     builder: (context, snapshot) {
      if (!snapshot.hasData) {
       return const components.LoadingIcon();
      }
      if (mainListSolicitacao.list == null) {
       mainListSolicitacao.list = List.from(snapshot.data!);
       maisAtualSolicitacao.list = List.from(snapshot.data!);
      }
      return snapshot.data!.isEmpty
          ? const Expanded(child: components.DataNotFound(
          title: 'Nenhuma solicitação encontrada'))
          : Expanded(child: ReverseBuilder(list: mainListSolicitacao.list!));
     },
    ),
   ].divide(const SizedBox(height: 20)),
  );
 }

 void orderByMaisAntigo(
     GeneralInfoList maisAntigoList, GeneralInfoList mainList) {
  setState(() {
   maisAntigoList.list ??= mainList.list!.reversed.toList();
   mainList.list = maisAntigoList.list;
  });
 }

 void orderByMaisAtual(
     GeneralInfoList maisAtualList, GeneralInfoList mainList) {
  setState(() {
   mainList.list = maisAtualList.list!;
  });
 }

 void orderByAlfabeticOrder(
     GeneralInfoList ordemAlfabeticaList, GeneralInfoList mainList) {
  setState(() {
   if (ordemAlfabeticaList is GeneralInfoList<ReverseStoreRecord>) {
    ordemAlfabeticaList.list ??=
    List<ReverseStoreRecord>.from(mainList.list!);
   } else {
    ordemAlfabeticaList.list ??=
    List<SolicitacoesRecord>.from(mainList.list!);
   }

   ordemAlfabeticaList.list!.sort((a, b) {
    return a.title.toLowerCase().compareTo(b.title.toLowerCase());
   });

   // Update the mainList with the sorted list
   mainList.list = ordemAlfabeticaList.list;
  });
 }

 void orderByPendentes(){
  pendentesListSolicitacao.list ??=
  List<SolicitacoesRecord>.from(mainListSolicitacao.list!);

  pendentesListSolicitacao.list!.sort((a, b) {
   if (a.negated == b.negated) {
    return 0;
   }
   return a.negated ? 1 : -1;
  });
  setState(() {
   mainListSolicitacao.list = pendentesListSolicitacao.list;
  });
 }
 void orderByNegadas(){
  negadosListSolicitacao.list ??=
  List<SolicitacoesRecord>.from(mainListSolicitacao.list!);

  negadosListSolicitacao.list!.sort((a, b) {
   if (a.negated == b.negated) {
    return 0;
   }
   return a.negated ? -1 : 1;
  });
  setState(() {
   mainListSolicitacao.list = negadosListSolicitacao.list;
  });
 }
}

class GeneralInfoList<T extends GeneralInfo> {
 List<T>? list;

 GeneralInfoList({this.list});
}


