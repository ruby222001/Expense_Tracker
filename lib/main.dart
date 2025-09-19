import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_practise/homepage.dart';
import 'package:hive_practise/page/splash_page.dart';
import 'package:hive_practise/theme/theme.dart';

void main() async {
  Get.put(ThemeController());
  await Hive.initFlutter();
  await Hive.openBox('test');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final controller = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: controller.themeData,
      home: SplashLoginPage(),
    );
  }
}
