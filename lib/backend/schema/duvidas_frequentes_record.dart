import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DuvidasFrequentesRecord extends FirestoreRecord {
  DuvidasFrequentesRecord._(
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

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _description = snapshotData['description'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('duvidas_frequentes');

  static Stream<DuvidasFrequentesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DuvidasFrequentesRecord.fromSnapshot(s));

  static Future<DuvidasFrequentesRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => DuvidasFrequentesRecord.fromSnapshot(s));

  static DuvidasFrequentesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DuvidasFrequentesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DuvidasFrequentesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DuvidasFrequentesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DuvidasFrequentesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DuvidasFrequentesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDuvidasFrequentesRecordData({
  String? title,
  String? description,
  DateTime? createdTime,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'description': description,
      'created_time': createdTime,
    }.withoutNulls,
  );

  return firestoreData;
}

class DuvidasFrequentesRecordDocumentEquality
    implements Equality<DuvidasFrequentesRecord> {
  const DuvidasFrequentesRecordDocumentEquality();

  @override
  bool equals(DuvidasFrequentesRecord? e1, DuvidasFrequentesRecord? e2) {
    return e1?.title == e2?.title &&
        e1?.description == e2?.description &&
        e1?.createdTime == e2?.createdTime;
  }

  @override
  int hash(DuvidasFrequentesRecord? e) =>
      const ListEquality().hash([e?.title, e?.description, e?.createdTime]);

  @override
  bool isValidKey(Object? o) => o is DuvidasFrequentesRecord;
}
