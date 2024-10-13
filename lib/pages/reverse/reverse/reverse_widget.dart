import 'package:algolia/algolia.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dona_do_santo/backend/schema/structs/algolia_doc_struct.dart';
import 'package:dona_do_santo/components/reverse_builder.dart';
import 'package:dona_do_santo/components/search_filters_dialog.dart';
import 'package:dona_do_santo/custom_code/actions/convertDoubleToString.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../custom_code/widgets/home_page.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReverseWidget extends StatefulWidget {
  const ReverseWidget({super.key});

  @override
  State<StatefulWidget> createState() => ReverseWidgetState();
}

class ReverseWidgetState extends State<ReverseWidget> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  static final FocusNode unfocusNode = FocusNode();
  final autoCompleteBoxFocusNode = FocusNode();
  static final autocompleteKey = GlobalKey<AutoCompleteBoxState>();
  static final reverseStoreSearchKey = GlobalKey<ReverseStoreSearchState>();
  static final selectedFiltersKey = GlobalKey<SelectedFiltersState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
      unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme
            .of(context)
            .primaryBackground,
        drawer: const Drawer(
          elevation: 16,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: ReverseDrawer(),
        ),
        body: SafeArea(
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
                      const HeaderTexts(
                          title: 'Reverse', icon: FontAwesomeIcons.rev),
                      Text(
                        'O reverse é uma ferramenta que intermedia a revenda de peças para outros clientes da loja, basta inserir os dados da peça e traze-lá para uma das nossas lojas e cuidaremos do resto.',
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 20,
                            borderWidth: 1,
                            buttonSize: 40,
                            fillColor: FlutterFlowTheme
                                .of(context)
                                .secondary,
                            icon: Icon(
                              Icons.filter_list,
                              color: FlutterFlowTheme
                                  .of(context)
                                  .primaryText,
                              size: 24,
                            ),
                            onPressed: () async {
                              await showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                enableDrag: false,
                                context: context,
                                builder: (context) {
                                  return const SearchFiltersDialog();
                                },
                              ).then((shouldTriggerSearch) =>
                              shouldTriggerSearch
                                  ? AlgoliaDocsState._fetchReverseStoreDocs()
                                  : null);
                            },
                          ),
                          Stack(
                            children: [
                              AutoCompleteBox(key: autocompleteKey),
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width - 12 - 10 - 40 - 12,
                                child: const SearchField(
                                    parentFunc: AlgoliaDocsState
                                        ._fetchReverseStoreDocs),
                              ),
                            ],
                          ),
                          //const AlgoliaDocs(),
                        ].divide(const SizedBox(width: 10)),
                      ),
                      SelectedFilters(key: selectedFiltersKey),
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 412,
                        child: ReverseStoreSearch(key: reverseStoreSearchKey),
                      ),
                    ].divide(const SizedBox(height: 10)),
                  ),
                  components.AppBar(
                    imageVariant: "default",
                    mainColor: FlutterFlowTheme
                        .of(context)
                        .primaryText,
                    secondaryColor: FlutterFlowTheme
                        .of(context)
                        .tertiary,
                    menuIcon: Icons.menu_rounded,
                    scaffoldKey: scaffoldKey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class SelectedFilters extends StatefulWidget{
  const SelectedFilters({super.key});

  @override
  State<StatefulWidget> createState() => SelectedFiltersState();
}

class SelectedFiltersState extends State<SelectedFilters>{
  static List<String> selectedFilters = [];

  @override
  Widget build(BuildContext context) {
    if(SelectedFiltersState.selectedFilters.isNotEmpty) {
      return SizedBox(
        height: 24,
        child: ListView.separated(
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          reverse: true,
          scrollDirection: Axis.horizontal,
          itemCount: selectedFilters.length,
          itemBuilder: (context, index){
            return CustomChip(title: selectedFilters[index]);
          },
        ),
      );
    }
    return const SizedBox();
  }
}
class CustomChip extends StatelessWidget{
  final String title;

  const CustomChip({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: FlutterFlowTheme.of(context).secondary,
      ),
      child: Center(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: AutoSizeText(
              title,
              minFontSize: 1,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          )
      ),
    );
  }

}
class ReverseStoreSearch extends StatefulWidget{
  const ReverseStoreSearch({super.key});

  @override
  State<StatefulWidget> createState() => ReverseStoreSearchState();
}

class ReverseStoreSearchState extends State<ReverseStoreSearch>{
  static bool isFetchingDocs = false;

