import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/features/authentication/controllers/auth_controller.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/misc_cards.dart';

class EmployeeProfileView extends StatelessWidget {
  const EmployeeProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthService>().user;
    if (user == null) return const EmptyStateWidget(title: 'Not signed in');
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        Text('Employee profile', style: AppTextStyles.headlineMedium),
        const SizedBox(height: 18),
        ProfileCard(user: user),
        const SizedBox(height: 20),
        Card(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person_outline_rounded),
                title: const Text('Personal details'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Get.toNamed(Routes.profile),
              ),
              ListTile(
                leading: const Icon(Icons.shield_outlined),
                title: const Text('Security & password'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Get.toNamed(Routes.security),
              ),
              ListTile(
                leading: const Icon(Icons.history_rounded),
                title: const Text('Work history'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Get.toNamed(Routes.auditLogs),
              ),
              ListTile(
                leading: const Icon(Icons.notifications_none_rounded),
                title: const Text('Notifications'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Get.toNamed(Routes.notifications),
              ),
            ],
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
