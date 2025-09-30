import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_practise/homepage.dart';
import 'package:hive_practise/page/splash_page.dart';
import 'package:hive_practise/services/version_helper.dart';
import 'package:hive_practise/theme/theme.dart';

void main() async {
  Get.put(ThemeController());
  await Hive.initFlutter();
  await Hive.openBox('test');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = Get.put(ThemeController());
  @override
  void initState() {
    super.initState();
    VersionHelper.basicStatusCheck();
  }

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
