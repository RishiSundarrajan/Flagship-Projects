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
        return windows;
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
    apiKey: 'AIzaSyCs4PKYOD0l7Yc2dLqAwarFxJu_mf2f2Hc',
    appId: '1:724569648214:web:22fccd39edf066e90fdff7',
    messagingSenderId: '724569648214',
    projectId: 'curio-campus',
    authDomain: 'curio-campus.firebaseapp.com',
    storageBucket: 'curio-campus.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBd0t9JnKJ_TvSvXQ4WocFuoPxiARbvKac',
    appId: '1:724569648214:android:f3da468a1bfc1cfa0fdff7',
    messagingSenderId: '724569648214',
    projectId: 'curio-campus',
    storageBucket: 'curio-campus.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCTKwSPSbpvjAj62c7X-ye-pMuskB6w2oE',
    appId: '1:724569648214:ios:f9195c6dce2d4f9d0fdff7',
    messagingSenderId: '724569648214',
    projectId: 'curio-campus',
    storageBucket: 'curio-campus.appspot.com',
    iosClientId: '724569648214-fef16uks28cv766cg7799p1p4i0u9f4i.apps.googleusercontent.com',
    iosBundleId: 'com.example.curio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCTKwSPSbpvjAj62c7X-ye-pMuskB6w2oE',
    appId: '1:724569648214:ios:f9195c6dce2d4f9d0fdff7',
    messagingSenderId: '724569648214',
    projectId: 'curio-campus',
    storageBucket: 'curio-campus.appspot.com',
    iosClientId: '724569648214-fef16uks28cv766cg7799p1p4i0u9f4i.apps.googleusercontent.com',
    iosBundleId: 'com.example.curio',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCs4PKYOD0l7Yc2dLqAwarFxJu_mf2f2Hc',
    appId: '1:724569648214:web:b5fecaebe67e87420fdff7',
    messagingSenderId: '724569648214',
    projectId: 'curio-campus',
    authDomain: 'curio-campus.firebaseapp.com',
    storageBucket: 'curio-campus.appspot.com',
  );
}
