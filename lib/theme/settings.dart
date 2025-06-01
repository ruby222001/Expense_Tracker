import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_practise/theme/theme.dart'; // Adjust path as needed

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find(); // Get the instance

    return Scaffold(
      backgroundColor: themeController.themeData.colorScheme.background,
      appBar: AppBar(title: const Text("Settings")),
      body: Container(
        decoration: BoxDecoration(
          color: themeController.themeData.colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Dark Mode",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Obx(() => CupertinoSwitch(
                  value: themeController.isDarkMode,
                  onChanged: (value) => themeController.toggleTheme(),
                )),
          ],
        ),
      ),
    );
  }
}
