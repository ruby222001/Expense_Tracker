import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_practise/controller/splash_controller.dart';
import 'package:hive_practise/homepage.dart';

class SplashLoginPage extends StatelessWidget {
  SplashLoginPage({Key? key}) : super(key: key);

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(() => MyHomePage());
    });
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Track Your Expense Daily!!!',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
            ),
            SizedBox(height: 10),
            Text(
              'Save smart, spend wiser ',
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.black),
            ),
            Image.asset(
              'assets/images/expense.png',
            ),

            // Obx(() => Text(
            //       authController.message.value,
            //       style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            //       textAlign: TextAlign.center,
            //     )),

            // const SizedBox(height: 12),
            // GestureDetector(
            //     onTap: () => authController.authenticate(biometricOnly: false),
            //     child: Image.asset(
            //       "assets/images/fingerprint.png",
            //       height: 50,
            //       color: Colors.black,
            //     )),
            // 🔹 PIN or Biometric (system dialog lets user pick)
          ],
        ),
      ),
    );
  }
}
