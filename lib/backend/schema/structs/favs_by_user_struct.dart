// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FavsByUserStruct {
  DocumentReference? user;
  ValueNotifier<List<DocumentReference>?> reverseStoreItems;

  FavsByUserStruct({
    this.user,
    required this.reverseStoreItems,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user?.path, // Convert DocumentReference to a string (its path)
      'reverseStoreItems': reverseStoreItems.value?.map((e) => e.path).toList(),
    };
  }

  // Create `FavsByUserStruct` from JSON
  factory FavsByUserStruct.fromJson(Map<String, dynamic> json) {
    return FavsByUserStruct(
      user: FirebaseFirestore.instance.doc(json['user']),  // Convert path back to DocumentReference
      reverseStoreItems: ValueNotifier<List<DocumentReference>?>(json['reverseStoreItems'] != null
          ? List<DocumentReference>.from(
          (json['reverseStoreItems'] as List).map((e) => FirebaseFirestore.instance.doc(e)))
          : []),
    );
  }
}

