import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dona_do_santo/backend/schema/structs/store_struct.dart';
import 'package:dona_do_santo/backend/schema/util/schema_util.dart';

import '../../components/reverse_builder.dart';
import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class SolicitacoesRecord extends FirestoreRecord implements GeneralInfo{
  SolicitacoesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "images" field.
  List<String>? _images;
  List<String> get images => _images ?? const [];
  bool hasImages() => _images != null;

  // "gender" field.
  String? _gender;
  String get gender => _gender ?? '';
  bool hasGender() => _gender != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  bool hasCategory() => _category != null;

  // "size" field.
  String? _size;
  String get size => _size ?? '';
  bool hasSize() => _size != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "created_by" field.
  DocumentReference? _createdBy;
  DocumentReference? get createdBy => _createdBy;
  bool hasCreatedBy() => _createdBy != null;

  // "created_by_email" field.
  String? _createdByEmail;
  String? get createdByEmail => _createdByEmail ?? '';

  // "store" field.
  StoreStruct? _store;
  StoreStruct get store => _store ?? StoreStruct();
  bool hasStore() => _store != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  bool hasPrice() => _price != null;

  // "negated" field.
  bool? _negated;
  bool get negated => _negated ?? false;
  bool hasNegated() => _negated != null;

  String? _explanation;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _description = snapshotData['description'] as String?;
    _images = getDataList(snapshotData['images']);
    _gender = snapshotData['gender'] as String?;
    _category = snapshotData['category'] as String?;
    _size = snapshotData['size'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _createdBy = snapshotData['created_by'] as DocumentReference?;
    _store = StoreStruct.maybeFromMap(snapshotData['store']);
    _price = castToType<double>(snapshotData['price']);
    _negated = snapshotData['negated'] as bool?;
    _createdByEmail = snapshotData['created_by_email'] as String?;
    _explanation = snapshotData['negated_explanation'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('solicitacoes');

  static Stream<SolicitacoesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SolicitacoesRecord.fromSnapshot(s));

  static Future<SolicitacoesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SolicitacoesRecord.fromSnapshot(s));

  static SolicitacoesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SolicitacoesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SolicitacoesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SolicitacoesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SolicitacoesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SolicitacoesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;

  @override
  DocumentReference<Object?> get docRef => reference;

  @override
  String? get explanation => _explanation;

  @override
  String get image => _images![0];

  @override
  List<String>? get nullableImages => _images;

  @override
  List<String>? get sizes => null;

  @override
  String? get webstoreLink => null;
}

Map<String, dynamic> createSolicitacoesRecordData({
  String? title,
  String? description,
  String? gender,
  String? category,
  String? size,
  DateTime? createdTime,
  DocumentReference? createdBy,
  StoreStruct? store,
  double? price,
  bool? negated,
  String? createdByEmail,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'description': description,
      'gender': gender,
      'category': category,
      'size': size,
      'created_time': createdTime,
      'created_by': createdBy,
      'store': StoreStruct().toMap(),
      'price': price,
      'negated': negated,
      'created_by_email': createdByEmail,
    }.withoutNulls,
  );

  // Handle nested data for "store" field.
  addStoreStructData(firestoreData, store, 'store');

  return firestoreData;
}

class SolicitacoesRecordDocumentEquality
    implements Equality<SolicitacoesRecord> {
  const SolicitacoesRecordDocumentEquality();

  @override
  bool equals(SolicitacoesRecord? e1, SolicitacoesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.title == e2?.title &&
        e1?.description == e2?.description &&
        listEquality.equals(e1?.images, e2?.images) &&
        e1?.gender == e2?.gender &&
        e1?.category == e2?.category &&
        e1?.size == e2?.size &&
        e1?.createdTime == e2?.createdTime &&
        e1?.createdBy == e2?.createdBy &&
        e1?.store == e2?.store &&
        e1?.price == e2?.price &&
        e1?.negated == e2?.negated;
  }

  @override
  int hash(SolicitacoesRecord? e) => const ListEquality().hash([
        e?.title,
        e?.description,
        e?.images,
        e?.gender,
        e?.category,
        e?.size,
        e?.createdTime,
        e?.createdBy,
        e?.store,
        e?.price,
        e?.negated
      ]);

  @override
  bool isValidKey(Object? o) => o is SolicitacoesRecord;
}
