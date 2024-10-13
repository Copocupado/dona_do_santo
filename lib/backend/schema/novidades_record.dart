import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dona_do_santo/backend/schema/structs/store_struct.dart';
import 'package:dona_do_santo/components/reverse_builder.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NovidadesRecord extends FirestoreRecord implements GeneralInfo {
  NovidadesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "images" field.
  List<String>? _images;
  List<String> get images => _images ?? const [];

  bool hasImages() => _images != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0;
  bool hasPrice() => _price != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  List<String>? _sizes;
  @override
  List<String> get sizes => _sizes ?? const [];
  bool hasSizes() => _sizes != null;

  // "webstore_link" field.
  String? _webstoreLink;

  void _initializeFields() {
    _description = snapshotData['description'] as String?;
    _images = getDataList(snapshotData['images']);
    _price = snapshotData['price'] as double?;
    _title = snapshotData['title'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _sizes = getDataList(snapshotData['sizes']);
    _webstoreLink = snapshotData['webstore_link'];
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('novidades');

  static Stream<NovidadesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NovidadesRecord.fromSnapshot(s));

  static Future<NovidadesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NovidadesRecord.fromSnapshot(s));

  static NovidadesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NovidadesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NovidadesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NovidadesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NovidadesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NovidadesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;

  @override
  // TODO: implement category
  String? get category => null;

  @override
  // TODO: implement createdBy
  DocumentReference<Object?>? get createdBy => null;

  @override
  // TODO: implement docRef
  DocumentReference<Object?> get docRef => reference;

  @override
  // TODO: implement explanation
  String? get explanation => null;

  @override
  // TODO: implement gender
  String? get gender => null;

  @override
  // TODO: implement negated
  bool? get negated => null;

  @override
  // TODO: implement size
  String? get size => null;

  @override
  // TODO: implement store
  StoreStruct? get store => null;

  @override
  // TODO: implement image
  String get image => images[0];

  @override
  // TODO: implement nullableImages
  List<String>? get nullableImages => _images;

  @override
  String? get webstoreLink => _webstoreLink;
}

Map<String, dynamic> createNovidadesRecordData({
  String? description,
  String? price,
  String? title,
  DateTime? createdTime,
  List<String>? sizes,
  String? webstoreLink,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'description': description,
      'price': price,
      'title': title,
      'created_time': createdTime,
      'sizes' : sizes,
      'webstore_link': webstoreLink,
    }.withoutNulls,
  );

  return firestoreData;
}

class NovidadesRecordDocumentEquality implements Equality<NovidadesRecord> {
  const NovidadesRecordDocumentEquality();

  @override
  bool equals(NovidadesRecord? e1, NovidadesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.description == e2?.description &&
        listEquality.equals(e1?.images, e2?.images) &&
        e1?.price == e2?.price &&
        e1?.title == e2?.title &&
        e1?.createdTime == e2?.createdTime;
  }

  @override
  int hash(NovidadesRecord? e) => const ListEquality()
      .hash([e?.description, e?.images, e?.price, e?.title, e?.createdTime]);

  @override
  bool isValidKey(Object? o) => o is NovidadesRecord;
}
