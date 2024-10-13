import 'dart:async';
import 'dart:ffi';

import 'package:collection/collection.dart';
import 'package:dona_do_santo/backend/schema/structs/store_struct.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PedidosRecord extends FirestoreRecord {
  PedidosRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "expiration_time" field.
  DateTime? _expirationTime;
  DateTime? get expirationTime => _expirationTime;
  bool hasExpirationTime() => _expirationTime != null;

  // "qr_code" field.
  String? _qrCode;
  String get qrCode => _qrCode ?? '';
  bool hasQrCode() => _qrCode != null;


  // "payment_status" field.
  String? _paymentStatus;
  String get paymentStatus => _paymentStatus ?? '';
  bool hasPaymentStatus() => _paymentStatus != null;

  // "item_to_pay" field.
  DocumentReference? _itemToPay;
  DocumentReference? get itemToPay => _itemToPay;
  bool hasItemToPay() => _itemToPay != null;

  // "buyer" field.
  DocumentReference? _buyer;
  DocumentReference? get buyer => _buyer;
  bool hasBuyer() => _buyer != null;

  // "vendor" field.
  DocumentReference? _vendor;
  DocumentReference? get vendor => _vendor;
  bool hasVendor() => _vendor != null;

  // "buyer_store" field.
  StoreStruct? _buyerStore;
  StoreStruct get buyerStore => _buyerStore ?? StoreStruct();
  bool hasBuyerStore() => _buyerStore != null;

  // "vendor_store" field.
  StoreStruct? _vendorStore;
  StoreStruct get vendorStore => _vendorStore ?? StoreStruct();
  bool hasVendorStore() => _vendorStore != null;

  // "payment_value" field.
  double? _paymentValue;
  double get paymentValue => _paymentValue ?? 0.0;
  bool hasPaymentValue() => _paymentValue != null;

  // "company_share" field.
  double? _companyShare;
  double get companyShare => _companyShare ?? 0.0;

  // "delivery_status" field.
  String? _deliveryStatus;
  String get deliveryStatus => _deliveryStatus ?? '';
  bool hasDeliveryStatus() => _deliveryStatus != null;

  // "item_title" field.
  String? _itemTitle;
  String get itemTitle => _itemTitle ?? '';
  bool hasItemTitle() => _itemTitle != null;

  // "item_image" field.
  String? _itemImage;
  String get itemImage => _itemImage ?? '';
  bool hasItemImage() => _itemImage != null;

  // "estimated_arrival_time" field.
  DateTime? _estimatedArrivalTime;
  DateTime get estimatedArrivalTime => _estimatedArrivalTime ?? DateTime.now();
  bool hasEstimatedArrivalTime() => _estimatedArrivalTime != null;

  // "item_title" field.
  String? _buyerEmail;
  String get buyerEmail => _buyerEmail ?? '';

  // "item_title" field.
  String? _vendorEmail;
  String get vendorEmail => _vendorEmail ?? '';

  // "payment_id" field.
  String? _paymentId;
  String get paymentId => _paymentId ?? '';

  // "delivery_date" field.
  DateTime? _deliveryDate;
  DateTime get deliveryDate => _deliveryDate ?? DateTime.now();

  void _initializeFields() {
    _createdTime = snapshotData['created_time'] as DateTime?;
    _expirationTime = snapshotData['expiration_time'] as DateTime?;
    _qrCode = snapshotData['qr_code'] as String?;
    _paymentStatus = snapshotData['payment_status'] as String?;
    _itemToPay = snapshotData['item_to_pay'] as DocumentReference?;
    _buyer = snapshotData['buyer'] as DocumentReference?;
    _vendor = snapshotData['vendor'] as DocumentReference?;
    _buyerStore = StoreStruct.maybeFromMap(snapshotData['buyer_store']);
    _vendorStore = StoreStruct.maybeFromMap(snapshotData['vendor_store']);
    _paymentValue = castToType<double>(snapshotData['payment_value']);
    _deliveryStatus = snapshotData['delivery_status'] as String?;
    _estimatedArrivalTime = snapshotData['estimated_arrival_time'] as DateTime?;
    _buyerEmail = snapshotData['buyer_email'] as String?;
    _vendorEmail = snapshotData['vendor_email'] as String?;
    _itemImage = snapshotData['item_image'] as String?;
    _itemTitle = snapshotData['item_title'] as String?;
    _companyShare = snapshotData["company_share"] as double?;
    _paymentId = snapshotData['payment_id'] as String?;
    _deliveryDate = snapshotData['delivery_date'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('pedidos');

  static Stream<PedidosRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PedidosRecord.fromSnapshot(s));

  static Future<PedidosRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PedidosRecord.fromSnapshot(s));

  static PedidosRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PedidosRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PedidosRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PedidosRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PedidosRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PedidosRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPedidosRecordData({
  DateTime? createdTime,
  DateTime? expirationTime,
  String? qrCode,
  String? paymentStatus,
  DocumentReference? itemToPay,
  DocumentReference? buyer,
  DocumentReference? vendor,
  StoreStruct? buyerStore,
  StoreStruct? vendorStore,
  double? paymentValue,
  String? deliveryStatus,
  DateTime? estimatedArrivalTime,
  String? itemTitle,
  String? itemImage,
  String? buyerEmail,
  String? vendorEmail,
  double? companyShare,
  String? paymentId,
  DateTime? deliveryDate,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'created_time': createdTime,
      'expiration_time': expirationTime,
      'qr_code': qrCode,
      'payment_status': paymentStatus,
      'item_to_pay': itemToPay,
      'buyer': buyer,
      'vendor': vendor,
      'buyer_store': StoreStruct().toMap(),
      'vendor_store': StoreStruct().toMap(),
      'payment_value': paymentValue,
      'delivery_status': deliveryStatus,
      'estimated_arrival_time': estimatedArrivalTime,
      'item_title': itemTitle,
      'item_image': itemImage,
      'buyer_email': buyerEmail,
      'vendor_email': vendorEmail,
      'company_share': companyShare,
      'payment_id': paymentId,
      'delivery_date': deliveryDate
    }.withoutNulls,
  );

  // Handle nested data for "buyer_store" field.
  addStoreStructData(firestoreData, buyerStore, 'buyer_store');

  // Handle nested data for "vendor_store" field.
  addStoreStructData(firestoreData, vendorStore, 'vendor_store');

  return firestoreData;
}

