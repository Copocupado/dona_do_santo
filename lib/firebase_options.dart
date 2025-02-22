// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAsFywFEtX94E_d8pN30tfB4jBpNAPNEDg',
    appId: '1:696798996786:web:74253da3b84763410f8f2b',
    messagingSenderId: '696798996786',
    projectId: 'dona-do-santo-ujhc0y',
    authDomain: 'dona-do-santo-ujhc0y.firebaseapp.com',
    storageBucket: 'dona-do-santo-ujhc0y.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQs55Fagz0sp7WQ52vdjLZvLXFdzF0itY',
    appId: '1:696798996786:android:a13629bba5d1717d0f8f2b',
    messagingSenderId: '696798996786',
    projectId: 'dona-do-santo-ujhc0y',
    storageBucket: 'dona-do-santo-ujhc0y.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC9lHcXQn9d61QaDrmoiZbn3baZ1_BMPzU',
    appId: '1:696798996786:ios:99e6bb3f543b01bd0f8f2b',
    messagingSenderId: '696798996786',
    projectId: 'dona-do-santo-ujhc0y',
    storageBucket: 'dona-do-santo-ujhc0y.appspot.com',
    androidClientId: '696798996786-3uqe37uh9unck4qs92hdmqhe5kcocaoq.apps.googleusercontent.com',
    iosClientId: '696798996786-e07mtm0bgiqeon0pgh1jgi1n1rk39s7b.apps.googleusercontent.com',
    iosBundleId: 'com.mycompany.donadosanto.app',
  );

}