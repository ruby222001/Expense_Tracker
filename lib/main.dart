import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_practise/page/splash_page.dart';
import 'package:hive_practise/services/version_helper.dart';
import 'package:hive_practise/theme/theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  Get.put(ThemeController());
  await Hive.initFlutter();
  await Hive.openBox('test');
  await MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = Get.put(ThemeController());
  @override
  void initState()  {
    super.initState();
     VersionHelper.basicStatusCheck();

  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Xpenser',
      debugShowCheckedModeBanner: false,
      theme: controller.themeData,
      home: SplashLoginPage(),
    );
  }
}
