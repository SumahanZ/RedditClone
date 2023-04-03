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
    apiKey: 'AIzaSyATQoSN7XWXT7w6gysbK14ISK26PD1TCNI',
    appId: '1:380105337924:web:d04d031a3366554d216011',
    messagingSenderId: '380105337924',
    projectId: 'reddit-clone-tutorial-6a742',
    authDomain: 'reddit-clone-tutorial-6a742.firebaseapp.com',
    storageBucket: 'reddit-clone-tutorial-6a742.appspot.com',
    measurementId: 'G-F7TGCVH6PM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCD9spmiblqEXx6Q6T0X7aLpVlJCMK2zxo',
    appId: '1:380105337924:android:a5923e839fb0ae20216011',
    messagingSenderId: '380105337924',
    projectId: 'reddit-clone-tutorial-6a742',
    storageBucket: 'reddit-clone-tutorial-6a742.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1RfDhDFEmXAS9nMQCg4sqACe3LbTQ6Ko',
    appId: '1:380105337924:ios:0b1cab992127607f216011',
    messagingSenderId: '380105337924',
    projectId: 'reddit-clone-tutorial-6a742',
    storageBucket: 'reddit-clone-tutorial-6a742.appspot.com',
    iosClientId: '380105337924-bgjd6eqqr1rus1etheu3faoltlga23i8.apps.googleusercontent.com',
    iosBundleId: 'com.example.redditApp',
  );
}