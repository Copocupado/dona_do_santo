import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RelatorioReverseCreditsRecord extends FirestoreRecord {
  RelatorioReverseCreditsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "information" field.
  String? _information;
  String get information => _information ?? '';
  bool hasInformation() => _information != null;

  // "value_changed" field.
  double? _valueChanged;
  double get valueChanged => _valueChanged ?? 0.0;
  bool hasValueChanged() => _valueChanged != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _createdTime = snapshotData['created_time'] as DateTime?;
    _information = snapshotData['information'] as String?;
    _valueChanged = castToType<double>(snapshotData['value_changed']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('relatorio_reverse_credits')
          : FirebaseFirestore.instance
              .collectionGroup('relatorio_reverse_credits');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('relatorio_reverse_credits').doc(id);

  static Stream<RelatorioReverseCreditsRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => RelatorioReverseCreditsRecord.fromSnapshot(s));

  static Future<RelatorioReverseCreditsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => RelatorioReverseCreditsRecord.fromSnapshot(s));

  static RelatorioReverseCreditsRecord fromSnapshot(
          DocumentSnapshot snapshot) =>
      RelatorioReverseCreditsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RelatorioReverseCreditsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RelatorioReverseCreditsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RelatorioReverseCreditsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RelatorioReverseCreditsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRelatorioReverseCreditsRecordData({
  DateTime? createdTime,
  String? information,
  double? valueChanged,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'created_time': createdTime,
      'information': information,
      'value_changed': valueChanged,
    }.withoutNulls,
  );

  return firestoreData;
}

class RelatorioReverseCreditsRecordDocumentEquality
    implements Equality<RelatorioReverseCreditsRecord> {
  const RelatorioReverseCreditsRecordDocumentEquality();

  @override
  bool equals(
      RelatorioReverseCreditsRecord? e1, RelatorioReverseCreditsRecord? e2) {
    return e1?.createdTime == e2?.createdTime &&
        e1?.information == e2?.information &&
        e1?.valueChanged == e2?.valueChanged;
  }

  @override
  int hash(RelatorioReverseCreditsRecord? e) => const ListEquality()
      .hash([e?.createdTime, e?.information, e?.valueChanged]);

  @override
  bool isValidKey(Object? o) => o is RelatorioReverseCreditsRecord;
}
