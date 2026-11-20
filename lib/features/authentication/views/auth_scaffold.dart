import 'package:flutter/material.dart';
import 'package:nexbanak/app/constants/app_constants.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/nex_bank_logo.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              AppColors.darkNavy,
              AppColors.primaryNavy,
              AppColors.background,
              AppColors.background,
            ],
            stops: <double>[0, 0.24, 0.55, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    const Center(
                      child: NexBankLogo(light: true, showTagline: true, size: 46),
                    ),
                    const SizedBox(height: 36),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            if (AppConstants.useMock) const Center(child: DemoBanner()),
                            if (AppConstants.useMock) const SizedBox(height: 16),
                            Text(title, style: AppTextStyles.headlineMedium),
                            const SizedBox(height: 6),
                            Text(subtitle, style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 24),
                            child,
                          ],
                        ),
                      ),
                    ),
                    if (footer != null) ...<Widget>[
                      const SizedBox(height: 18),
                      footer!,
                    ],
                    const SizedBox(height: 30),
                    Text(
                      '© ${DateTime.now().year} NEXBANK • ${AppConstants.tagline}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