class PedidosRecordDocumentEquality implements Equality<PedidosRecord> {
  const PedidosRecordDocumentEquality();

  @override
  bool equals(PedidosRecord? e1, PedidosRecord? e2) {
    return e1?.createdTime == e2?.createdTime &&
        e1?.expirationTime == e2?.expirationTime &&
        e1?.qrCode == e2?.qrCode &&
        e1?.paymentStatus == e2?.paymentStatus &&
        e1?.itemToPay == e2?.itemToPay &&
        e1?.buyer == e2?.buyer &&
        e1?.vendor == e2?.vendor &&
        e1?.buyerStore == e2?.buyerStore &&
        e1?.vendorStore == e2?.vendorStore &&
        e1?.paymentValue == e2?.paymentValue &&
        e1?.deliveryStatus == e2?.deliveryStatus;
  }

  @override
  int hash(PedidosRecord? e) => const ListEquality().hash([
        e?.createdTime,
        e?.expirationTime,
        e?.qrCode,
        e?.paymentStatus,
        e?.itemToPay,
        e?.buyer,
        e?.vendor,
        e?.buyerStore,
        e?.vendorStore,
        e?.paymentValue,
        e?.deliveryStatus
      ]);

  @override
  bool isValidKey(Object? o) => o is PedidosRecord;
}
