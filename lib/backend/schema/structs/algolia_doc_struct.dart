import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dona_do_santo/backend/schema/structs/store_struct.dart';
import 'package:dona_do_santo/components/reverse_builder.dart';

class AlgoliaDocStruct implements GeneralInfo{
  final List<String> Images;
  final String Title;
  final double Price;
  final String Description;
  final DocumentReference<Object?> ref;
  final DocumentReference<Object?> created_by;

  const AlgoliaDocStruct({
    required this.Images,
    required this.Title,
    required this.Price,
    required this.Description,
    required this.ref,
    required this.created_by,
  });

  @override
  String? get category => null;

  @override
  DocumentReference<Object?>? get createdBy => created_by;

  @override
  String get description => this.Description;

  @override
  DocumentReference<Object?> get docRef => ref;

  @override
  String? get explanation => null;

  @override
  String? get gender => null;

  @override
  String get image => this.Images[0];

  @override
  bool? get negated => null;

  @override
  List<String>? get nullableImages => this.Images;

  @override
  double get price => this.Price;

  @override
  String? get size => null;

  @override
  List<String>? get sizes => null;

  @override
  StoreStruct? get store => null;

  @override
  String get title => this.Title;

  @override
  String? get webstoreLink => null;
}