  @override
  void initState() {
    super.initState();
    if(AlgoliaDocsState.snapshot == null){
      AlgoliaDocsState._fetchReverseStoreDocs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return displayAlgoliaWidget();
  }

  Widget displayAlgoliaWidget() {
    if (isFetchingDocs) {
      return const components.LoadingIcon();
    }
    if (AlgoliaDocsState.snapshot!.hits.isEmpty) {
      return const components.DataNotFound(
          title: 'Nenhum item encontrado para a sua pesquisa',
          icon: Icons.search_off);
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          const AlgoliaDocs(),
          const PaginationWrapper(),
        ].divide(const SizedBox(height: 10)),
      ),
    );
  }
}

class PaginationWrapper extends StatefulWidget{
  const PaginationWrapper({super.key});

  @override
  State<StatefulWidget> createState() => PaginationWrapperState();
}

class PaginationWrapperState extends State<PaginationWrapper>{

  @override
  Widget build(BuildContext context) {
    final int currentPage = AlgoliaDocsState.snapshot!.page;
    final int numberOfPages = AlgoliaDocsState.snapshot!.nbPages;
    final List<int> pagesArray = filterPageNumbers(List.generate(numberOfPages, (i) => i), currentPage);

    List<int> listToDisplay = [];

    if(currentPage > 5){
      listToDisplay = assemblePaginationList(pagesArray);
    }
    else{
      listToDisplay = pagesArray;
    }


    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.start,
        direction: Axis.horizontal,
        runAlignment: WrapAlignment.start,
        verticalDirection: VerticalDirection.down,
        clipBehavior: Clip.none,
        children: List.generate(listToDisplay.length, (index)
        {
          if(listToDisplay[index] == -1){
            return const SizedBox(
                width: 40,
                height: 40,
                child: Align(
                  alignment: Alignment.center,
                  child: Text('...'),
                )
            );
          }
          return PaginationBox(currentlySelectedIndex: currentPage, index: listToDisplay[index]);
        }
        ),
      ),
    );
  }

  List<int> assemblePaginationList(List<int> pagesArray) {
    List<int> assembledPaginationList = [pagesArray[0], -1, pagesArray[1], pagesArray[2]];
    int difference = pagesArray[pagesArray.length-1] - pagesArray[2];

    if(difference >= 3){
      assembledPaginationList.addAll([pagesArray[3], -1, pagesArray[pagesArray.length-1]]);
    }
    else if(difference == 2){
      assembledPaginationList.addAll([pagesArray[3], pagesArray[pagesArray.length-1]]);
    }
    else if(difference == 1){
      assembledPaginationList.add(pagesArray[3]);
    }

    return assembledPaginationList;
  }
}


class AutoCompleteBox extends StatefulWidget{
  const AutoCompleteBox({super.key});

  @override
  State<StatefulWidget> createState() => AutoCompleteBoxState();

}

class AutoCompleteBoxState extends State<AutoCompleteBox>{

  static bool shouldBeDisplayed = false;
  static List<String> cachedQueries = [];
  static List<String> listToDisplay = [];

  void toggleShouldBeDisplayed(){
    if(!mounted) return;
    setState(() {
      shouldBeDisplayed = !shouldBeDisplayed;
    });
  }
  void updateSuggestions(){
    setState(() {
      if(SearchFieldState.controller.text.isEmpty){
        listToDisplay = cachedQueries;
      }
      else{
        if(AlgoliaDocsState.snapshot != null){
          if(AlgoliaDocsState.snapshot!.hasHits){
            listToDisplay = AlgoliaDocsState.snapshot!.hits
                .map((doc) {
              final data = doc.data;
              return data['title'] != null ? data['title'] as String : data['query'] as String;
            })
                .take(5)
                .toSet()
                .toList();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return shouldBeDisplayed ? Container(
      width: MediaQuery.of(context).size.width - 12 - 10 - 40 - 12,
      decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryText,
          borderRadius: BorderRadius.circular(24)
      ),
      child: listToDisplay.isNotEmpty ? Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 36),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: listToDisplay.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    SearchFieldState.controller.text = listToDisplay[index];
                    AlgoliaDocsState._fetchReverseStoreDocs(shouldSaveCacheQuery: true);
                    SearchFieldState.focusNode.unfocus();
                  },
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                            ),
                            Text(
                              listToDisplay[index],
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Readex Pro',
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                              ),
                            ),
                          ].divide(const SizedBox(width: 10)),
                        ),
                        Icon(
                          Icons.arrow_outward,
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ) : null,
    ) : const SizedBox();
  }
}

