// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../flutter_flow/nav/serialization_util.dart';
import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class StoreStruct extends FFFirebaseStruct {
  StoreStruct({
    String? storeImage,
    String? address,
    String? formattedAddress,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _storeImage = storeImage,
        _address = address,
        _formattedAddress = formattedAddress,
        super(firestoreUtilData);

  // "storeImage" field.
  String? _storeImage;
  String get storeImage => _storeImage ?? '';
  set storeImage(String? val) => _storeImage = val;

  bool hasStoreImage() => _storeImage != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  set address(String? val) => _address = val;

  bool hasAddress() => _address != null;

  // "formattedAddress" field.
  String? _formattedAddress;
  String get formattedAddress => _formattedAddress ?? '';
  set formattedAddress(String? val) => _formattedAddress = val;

  bool hasFormattedAddress() => _formattedAddress != null;

  static StoreStruct fromMap(Map<String, dynamic> data) => StoreStruct(
        storeImage: data['storeImage'] as String?,
        address: data['address'] as String?,
        formattedAddress: data['formattedAddress'] as String?,
      );

  static StoreStruct? maybeFromMap(dynamic data) =>
      data is Map ? StoreStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'storeImage': _storeImage,
        'address': _address,
        'formattedAddress': _formattedAddress,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'storeImage': serializeParam(
          _storeImage,
          ParamType.String,
        ),
        'address': serializeParam(
          _address,
          ParamType.String,
        ),
        'formattedAddress': serializeParam(
          _formattedAddress,
          ParamType.String,
        ),
      }.withoutNulls;

  static StoreStruct fromSerializableMap(Map<String, dynamic> data) =>
      StoreStruct(
        storeImage: deserializeParam(
          data['storeImage'],
          ParamType.String,
          false,
        ),
        address: deserializeParam(
          data['address'],
          ParamType.String,
          false,
        ),
        formattedAddress: deserializeParam(
          data['formattedAddress'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'StoreStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StoreStruct &&
        storeImage == other.storeImage &&
        address == other.address &&
        formattedAddress == other.formattedAddress;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([storeImage, address, formattedAddress]);
}

StoreStruct createStoreStruct({
  String? storeImage,
  String? address,
  String? formattedAddress,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    StoreStruct(
      storeImage: storeImage,
      address: address,
      formattedAddress: formattedAddress,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

StoreStruct? updateStoreStruct(
  StoreStruct? store, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    store
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addStoreStructData(
  Map<String, dynamic> firestoreData,
  StoreStruct? store,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (store == null) {
    return;
  }
  if (store.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && store.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final storeData = getStoreFirestoreData(store, forFieldValue);
  final nestedData = storeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = store.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getStoreFirestoreData(
  StoreStruct? store, [
  bool forFieldValue = false,
]) {
  if (store == null) {
    return {};
  }
  final firestoreData = mapToFirestore(store.toMap());

  // Add any Firestore field values
  store.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getStoreListFirestoreData(
  List<StoreStruct>? stores,
) =>
    stores?.map((e) => getStoreFirestoreData(e, true)).toList() ?? [];
