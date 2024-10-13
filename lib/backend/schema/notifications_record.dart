import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificationsRecord extends FirestoreRecord {
  NotificationsRecord._(
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

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "viewed" field.
  bool? _viewed;
  bool get viewed => _viewed ?? false;
  bool hasViewed() => _viewed != null;

  // "dynamicRoute" field.
  String? _dynamicRoute;
  String get dynamicRoute => _dynamicRoute ?? '';
  bool hasDynamicRoute() => _dynamicRoute != null;

  // "paramsForRoute" field.
  dynamic _paramsForRoute;
  dynamic get paramsForRoute => _paramsForRoute;
  bool hasParamsForRoute() => _paramsForRoute != null;

  // "paramsForRouteAsString" field.
  String? _paramsForRouteAsString;
  String get paramsForRouteAsString => _paramsForRouteAsString ?? '';
  bool hasParamsForRouteAsString() => _paramsForRouteAsString != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "belongs_to" field.
  DocumentReference? _belongsTo;
  DocumentReference? get belongsTo => _belongsTo;
  bool hasBelongsTo() => _belongsTo != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _description = snapshotData['description'] as String?;
    _image = snapshotData['image'] as String?;
    _viewed = snapshotData['viewed'] as bool?;
    _dynamicRoute = snapshotData['dynamic_route'] as String?;
    _paramsForRoute = snapshotData['params_for_route'] as dynamic;
    _paramsForRouteAsString = snapshotData['params_for_route_as_string'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _belongsTo = snapshotData['belongs_to'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('notificacoes');

  static Stream<NotificationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NotificationsRecord.fromSnapshot(s));

  static Future<NotificationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NotificationsRecord.fromSnapshot(s));

  static NotificationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NotificationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NotificationsRecord getDocumentFromData(
      Map<String, dynamic> data,
      DocumentReference reference,
      ) =>
      NotificationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NotificationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NotificationsRecord &&
          reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNotificationsRecordData({
  DateTime? createdTime,
  String? description,
  bool? viewed,
  String? title,
  String? image,
  String? link,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'viewed': viewed,
      'created_time': createdTime,
      'description': description,
      'title': title,
      'image': image,
      'link': link,
    }.withoutNulls,
  );

  return firestoreData;
}

class NotificationsRecordDocumentEquality implements Equality<NotificationsRecord> {
  const NotificationsRecordDocumentEquality();

  @override
  bool equals(NotificationsRecord? e1, NotificationsRecord? e2) {
    return e1?.createdTime == e2?.createdTime &&
        e1?.description == e2?.description &&
        e1?.title == e2?.title &&
        e1?.image == e2?.image;
  }

  @override
  int hash(NotificationsRecord? e) => const ListEquality()
      .hash([e?.createdTime, e?.description, e?.title, e?.image]);

  @override
  bool isValidKey(Object? o) => o is NotificationsRecord;
}