class AlgoliaDocs extends StatefulWidget {
  const AlgoliaDocs({super.key});

  @override
  State<StatefulWidget> createState() => AlgoliaDocsState();
}

class AlgoliaDocsState extends State<AlgoliaDocs> {

  static final Algolia _algolia = Algolia.init(applicationId: dotenv.env['ALGOLIA_APP_ID'] ?? '', apiKey: dotenv.env['ALGOLIA_API_KEY'] ?? '');
  static AlgoliaQuerySnapshot? snapshot;
  static List<AlgoliaDocStruct> reverseItems = [];

  static void saveQueryToCache(){
    if(!AutoCompleteBoxState.cachedQueries.contains(SearchFieldState.controller.text) && SearchFieldState.controller.text.isNotEmpty){
      AutoCompleteBoxState.cachedQueries.add(SearchFieldState.controller.text);

      if(AutoCompleteBoxState.cachedQueries.length > 5){
        AutoCompleteBoxState.cachedQueries.removeAt(0);
      }
    }
    AutoCompleteBoxState.cachedQueries = AutoCompleteBoxState.cachedQueries.toSet().toList();
  }
  static convertSnapshotToReverseItems(){
    List<AlgoliaDocStruct> newList = [];

    for(var item in snapshot!.hits){
      List<dynamic> imagesDynamic = item.data['images'];
      List<String> images = imagesDynamic.map((image) => image as String).toList();
      DocumentReference documentReference = FirebaseFirestore.instance.doc(item.data['path']);
      DocumentReference createdBy = FirebaseFirestore.instance.doc(item.data['created_by']);
      newList.add(AlgoliaDocStruct(Images: images, Title: item.data['title'], Price: item.data['price'].toDouble(), Description: item.data['description'], ref: documentReference, created_by: createdBy));
    }
    reverseItems = newList;
  }

