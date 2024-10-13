import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../auth/firebase_auth/auth_util.dart';
import '../schema/notification_tokens_record.dart';
import 'dart:io';

class FirebaseApi {

/*  final GoRouter goRouter;

  FirebaseApi({required this.goRouter});*/

  static final firebaseMessaging = FirebaseMessaging.instance;
  static late final String? fcmToken;
  /*final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();*/

  static Future initFirebase() async {
    if (kIsWeb) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyAsFywFEtX94E_d8pN30tfB4jBpNAPNEDg",
              authDomain: "dona-do-santo-ujhc0y.firebaseapp.com",
              projectId: "dona-do-santo-ujhc0y",
              storageBucket: "dona-do-santo-ujhc0y.appspot.com",
              messagingSenderId: "696798996786",
              appId: "1:696798996786:web:e75938a9ccb957e40f8f2b"));
    } else {
      await Firebase.initializeApp();
    }
    fcmToken = await returnFcmToken();
  }
  /*void handleMessage(RemoteMessage? message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      goRouter.go('/notifications');
    });
  }


  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    handleMessage(message);
  }

  Future<void> initPushNotifications() async {
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleMessage(message);
    });

    // Handle messages when the app is in the background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }*/


  static Future<void> initNotifications() async{
    try {
      await NotificationTokensRecord.collection
          .doc(fcmToken)
          .set(createNotificationTokensRecordData(
        platform: Platform.operatingSystem,
        createdTime: getCurrentTimestamp,
        userReference: currentUserReference,
      ));
    } catch (e) {
      print('Error checking document existence: $e');
    }
  }

  static Future<void> disableNotifications() async{
    try {
      var docRef = FirebaseFirestore.instance.collection('tokens_de_notificacao').doc(fcmToken);
      await docRef.delete();
    } catch (e) {
      print('Error checking document existence: $e');
    }
  }

  static Future<String?> returnFcmToken() async {
    await firebaseMessaging.requestPermission();
    return await firebaseMessaging.getToken();
  }
}



