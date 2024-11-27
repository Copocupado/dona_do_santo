import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dona_do_santo/flutter_flow/flutter_flow_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

import '../../firebase_options.dart';
import '../../auth/firebase_auth/auth_util.dart';
import '../schema/notification_tokens_record.dart';
import 'dart:io';

class FirebaseApi {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String? fcmToken;

  static Future<bool> initFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      return true;
    } on FirebaseException catch (e) {

      _logError('Firebase Initialization Error', {
        'code': e.code,
        'message': e.message,
      });
      return false;
    } on PlatformException catch (e) {
      _logError('Platform Initialization Error', {
        'code': e.code,
        'message': e.message,
      });
      return false;
    } catch (e) {

      _logError('Unexpected Firebase Initialization Error', {
        'error': e.toString(),
      });
      return false;
    }
  }


  static Future<bool> initNotifications() async {
    try {
      // Request notification permissions
      final NotificationSettings permissionResult =
      await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      switch (permissionResult.authorizationStatus) {
        case AuthorizationStatus.authorized:
        case AuthorizationStatus.provisional:
          fcmToken = await _safeGetFcmToken();

          if (fcmToken == null) {
            _logError('FCM Token Retrieval Failed', {
              'message': 'Unable to obtain FCM token'
            });
            return false;
          }

          await _saveNotificationToken(fcmToken!);
          return true;

        case AuthorizationStatus.denied:
          _logError('Notification Permissions', {
            'status': 'Denied',
            'message': 'User denied notification permissions'
          });
          return false;

        case AuthorizationStatus.notDetermined:
          _logError('Notification Permissions', {
            'status': 'Not Determined',
            'message': 'Notification permissions not determined'
          });
          return false;
      }
    } catch (e) {
      _logError('Notification Initialization Error', {
        'error': e.toString(),
      });
      return false;
    }
  }

  static Future<String?> _safeGetFcmToken() async {
    try {
      return await firebaseMessaging.getToken().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          _logError('FCM Token Retrieval', {
            'message': 'Token retrieval timed out'
          });
          return null;
        },
      );
    } catch (e) {
      _logError('FCM Token Retrieval Error', {
        'error': e.toString(),
      });
      return null;
    }
  }

  static Future<void> _saveNotificationToken(String token) async {
    try {
      await NotificationTokensRecord.collection
          .doc(token)
          .set(createNotificationTokensRecordData(
        platform: Platform.operatingSystem,
        createdTime: getCurrentTimestamp,
        userReference: currentUserReference,
      ));
    } catch (e) {
      _logError('Notification Token Save Error', {
        'error': e.toString(),
        'token': token,
      });
    }
  }

  static Future<bool> disableNotifications() async {
    if (fcmToken == null) return false;

    try {
      var docRef = FirebaseFirestore.instance
          .collection('tokens_de_notificacao')
          .doc(fcmToken);

      await docRef.delete();
      fcmToken = null;
      return true;
    } catch (e) {
      _logError('Disable Notifications Error', {
        'error': e.toString(),
      });
      return false;
    }
  }

  static void _logError(String context, Map<String, dynamic> details) {
    print('FirebaseApi Error - $context');
    details.forEach((key, value) {
      print('  $key: $value');
    });

    try {
      FirebaseCrashlytics.instance.recordError(
        Exception(context),
        null, // Stack trace
        reason: details.toString(),
        information: details.entries
            .map((entry) => '${entry.key}: ${entry.value}')
            .toList(),
      );
    } catch (e) {
      print('Error logging to Crashlytics: $e');
    }
  }
}