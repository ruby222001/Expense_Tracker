import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4067749124990821/8860012770';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4067749124990821~8624124965';
    } else {
      throw UnsupportedError('Unsupported');
    }
  }

  static String get bannerInterstatialUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4067749124990821/6314187593';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4067749124990821/5616131320';
    } else {
      throw UnsupportedError('Unsupported');
    }
  }
}
