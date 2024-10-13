import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LojasDaEmpresaRecord extends FirestoreRecord {
  LojasDaEmpresaRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "address" field.
  String? _address;
  String get address => _address ?? '';

  // "formattedAddress" field.
  String? _formattedAddress;
  String get formattedAddress => _formattedAddress ?? '';

  bool hasAddress() => _address != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  void _initializeFields() {
    _address = snapshotData['address'] as String?;
    _image = snapshotData['image'] as String?;
    _formattedAddress = snapshotData['formattedAddress'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('lojas_da_empresa');

  static Stream<LojasDaEmpresaRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => LojasDaEmpresaRecord.fromSnapshot(s));

  static Future<LojasDaEmpresaRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => LojasDaEmpresaRecord.fromSnapshot(s));

  static LojasDaEmpresaRecord fromSnapshot(DocumentSnapshot snapshot) =>
      LojasDaEmpresaRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static LojasDaEmpresaRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      LojasDaEmpresaRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'LojasDaEmpresaRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is LojasDaEmpresaRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createLojasDaEmpresaRecordData({
  String? address,
  String? image,
  String? formattedAddress,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'address': address,
      'image': image,
      'formattedAddress': formattedAddress,
    }.withoutNulls,
  );

  return firestoreData;
}

class LojasDaEmpresaRecordDocumentEquality
    implements Equality<LojasDaEmpresaRecord> {
  const LojasDaEmpresaRecordDocumentEquality();

  @override
  bool equals(LojasDaEmpresaRecord? e1, LojasDaEmpresaRecord? e2) {
    return e1?.address == e2?.address && e1?.image == e2?.image && e1?.formattedAddress == e2?.formattedAddress;
  }

  @override
  int hash(LojasDaEmpresaRecord? e) =>
      const ListEquality().hash([e?.address, e?.image, e?.formattedAddress]);

  @override
  bool isValidKey(Object? o) => o is LojasDaEmpresaRecord;
}
