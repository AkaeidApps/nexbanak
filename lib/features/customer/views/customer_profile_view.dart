import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/features/authentication/controllers/auth_controller.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/misc_cards.dart';

class CustomerProfileView extends StatelessWidget {
  const CustomerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Get.find<AuthService>();
    final user = auth.user;
    if (user == null) return const EmptyStateWidget(title: 'Not signed in');

    final List<_Entry> entries = <_Entry>[
      _Entry('Personal details', Icons.person_outline_rounded, Routes.profile),
      _Entry('Security & password', Icons.shield_outlined, Routes.security),
      _Entry('Login history', Icons.history_rounded, Routes.loginHistory),
      _Entry('Loans', Icons.account_balance_rounded, Routes.loans),
      _Entry('Cards', Icons.credit_card_rounded, Routes.cards),
      _Entry('Savings goals & deposits', Icons.savings_rounded, Routes.savings),
      _Entry('Notifications', Icons.notifications_none_rounded, Routes.notifications),
      _Entry('Help & support', Icons.help_outline_rounded, Routes.help),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        Text('Profile & settings', style: AppTextStyles.headlineMedium),
        const SizedBox(height: 18),
        ProfileCard(user: user, onEdit: () => Get.toNamed(Routes.profile)),
        const SizedBox(height: 20),
        Card(
          child: Column(
            children: entries
                .map(
                  (entry) => ListTile(
                    leading: Icon(entry.icon, color: const Color(0xFF1D4ED8)),
                    title: Text(entry.label, style: AppTextStyles.bodyLarge),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Get.toNamed(entry.route),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: Get.find<AuthController>().signOut,
          icon: const Icon(Icons.logout_rounded, color: Colors.red),
          label: const Text('Sign out', style: TextStyle(color: Colors.red)),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

class _Entry {
  const _Entry(this.label, this.icon, this.route);
  final String label;
  final IconData icon;
  final String route;
}
