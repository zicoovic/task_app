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
    apiKey: 'AIzaSyBeb1hUo7kR2j5Teb7L_S5Y3ZC7KOVOsyI',
    appId: '1:365030242859:web:b2e40a9da66540b93b486e',
    messagingSenderId: '365030242859',
    projectId: 'workos-250f0',
    authDomain: 'workos-250f0.firebaseapp.com',
    storageBucket: 'workos-250f0.appspot.com',
    measurementId: 'G-NL95B4D0BL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJHQRpaoWBg7Md6CfYBQD5yizuj6kJCHs',
    appId: '1:365030242859:android:49f58e238b0b44713b486e',
    messagingSenderId: '365030242859',
    projectId: 'workos-250f0',
    storageBucket: 'workos-250f0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUW8brBmtxLQRlYIUPN1GUhfCSXTXHhsU',
    appId: '1:365030242859:ios:34fa16108ccb5fa83b486e',
    messagingSenderId: '365030242859',
    projectId: 'workos-250f0',
    storageBucket: 'workos-250f0.appspot.com',
    iosClientId: '365030242859-plv53fheeoel1n667ovsgplmna33100h.apps.googleusercontent.com',
    iosBundleId: 'com.example.taskApp',
  );
}