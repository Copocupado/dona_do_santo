import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NoticiasRecord extends FirestoreRecord {
  NoticiasRecord._(
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
      FirebaseFirestore.instance.collection('noticias');

  static Stream<NoticiasRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NoticiasRecord.fromSnapshot(s));

  static Future<NoticiasRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NoticiasRecord.fromSnapshot(s));

  static NoticiasRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NoticiasRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NoticiasRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NoticiasRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NoticiasRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NoticiasRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNoticiasRecordData({
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

class NoticiasRecordDocumentEquality implements Equality<NoticiasRecord> {
  const NoticiasRecordDocumentEquality();

  @override
  bool equals(NoticiasRecord? e1, NoticiasRecord? e2) {
    return e1?.createdTime == e2?.createdTime &&
        e1?.description == e2?.description &&
        e1?.title == e2?.title &&
        e1?.image == e2?.image &&
        e1?.link == e2?.link;
  }

  @override
  int hash(NoticiasRecord? e) => const ListEquality()
      .hash([e?.createdTime, e?.description, e?.title, e?.image, e?.link]);

  @override
  bool isValidKey(Object? o) => o is NoticiasRecord;
}
