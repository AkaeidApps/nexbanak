import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/core/domain/app_role.dart';
import 'package:nexbanak/features/authentication/controllers/auth_controller.dart';
import 'package:nexbanak/features/customer/views/customer_accounts_view.dart';
import 'package:nexbanak/features/customer/views/customer_home_view.dart';
import 'package:nexbanak/features/customer/views/customer_profile_view.dart';
import 'package:nexbanak/features/customer/views/customer_transactions_view.dart';
import 'package:nexbanak/features/customer/views/transfer_view.dart';
import 'package:nexbanak/shared/widgets/app_shell.dart';

class CustomerShell extends StatelessWidget {
  const CustomerShell({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();
    return NexShell(
      tag: 'customer',
      role: AppRole.customer,
      onSignOut: auth.signOut,
      onNotificationTap: () => Get.toNamed(Routes.notifications),
      items: const <NavItem>[
        NavItem(label: 'Home', icon: Icons.dashboard_rounded, page: CustomerHomeView()),
        NavItem(label: 'Accounts', icon: Icons.account_balance_wallet_rounded, page: CustomerAccountsView()),
        NavItem(label: 'Transfer', icon: Icons.swap_horiz_rounded, page: TransferView()),
        NavItem(label: 'Transactions', icon: Icons.receipt_long_rounded, page: CustomerTransactionsView()),
        NavItem(label: 'Profile', icon: Icons.person_outline_rounded, page: CustomerProfileView()),
      ],
    );
  }
}
