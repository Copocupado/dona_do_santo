import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dona_do_santo/backend/schema/structs/store_struct.dart';
import 'package:dona_do_santo/backend/schema/util/schema_util.dart';

import '../../components/reverse_builder.dart';
import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReverseStoreRecord extends FirestoreRecord implements GeneralInfo{
  ReverseStoreRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "isPurchased" field.
  bool? _isPurchased;
  bool get isPurchased => _isPurchased ?? false;
  bool hasIsPurchased() => _isPurchased != null;

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

  // "store" field.
  StoreStruct? _store;
  StoreStruct get store => _store ?? StoreStruct();
  bool hasStore() => _store != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0;
  bool hasPrice() => _price != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "created_by" field.
  DocumentReference? _createdBy;
  @override
  DocumentReference? get createdBy => _createdBy;
  bool hasCreatedBy() => _createdBy != null;

  // "created_by_email" field.
  String? _createdByEmail;
  String get createdByEmail => _createdByEmail ?? '';

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _description = snapshotData['description'] as String?;
    _images = getDataList(snapshotData['images']);
    _gender = snapshotData['gender'] as String?;
    _category = snapshotData['category'] as String?;
    _size = snapshotData['size'] as String?;
    _store = StoreStruct.maybeFromMap(snapshotData['store']);
    _price = snapshotData['price'] as double?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _createdBy = snapshotData['created_by'] as DocumentReference?;
    _isPurchased = snapshotData['sold'] as bool?;
    _createdByEmail = snapshotData['created_by_email'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('reverse_store');

  static Stream<ReverseStoreRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ReverseStoreRecord.fromSnapshot(s));

  static Stream<ReverseStoreRecord?> getNullableDocument(DocumentReference ref) {
    return ref.snapshots().map((snapshot) {
      if (snapshot.data() == null || !snapshot.exists) {
        // Handle the case where snapshot is null or does not exist
        return null; // You may need to adjust this depending on how you want to handle nulls
      }
      return ReverseStoreRecord.fromSnapshot(snapshot);
    }).where((record) => record != null); // Filter out any null records
  }

  static Future<ReverseStoreRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ReverseStoreRecord.fromSnapshot(s));

  static ReverseStoreRecord fromSnapshot(DocumentSnapshot snapshot) {
    return ReverseStoreRecord._(
      snapshot.reference,
      mapFromFirestore(snapshot.data() as Map<String, dynamic>),
    );
  }

  static ReverseStoreRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ReverseStoreRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ReverseStoreRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;


  @override
  String? get explanation => null;


  @override
  DocumentReference<Object?> get docRef => reference;

  @override
  // TODO: implement negated
  bool? get negated => null;

  @override
  // TODO: implement sizes
  List<String>? get sizes => null;

  @override
  // TODO: implement image
  String get image => images[0];

  @override
  // TODO: implement nullableImages
  List<String>? get nullableImages => _images;

  @override
  String? get webstoreLink => null;
}

Map<String, dynamic> createReverseStoreRecordData({
  String? title,
  String? description,
  String? gender,
  String? category,
  String? size,
  StoreStruct? store,
  double? price,
  DateTime? createdTime,
  DocumentReference? createdBy,
  bool? isPurchased,
  String? createdByEmail,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'description': description,
      'gender': gender,
      'category': category,
      'size': size,
      'store': StoreStruct().toMap(),
      'price': price,
      'created_time': createdTime,
      'created_by': createdBy,
      'sold': isPurchased,
      'created_by_email': createdByEmail,
    }.withoutNulls,
  );

  // Handle nested data for "store" field.
  addStoreStructData(firestoreData, store, 'store');

  return firestoreData;
}

class ReverseStoreRecordDocumentEquality
    implements Equality<ReverseStoreRecord> {
  const ReverseStoreRecordDocumentEquality();

  @override
  bool equals(ReverseStoreRecord? e1, ReverseStoreRecord? e2) {
    const listEquality = ListEquality();
    return e1?.title == e2?.title &&
        e1?.description == e2?.description &&
        listEquality.equals(e1?.images, e2?.images) &&
        e1?.gender == e2?.gender &&
        e1?.category == e2?.category &&
        e1?.size == e2?.size &&
        e1?.store == e2?.store &&
        e1?.price == e2?.price &&
        e1?.createdTime == e2?.createdTime &&
        e1?.createdBy == e2?.createdBy;
  }

  @override
  int hash(ReverseStoreRecord? e) => const ListEquality().hash([
        e?.title,
        e?.description,
        e?.images,
        e?.gender,
        e?.category,
        e?.size,
        e?.store,
        e?.price,
        e?.createdTime,
        e?.createdBy
      ]);

  @override
  bool isValidKey(Object? o) => o is ReverseStoreRecord;
}
