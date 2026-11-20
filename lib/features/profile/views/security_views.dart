import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/utils/formatters.dart';
import 'package:nexbanak/features/profile/controllers/profile_controller.dart';
import 'package:nexbanak/shared/widgets/buttons.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/input_fields.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController c = Get.find<ProfileController>();
    final TextEditingController oldPassword = TextEditingController();
    final TextEditingController newPassword = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Security settings')),
      body: ScreenScaffold(
        controller: c,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Change password', style: AppTextStyles.titleMedium),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Current password',
                      controller: oldPassword,
                      obscureText: true,
                      prefixIcon: Icons.lock_outline_rounded,
                      onChanged: (v) => c.oldPassword.value = v,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'New password',
                      controller: newPassword,
                      obscureText: true,
                      prefixIcon: Icons.lock_reset_rounded,
                      onChanged: (v) => c.newPassword.value = v,
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => PrimaryButton(
                        label: 'Update password',
                        isLoading: c.isLoading.value,
                        onPressed: c.changePassword,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Obx(
                () => SwitchListTile(
                  value: c.biometric.value,
                  onChanged: c.biometricSupported.value ? c.setBiometric : null,
                  secondary: const Icon(Icons.fingerprint_rounded),
                  title: const Text('Biometric sign-in'),
                  subtitle: Text(
                    c.biometricSupported.value
                        ? 'Use Face ID, fingerprint or device PIN'
                        : 'Not available on this device',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.devices_other_rounded),
                title: const Text('Login history & devices'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: c.openLoginHistory,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class LoginHistoryView extends StatelessWidget {
  const LoginHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController c = Get.find<ProfileController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Login history')),
      body: ScreenScaffold(
        controller: c,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Recent sign-ins', style: AppTextStyles.titleMedium),
            const SizedBox(height: 14),
            Obx(
              () => c.loginHistory.isEmpty
                  ? const EmptyStateWidget(title: 'No sign-in records')
                  : Card(
                      child: Column(
                        children: c.loginHistory
                            .map(
                              (s) => ListTile(
                                leading: const Icon(Icons.devices_rounded),
                                title: Text('${s['device'] ?? 'Unknown device'}',
                                    style: AppTextStyles.bodyLarge),
                                subtitle: Text(
                                  '${s['ip'] ?? '—'} • ${Formatters.dateTime(s['time'])}',
                                ),
                                trailing: s['current'] == true
                                    ? StatusChip(status: 'active')
                                    : null,
                              ),
                            )
                            .toList(),
                      ),
                    ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Help & support')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text('How can we help?', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.phone_in_talk_rounded),
                title: Text('Call support'),
                subtitle: Text('24/7 banking support: +1 800 555 0100'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.email_outlined),
                title: Text('Email us'),
                subtitle: Text('support@nexbank.example'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.chat_bubble_outline_rounded),
                title: Text('Live chat'),
                subtitle: Text('Average response time: under 2 minutes'),
              ),
            ),
            const SizedBox(height: 16),
            Text('Frequently asked questions', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            const Card(
              child: ExpansionTile(
                title: Text('How do I reset my password?'),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Use "Forgot password" on the sign-in screen to receive a verification code.'),
                  ),
                ],
              ),
            ),
            const Card(
              child: ExpansionTile(
                title: Text('When will my transfer arrive?'),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Internal NEXBANK transfers are confirmed by the backend immediately after authorization.'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
