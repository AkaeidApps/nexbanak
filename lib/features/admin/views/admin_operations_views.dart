import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/features/admin/controllers/admin_operations_controller.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/filters.dart';
import 'package:nexbanak/shared/widgets/input_fields.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';
import 'package:nexbanak/shared/widgets/transaction_table.dart';

class AdminAccountsView extends StatelessWidget {
  const AdminAccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminOperationsController c = Get.find<AdminOperationsController>();
    final TextEditingController search = TextEditingController();
    return ScreenScaffold(
      controller: c,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Account management', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 18),
          NexSearchBar(controller: search, hint: 'Search accounts…', onChanged: (v) {
            c.search.value = v;
          }),
          const SizedBox(height: 16),
          Obx(
            () => c.filteredAccounts.isEmpty
                ? const EmptyStateWidget(title: 'No accounts found')
                : Card(
                    child: Column(
                      children: c.filteredAccounts
                          .map(
                            (a) => ListTile(
                              leading: const Icon(Icons.account_balance_wallet_rounded),
                              title: Text(a.name, style: AppTextStyles.bodyLarge),
                              subtitle: Text('${a.accountNumber} • ${a.type} • ${a.branch}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(a.balance, style: AppTextStyles.titleMedium),
                                  const SizedBox(width: 10),
                                  StatusChip(status: a.status),
                                ],
                              ),
                              onTap: () => Get.toNamed(Routes.accountDetail, arguments: a.id),
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class AdminTransactionsView extends StatelessWidget {
  const AdminTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminOperationsController c = Get.find<AdminOperationsController>();
    final TextEditingController search = TextEditingController();
    return ScreenScaffold(
      controller: c,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Transaction monitoring', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 18),
          NexSearchBar(
            controller: search,
            hint: 'Search transactions…',
            onChanged: (v) => c.search.value = v,
            onFilter: () async {
              final String? type = await Get.bottomSheet<String>(
                FilterBottomSheet<String>(
                  title: 'Filter by type',
                  initial: c.type.value,
                  options: const <FilterOption<String>>[
                    FilterOption<String>('all', 'All'),
                    FilterOption<String>('deposit', 'Deposits'),
                    FilterOption<String>('withdrawal', 'Withdrawals'),
                    FilterOption<String>('transfer', 'Transfers'),
                    FilterOption<String>('loan', 'Loans'),
                  ],
                ),
                backgroundColor: Theme.of(context).cardColor,
              );
              if (type != null) c.type.value = type;
            },
          ),
          const SizedBox(height: 16),
          Obx(
            () => TransactionTable(
              transactions: c.filteredTransactions.toList(),
              onRowTap: (txn) => Get.toNamed(Routes.transactionDetail, arguments: txn.id),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
