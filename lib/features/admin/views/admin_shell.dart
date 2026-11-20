import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/core/domain/app_role.dart';
import 'package:nexbanak/features/admin/views/admin_customers_view.dart';
import 'package:nexbanak/features/admin/views/admin_home_view.dart';
import 'package:nexbanak/features/admin/views/admin_more_view.dart';
import 'package:nexbanak/features/admin/views/admin_operations_views.dart';
import 'package:nexbanak/features/authentication/controllers/auth_controller.dart';
import 'package:nexbanak/shared/widgets/app_shell.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();
    return NexShell(
      tag: 'admin',
      role: AppRole.admin,
      onSignOut: auth.signOut,
      onNotificationTap: () => Get.toNamed(Routes.notifications),
      items: const <NavItem>[
        NavItem(label: 'Dashboard', icon: Icons.dashboard_rounded, page: AdminHomeView()),
        NavItem(label: 'Customers', icon: Icons.people_outline_rounded, page: AdminCustomersView()),
        NavItem(label: 'Accounts', icon: Icons.account_balance_wallet_rounded, page: AdminAccountsView()),
        NavItem(label: 'Transactions', icon: Icons.receipt_long_rounded, page: AdminTransactionsView()),
        NavItem(label: 'More', icon: Icons.apps_rounded, page: AdminMoreView()),
      ],
    );
  }
}
