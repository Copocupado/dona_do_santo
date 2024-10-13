import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dona_do_santo/backend/schema/notifications_record.dart';
import 'package:dona_do_santo/pages/notifications/notifications_widget.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificationTokensRecord extends FirestoreRecord {
	NotificationTokensRecord._(
			super.reference,
			super.data,
			) {
		_initializeFields();
	}

	// "userReference" field.
	DocumentReference? _userReference;
	DocumentReference? get userReference => _userReference;
	bool hasUserReference() => _userReference != null;

	// "platform" field.
	String? _platform;
	String get platform => _platform ?? '';
	bool hasPlatform() => _platform != null;

	// "created_time" field.
	DateTime? _createdTime;
	DateTime? get createdTime => _createdTime;
	bool hasCreatedTime() => _createdTime != null;

	DocumentReference get parentReference => reference.parent.parent!;

	void _initializeFields() {
		_userReference = snapshotData['user_reference'] as DocumentReference?;
		_platform = snapshotData['platform'] as String?;
		_createdTime = snapshotData['created_time'] as DateTime?;
	}

	static CollectionReference get collection =>
			FirebaseFirestore.instance.collection('tokens_de_notificacao');

	static Stream<NotificationTokensRecord> getDocument(DocumentReference ref) =>
			ref.snapshots().map((s) => NotificationTokensRecord.fromSnapshot(s));

	static Future<NotificationTokensRecord> getDocumentOnce(DocumentReference ref) =>
			ref.get().then((s) => NotificationTokensRecord.fromSnapshot(s));

	static NotificationTokensRecord fromSnapshot(DocumentSnapshot snapshot) =>
			NotificationTokensRecord._(
				snapshot.reference,
				mapFromFirestore(snapshot.data() as Map<String, dynamic>),
			);

	static NotificationTokensRecord getDocumentFromData(
			Map<String, dynamic> data,
			DocumentReference reference,
			) =>
			NotificationTokensRecord._(reference, mapFromFirestore(data));

	@override
	String toString() =>
			'NotificationTokensRecord(reference: ${reference.path}, data: $snapshotData)';

	@override
	int get hashCode => reference.path.hashCode;

	@override
	bool operator ==(other) =>
			other is NotificationTokensRecord &&
					reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNotificationTokensRecordData({
	DocumentReference? userReference,
	String? platform,
	DateTime? createdTime,
}) {
	final firestoreData = mapToFirestore(
		<String, dynamic>{
			'user_reference': userReference,
			'platform': platform,
			'created_time': createdTime,
		}.withoutNulls,
	);

	return firestoreData;
}

class NotificationTokensRecordDocumentEquality
		implements Equality<NotificationTokensRecord> {
	const NotificationTokensRecordDocumentEquality();

	@override
	bool equals(NotificationTokensRecord? e1, NotificationTokensRecord? e2) {
		return e1?.userReference == e2?.userReference &&
				e1?.platform == e2?.platform &&
				e1?.createdTime == e2?.createdTime;
	}

	@override
	int hash(NotificationTokensRecord? e) =>
			const ListEquality().hash([e?.userReference, e?.platform, e?.createdTime]);

	@override
	bool isValidKey(Object? o) => o is NotificationTokensRecord;
}
