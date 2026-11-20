import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/bindings/app_bindings.dart';
import 'package:nexbanak/app/constants/app_constants.dart';
import 'package:nexbanak/app/routes/app_pages.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_theme.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/core/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Storage must be ready before AuthService restores tokens and before any
  // controller reads a UI preference.
  await StorageService.instance.init();
  final AuthService auth = AuthService();
  await auth.init();
  Get.put<AuthService>(auth, permanent: true);

  runApp(
    NexBankApp(
      themeMode: _readThemeMode(
        StorageService.instance.getString(StorageService.themeKey),
      ),
    ),
  );
}

ThemeMode _readThemeMode(String? value) => switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

class NexBankApp extends StatelessWidget {
  const NexBankApp({super.key, required this.themeMode});

  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        initialRoute: Routes.splash,
        getPages: AppPages.pages,
        initialBinding: AppBinding(),
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 240),
      );
}
