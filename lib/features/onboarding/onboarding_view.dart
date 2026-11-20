import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/constants/app_strings.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/services/storage_service.dart';
import 'package:nexbanak/shared/widgets/buttons.dart';
import 'package:nexbanak/shared/widgets/nex_bank_logo.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _page = PageController();
  int _index = 0;

  static const List<Map<String, String>> _pages = <Map<String, String>>[
    <String, String>{
      'title': 'Banking without boundaries',
      'body': 'Manage every account, card and transfer from one secure, intelligent platform.',
      'icon': 'account_balance',
    },
    <String, String>{
      'title': 'Move money with confidence',
      'body': 'Fast transfers, transparent approvals and receipts for every transaction.',
      'icon': 'swap_horiz',
    },
    <String, String>{
      'title': 'Built for tomorrow',
      'body': 'Premium security, real-time insights and a banking experience made for you.',
      'icon': 'shield',
    },
  ];

  Future<void> _finish() async {
    await StorageService.instance.setBool(StorageService.onboardingKey, true);
    Get.offAllNamed(Routes.login);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[AppColors.darkNavy, AppColors.primaryNavy, AppColors.secondaryBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: NexBankLogo(light: true, showTagline: true, size: 40),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _page,
                    itemCount: _pages.length,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(38),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Icon(
                              <IconData>[
                                Icons.account_balance_rounded,
                                Icons.swap_horiz_rounded,
                                Icons.shield_rounded,
                              ][i],
                              size: 68,
                              color: AppColors.gold,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            _pages[i]['title']!,
                            style: AppTextStyles.headlineLarge
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _pages[i]['body']!,
                            style: AppTextStyles.bodyLarge
                                .copyWith(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    _pages.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _index ? AppColors.gold : Colors.white38,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: PrimaryButton(
                    label: _index == _pages.length - 1 ? 'Get started' : 'Continue',
                    expand: true,
                    onPressed: () {
                      if (_index == _pages.length - 1) {
                        _finish();
                      } else {
                        _page.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),
                if (_index < _pages.length - 1)
                  TextButton(
                    onPressed: _finish,
                    child: const Text('Skip',
                        style: TextStyle(color: Colors.white70)),
                  ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.nextGenerationBanking,
                  style: AppTextStyles.labelSmall
                      .copyWith(color: Colors.white38),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
}
