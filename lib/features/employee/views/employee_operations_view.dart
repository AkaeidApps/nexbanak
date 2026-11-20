import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/features/employee/controllers/employee_controller.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';
import 'package:nexbanak/shared/widgets/transaction_table.dart';

class EmployeeOperationsView extends StatelessWidget {
  const EmployeeOperationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final EmployeeController c = Get.find<EmployeeController>();

    return ScreenScaffold(
      controller: c,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Operations', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 4),
          Text('Process requests and monitor financial activity',
              style: AppTextStyles.bodyMedium),
          const SizedBox(height: 18),
          Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.pending_actions_rounded),
                  title: Text('Deposit & withdrawal processing', style: AppTextStyles.titleMedium),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Get.toNamed(Routes.approvals),
                ),
                ListTile(
                  leading: const Icon(Icons.verified_user_outlined),
                  title: Text('Account & KYC verification', style: AppTextStyles.titleMedium),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Get.toNamed(Routes.kyc),
                ),
                ListTile(
                  leading: const Icon(Icons.account_balance_rounded),
                  title: Text('Loan application review', style: AppTextStyles.titleMedium),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Get.toNamed(Routes.approvals),
                ),
                ListTile(
                  leading: const Icon(Icons.history_rounded),
                  title: Text('Work history', style: AppTextStyles.titleMedium),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Get.toNamed(Routes.auditLogs),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SectionHeader(title: 'Transaction monitoring'),
          const SizedBox(height: 10),
          Obx(
            () => TransactionTable(
              // Materialize inside Obx so the RxList read is tracked here.
              transactions: c.transactions.toList(),
              onRowTap: (t) => Get.toNamed(Routes.transactionDetail, arguments: t.id),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
