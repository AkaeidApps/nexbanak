import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/core/services/storage_service.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';
import 'package:nexbanak/shared/widgets/nex_bank_logo.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final bool onboardingSeen = StorageService.instance.getBool(
      StorageService.onboardingKey,
    );
    if (!onboardingSeen) {
      Get.offAllNamed(Routes.onboarding);
      return;
    }

    final AuthService auth = Get.find<AuthService>();
    if (auth.accessToken != null && auth.userId != null) {
      try {
        final user = await Get.find<RepositoryProvider>()
            .auth
            .currentUser(auth.userId!);
        auth.updateUser(user);
        Get.offAllNamed(user.role.homeRoute);
        return;
      } catch (_) {
        await auth.signOut();
      }
    }
    Get.offAllNamed(Routes.login);
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                AppColors.darkNavy,
                AppColors.primaryNavy,
                AppColors.secondaryBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                NexBankLogo(light: true, showTagline: true, size: 62),
                SizedBox(height: 48),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: AppColors.gold,
                    strokeWidth: 2.5,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'SECURE • SMART • GLOBAL',
                  style: TextStyle(
                    color: Color(0xFFC9A227),
                    fontSize: 10,
                    letterSpacing: 2,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
