// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyCZKdLZKJbvkQ72pwdUDlPQ7j492tL-rQE',
    appId: '1:943067878654:web:5c9375ca95fcb57cf681af',
    messagingSenderId: '943067878654',
    projectId: 'chat-app-47a0a',
    authDomain: 'chat-app-47a0a.firebaseapp.com',
    storageBucket: 'chat-app-47a0a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAj_ltxrOQIBS7RQhE_Gn1hurR7dzcnA1o',
    appId: '1:943067878654:android:7ac429c01db0d054f681af',
    messagingSenderId: '943067878654',
    projectId: 'chat-app-47a0a',
    storageBucket: 'chat-app-47a0a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCIzgBW-QxTT3Tcn5k-mJzdJhX1IxEKZIM',
    appId: '1:943067878654:ios:8be7d6173177610af681af',
    messagingSenderId: '943067878654',
    projectId: 'chat-app-47a0a',
    storageBucket: 'chat-app-47a0a.appspot.com',
    iosClientId:
        '943067878654-94mr89nsp36hskabvnr6c79cp0om3m9r.apps.googleusercontent.com',
    iosBundleId: 'com.chat.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCIzgBW-QxTT3Tcn5k-mJzdJhX1IxEKZIM',
    appId: '1:943067878654:ios:8be7d6173177610af681af',
    messagingSenderId: '943067878654',
    projectId: 'chat-app-47a0a',
    storageBucket: 'chat-app-47a0a.appspot.com',
    iosClientId:
        '943067878654-94mr89nsp36hskabvnr6c79cp0om3m9r.apps.googleusercontent.com',
    iosBundleId: 'com.chat.chatApp',
  );
}
