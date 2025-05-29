import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/controllers/theme_controller.dart';
import 'package:chatapp/routes/app_page.dart';
import 'package:chatapp/routes/app_route.dart';
import 'package:chatapp/utils/app_translation.dart';

import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Get.put(ThemeController());
  AppTranslation translations = AppTranslation();
  await translations.loadTranslations();
  runApp(MyApp(
    translations: translations,
  ));
}

class MyApp extends StatelessWidget {
  final AppTranslation translations;

  MyApp({super.key, required this.translations});
  final routeObserver = GetObserver();
  final ThemeController themeController = Get.find();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          locale: const Locale('en', 'US'), // Default locale
          fallbackLocale: const Locale('en', 'US'), // Fallback locale
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('km', 'KH'),
          ],

          translations: translations,
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: themeController.currentTheme,
          initialRoute: AppRoutes.home,
          getPages: AppPages.routes,
          navigatorObservers: [routeObserver],
          // home: HomeScreen(),
        ));
  }
}
