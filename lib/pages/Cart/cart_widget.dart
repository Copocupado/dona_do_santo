import 'package:dona_do_santo/backend/schema/reverse_store_record.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart' as components;
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../reverse/reverse/reverse_widget.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<StatefulWidget> createState() => CartWidgetState();
}

class CartWidgetState extends State<CartWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late DocumentReference docRef;

  final List<Stream<ReverseStoreRecord>> streamList = [];
  final List<DocumentReference> listOfItemsToRemove = [];

  final List<ReverseStoreRecord> itemsList = [];
  late bool shouldCallFutureBuilder;

  @override
  void initState() {
    super.initState();
    shouldCallFutureBuilder = true;
  }

  Future<void> checkIfValidFavs() async {
    if(!mounted) return;
    print('checkIfValidFavs called');
    for (var item in FFAppState().userFavedItems.value!) {
      try {
        // Fetch the document snapshot from Firestore
        final snapshot = await item.get();
        final ReverseStoreRecord doc = ReverseStoreRecord.fromSnapshot(snapshot);
        print(doc.isPurchased);

        // Check if the document exists
        if (snapshot.exists && snapshot.data() != null && doc.isPurchased == false) {
          Stream<ReverseStoreRecord> stream = FFAppState().reverseStoreItem(
            uniqueQueryKey: item.id,
            requestFn: () => ReverseStoreRecord.getDocument(item),
          );
          if(!doesStreamExists(stream)){
            streamList.add(stream);
          }
          ReverseStoreRecord record = ReverseStoreRecord.fromSnapshot(snapshot);
          if(!doesItemExists(record)){
            itemsList.add(record);
          }

        } else {
          listOfItemsToRemove.add(item);
        }
      } catch (e) {
        print('Error fetching document: $e');
        return;
      }
    }
    for (var item in listOfItemsToRemove) {
      FFAppState().userFavedItems.value!.remove(item);
    }
  }

  bool doesStreamExists(Stream stream){
    for(var oldStream in streamList){
      if(stream == oldStream){
        return true;
      }
    }
    return false;
  }

  bool doesItemExists(ReverseStoreRecord record){
    for(var item in itemsList){
      if(record == item){
        return true;
      }
    }
    return false;
  }

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
                child: FutureBuilder(
                  future: shouldCallFutureBuilder ? checkIfValidFavs() : null,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const components.LoadingIcon();
                    }
                    return Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: streamList.isNotEmpty
                                ? GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.59,
                              ),
                              scrollDirection: Axis.vertical,
                              itemCount: streamList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return StreamBuilder<ReverseStoreRecord>(
                                  stream: streamList[index],
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const components.LoadingIcon();
                                    }

                                    docRef = snapshot.data!.docRef;

                                    return components.CardRoupaComponent(
                                      key: Key('Keyr8n_$index'),
                                      title: snapshot.data!.title,
                                      price: snapshot.data!.price,
                                      image: snapshot.data!.image,
                                      userRef: snapshot.data!.createdBy,
                                      isNegated: snapshot.data!.negated,
                                      explanation: snapshot.data!.explanation,
                                      docRef: snapshot.data!.docRef,
                                    );
                                  },
                                );
                              },
                            )
                                : SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height - 204,
                                child: const components.DataNotFound(
                                    title: 'Nenhum item adicionado ao carrinho ainda',
                                    icon: Icons.remove_shopping_cart)),
                          ),
                        ),
                        if (streamList.isNotEmpty)
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primaryText,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(28),
                                child: FFButtonWidget(
                                  onPressed: () {
                                    shouldCallFutureBuilder = false;
                                    context.pushNamed(
                                      'ExtraDetails',
                                      queryParameters: {
                                        'itemsList': serializeParam(
                                          itemsList,
                                          ParamType.Document,
                                          isList: true,
                                        ),
                                      }.withoutNulls,
                                      extra: <String, dynamic>{
                                        'itemsList': itemsList,
                                      },
                                    );
                                  },
                                  text: 'Comprar via pix',
                                  icon: const Icon(
                                    Icons.pix_rounded,
                                    size: 27,
                                  ),
                                  options: FFButtonOptions(
                                    color: const Color(0xFF00B488),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                      fontFamily: 'Outfit',
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    elevation: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

