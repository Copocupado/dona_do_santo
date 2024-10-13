import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RecomendacoesRecord extends FirestoreRecord {
  RecomendacoesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  bool hasDescription() => _description != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "link" field.
  String? _link;
  String get link => _link ?? '';
  bool hasLink() => _link != null;

  void _initializeFields() {
    _createdTime = snapshotData['created_time'] as DateTime?;
    _description = snapshotData['description'] as String?;
    _title = snapshotData['title'] as String?;
    _image = snapshotData['image'] as String?;
    _link = snapshotData['link'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('recomendacoes');

  static Stream<RecomendacoesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RecomendacoesRecord.fromSnapshot(s));

  static Future<RecomendacoesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => RecomendacoesRecord.fromSnapshot(s));

  static RecomendacoesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RecomendacoesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RecomendacoesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RecomendacoesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RecomendacoesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RecomendacoesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRecomendacoesRecordData({
  DateTime? createdTime,
  String? description,
  String? title,
  String? image,
  String? link,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'created_time': createdTime,
      'description': description,
      'title': title,
      'image': image,
      'link': link,
    }.withoutNulls,
  );

  return firestoreData;
}

class RecomendacoesRecordDocumentEquality
    implements Equality<RecomendacoesRecord> {
  const RecomendacoesRecordDocumentEquality();

  @override
  bool equals(RecomendacoesRecord? e1, RecomendacoesRecord? e2) {
    return e1?.createdTime == e2?.createdTime &&
        e1?.description == e2?.description &&
        e1?.title == e2?.title &&
        e1?.image == e2?.image &&
        e1?.link == e2?.link;
  }

  @override
  int hash(RecomendacoesRecord? e) => const ListEquality()
      .hash([e?.createdTime, e?.description, e?.title, e?.image, e?.link]);

  @override
  bool isValidKey(Object? o) => o is RecomendacoesRecord;
}
