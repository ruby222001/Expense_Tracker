import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';

class VersionHelper {
  static String? apkVersion;
  static String? appName;

  static bool? forceUpdate;

  static var androidAppId = "com.ayata.paradise";

  static var iosAppId = "1517972097";

  static final newVersion = NewVersionPlus(androidId: androidAppId);

  static basicStatusCheck() async {
    try {
      final status = await newVersion.getVersionStatus();
      if (status!.canUpdate) updateDialog('Xpensr');
      // ignore: empty_catches
    } catch (e) {}
  }

  static getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      Platform.isAndroid
          ? androidAppId = packageInfo.packageName
          : iosAppId = packageInfo.packageName;
      apkVersion = packageInfo.version;
      appName = packageInfo.appName;
    });
  }

  static void updateDialog(String appName) {
    Get.bottomSheet(
      WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Platform.isAndroid
                      ? Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/playstore.png',
                              height: 25,
                              width: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Google Play')
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/playstore.png',
                              height: 60,
                              width: 60,
                            ),
                            Text('App Store')
                          ],
                        ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                "Update $appName?",
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              Text(
                '$appName recommends that you update to the latest version. You cannot continue to use the app without updating.',
              ),
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[500],
                  ),
                  onPressed: () {
                    // // Get.back();
                    StoreRedirect.redirect(
                      androidAppId: androidAppId,
                      iOSAppId: iosAppId,
                    );
                  },
                  child: Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isDismissible: false,
      enableDrag: false,
    );
  }
}
