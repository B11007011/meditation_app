import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6XqGhXEB6ZTKsh4tNEvE_mtlg56P5JMc',
    appId: '1:718755695095:android:ccfe9b254ce69d633506f2',
    messagingSenderId: '718755695095',
    projectId: 'trader-35173',
    storageBucket: 'trader-35173.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAzJJBk4JYzzUtD7ZqktdqXShg0-DqkyTE',
    appId: '1:718755695095:ios:da732061c1c31e633506f2',
    messagingSenderId: '718755695095',
    projectId: 'trader-35173',
    storageBucket: 'trader-35173.firebasestorage.app',
    iosBundleId: 'com.trader',
  );
}
