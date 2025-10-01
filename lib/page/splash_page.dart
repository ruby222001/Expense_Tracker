import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_practise/controller/splash_controller.dart';

class SplashLoginPage extends StatelessWidget {
  SplashLoginPage({Key? key}) : super(key: key);

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Track Your Expense Daily!!!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            SizedBox(height: 10),
            Text(
              'Save smart, spend wiser ',
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.white),
            ),
            Image.asset(
              'assets/images/splash.jpg',
            ),

            Obx(() => Text(
                  authController.message.value,
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                )),

            const SizedBox(height: 12),
            GestureDetector(
                onTap: () => authController.authenticate(biometricOnly: false),
                child: Image.asset(
                  "assets/images/fingerprint.png",
                  height: 50,
                  color: Colors.white,
                )),
            // 🔹 PIN or Biometric (system dialog lets user pick)
          ],
        ),
      ),
    );
  }
}
