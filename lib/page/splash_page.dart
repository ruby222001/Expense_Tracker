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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Track Your Expense Daily!!!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              SizedBox(
                height: 10,
              ),
              Image.asset('assets/images/expense1.jpg'),
              SizedBox(
                height: 30,
              ),
              Obx(() => Text(
                    authController.message.value,
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(height: 50),

              // 🔹 Fingerprint only
              // ElevatedButton.icon(
              //   onPressed: () =>
              //       authController.authenticate(biometricOnly: true),
              //   icon: const Icon(Icons.fingerprint),
              //   label: const Text("Use Fingerprint"),
              //   style: ElevatedButton.styleFrom(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              //   ),
              // ),

              const SizedBox(height: 12),

              // 🔹 PIN or Biometric (system dialog lets user pick)
              ElevatedButton.icon(
                onPressed: () =>
                    authController.authenticate(biometricOnly: false),
                icon: const Icon(Icons.lock),
                label: const Text("Use PIN or Biometric"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
