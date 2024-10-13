import 'package:dona_do_santo/backend/schema/reverse_store_record.dart';
import 'package:dona_do_santo/backend/schema/structs/index.dart';
import 'package:dona_do_santo/custom_code/widgets/index.dart';
import 'package:flutter/cupertino.dart';

import '../backend/backend.dart';
import 'package:dona_do_santo/custom_code/widgets/components.dart'
as components;

class ReverseBuilder<T extends GeneralInfo> extends StatelessWidget {
  final List<T> list;
  final bool? disableScroll;

  const ReverseBuilder({super.key, required this.list, this.disableScroll});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.59,
      ),
      //physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: list.length,
      physics: disableScroll != null ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return components.CardRoupaComponent(
          key: Key(
            'Keyr8n_$index',
          ),
          title: list[index].title,
          price: list[index].price,
          image: list[index].image,
          userRef: list[index].createdBy,
          isNegated: list[index].negated,
          explanation: list[index].explanation,
          docRef: list[index].docRef,
        );
      },
    );
  }
}

abstract class GeneralInfo {
  String get title;
  String get description;
  double get price;
  String get image;
  List<String>? get nullableImages;
  DocumentReference<Object?>? get createdBy;
  bool? get negated;
  String? get explanation;
  DocumentReference get docRef;
  String? get gender;
  String? get category;
  String? get size;
  StoreStruct? get store;
  List<String>? get sizes;
  String? get webstoreLink;
}