  static Future<void> _fetchReverseStoreDocs({String index = 'reverse_store_index', bool shouldSaveCacheQuery = false, int pageToGet = 0}) async {
    AlgoliaQuery query = _algolia.instance.index(index);
    SelectedFiltersState.selectedFilters = [];

    List<String> facetFilters = ['sold:false'];

    if (SearchFiltersDialog.gender != null) {
      SelectedFiltersState.selectedFilters.add(SearchFiltersDialog.gender!);
      facetFilters.add('gender:${SearchFiltersDialog.gender}');
    }

    if (SearchFiltersDialog.category != null) {
      SelectedFiltersState.selectedFilters.add(SearchFiltersDialog.category!);
      facetFilters.add('category:${SearchFiltersDialog.category}');
    }

    if (SearchFiltersDialog.size != null) {
      SelectedFiltersState.selectedFilters.add(SearchFiltersDialog.size!);
      facetFilters.add('size:${SearchFiltersDialog.size}');
    }

    if (SearchFiltersDialog.minPrice != null && SearchFiltersDialog.minPrice!.isNotEmpty){
      SelectedFiltersState.selectedFilters.add('Mais que: R\$${convertDoubleToString(double.parse(SearchFiltersDialog.minPrice!))}');
      facetFilters.add('price > ${SearchFiltersDialog.minPrice}');
    }

    if (SearchFiltersDialog.maxPrice != null && SearchFiltersDialog.maxPrice!.isNotEmpty){
      SelectedFiltersState.selectedFilters.add('Menos que: R\$${convertDoubleToString(double.parse(SearchFiltersDialog.maxPrice!))}');
      facetFilters.add('price < ${SearchFiltersDialog.maxPrice}');
    }

    ReverseWidgetState.reverseStoreSearchKey.currentState!.setState(() {
      ReverseStoreSearchState.isFetchingDocs = true;
    });
    snapshot = await query
        .filters(facetFilters.join(' AND '))
        .query(SearchFieldState.controller.text)
        .setPage(pageToGet)
        .getObjects();
    ReverseWidgetState.autocompleteKey.currentState!.updateSuggestions();

    if(shouldSaveCacheQuery){
      saveQueryToCache();
    }
    else{
      if(ReverseWidgetState.selectedFiltersKey.currentState!= null){
        ReverseWidgetState.selectedFiltersKey.currentState!.setState(() {});
      }
    }
    if(index == 'reverse_store_index'){
      convertSnapshotToReverseItems();
      ReverseWidgetState.reverseStoreSearchKey.currentState!.setState(() {
        ReverseStoreSearchState.isFetchingDocs = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReverseBuilder(list: reverseItems, disableScroll: true);
  }
}
class PaginationBox extends StatelessWidget{
  final int index;
  final int currentlySelectedIndex;

  const PaginationBox({
    super.key,
    required this.currentlySelectedIndex,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => AlgoliaDocsState._fetchReverseStoreDocs(pageToGet: index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: index == currentlySelectedIndex
              ? FlutterFlowTheme.of(context).primaryText
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (index + 1).toString(),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                color: index == currentlySelectedIndex
                    ? FlutterFlowTheme.of(context).primaryBackground
                    : FlutterFlowTheme.of(context).secondaryText,
                fontSize: 17,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.parentFunc,
  });

  final dynamic parentFunc;

  @override
  State<StatefulWidget> createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  static final controller = TextEditingController();
  static final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(ReverseWidgetState.autocompleteKey.currentState!.toggleShouldBeDisplayed);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: false,
      textInputAction: TextInputAction.search,
      obscureText: false,
      onChanged: (_) => EasyDebounce.debounce(
        'controller',
        const Duration(milliseconds: 500),
            () => AlgoliaDocsState._fetchReverseStoreDocs(index: 'reverse_store_index_query_suggestions'),
      ),
      decoration: InputDecoration(
        hintText: 'Busque peças do reverse...',
        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
          fontFamily: 'Readex Pro',
          color: FlutterFlowTheme.of(context).secondaryBackground,
          letterSpacing: 0,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0x00000000),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0x00000000),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0x00000000),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0x00000000),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        filled: true,
        contentPadding: const EdgeInsetsDirectional.fromSTEB(0, 11, 0, 0),
        fillColor: FlutterFlowTheme.of(context).primaryText,
        prefixIcon: Icon(
          Icons.search,
          color: FlutterFlowTheme.of(context).primaryBackground,
        ),
      ),
      style: FlutterFlowTheme.of(context).bodyMedium.override(
        fontFamily: 'Readex Pro',
        color: FlutterFlowTheme.of(context).primaryBackground,
        letterSpacing: 0,
      ),
      onFieldSubmitted: (value) {
        widget.parentFunc(shouldSaveCacheQuery: true);
      },
    );
  }
}

class ReverseDrawer extends StatelessWidget {
  const ReverseDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: const Column(
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

  const ProfileSlot({super.key});

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
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: profilePicSize,
                height: profilePicSize,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
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
            ].divide(const SizedBox(height: 10)),
          ),
        ),
      ),
    );
  }
}

class DrawerSlots extends StatelessWidget {
  const DrawerSlots({super.key});

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
            context.pushNamed('GerenciarAnuncios');
          },
        ),
        DrawerSlot(
          title: 'Histórico de Vendas',
          icon: Icons.sell_outlined,
          navigate: () {
            context.pushNamed('History', queryParameters: {
              'shouldQueryAsBuyer' : serializeParam(
                false,
                ParamType.bool,
                isList: false,
              ),
            });
          },
        ),
        DrawerSlot(
          title: 'Histórico de Compras',
          icon: Icons.paid_outlined,
          navigate: () {
            context.pushNamed('History', queryParameters: {
              'shouldQueryAsBuyer' : serializeParam(
                true,
                ParamType.bool,
                isList: false,
              ),
            });
          },
        ),
      ].divide(const SizedBox(height: 35)),
    );
  }
}

class DrawerSlot extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback navigate;

  const DrawerSlot({
    super.key,
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
        ].divide(const SizedBox(width: 35)),
      ),
    );
  }
}

List<int> filterPageNumbers(List<int> pageNumbers, selectedPageIndex){
  if(selectedPageIndex < 6) return pageNumbers.sublist(0, min(7, pageNumbers.length));

  List<int> filteredPageNumbers = [0, (selectedPageIndex - 1), selectedPageIndex];

  if( ((pageNumbers.length - 1) - (selectedPageIndex + 1)) >= 1 ){
    filteredPageNumbers.add(selectedPageIndex + 1);
  }
  if(selectedPageIndex < pageNumbers.length-1){
    filteredPageNumbers.add(pageNumbers.length-1);
  }
  return filteredPageNumbers;
}
