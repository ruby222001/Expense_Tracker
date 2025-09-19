import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:hive_practise/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_practise/homepage.dart';

class AuthController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  var message = "Tap the button below to authenticate".obs;

  /// Biometric or PIN authentication
  Future<void> authenticate({bool biometricOnly = false}) async {
    try {
      bool canAuthenticate =
          await auth.canCheckBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        message.value = "Device does not support authentication.";
        return;
      }

      bool authenticated = await auth.authenticate(
        localizedReason: biometricOnly
            ? 'Scan your fingerprint to authenticate'
            : 'Authenticate using biometrics or device PIN',
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: biometricOnly, // 👈 false = allows PIN/Password too
        ),
      );

      if (authenticated) {
        message.value = "Authentication successful!";
        Get.offAll(() => MyHomePage());
      } else {
        message.value = "Authentication failed. Try again.";
      }
    } catch (e) {
      message.value = "Error: $e";
    }
  }
}
