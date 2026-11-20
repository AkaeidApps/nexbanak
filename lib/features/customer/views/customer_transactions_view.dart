import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/features/transactions/controllers/transactions_controller.dart';
import 'package:nexbanak/shared/widgets/filters.dart';
import 'package:nexbanak/shared/widgets/input_fields.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';
import 'package:nexbanak/shared/widgets/transaction_table.dart';

class CustomerTransactionsView extends StatelessWidget {
  const CustomerTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionsController c = Get.find<TransactionsController>();
    final Object? args = Get.arguments;
    if (args is String && c.accountId.value != args) {
      c.accountId.value = args;
      c.load();
    }
    final TextEditingController search = TextEditingController(text: c.search.value);

    return ScreenScaffold(
      controller: c,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Transactions', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 4),
          Text('Search, filter and download your transaction history',
              style: AppTextStyles.bodyMedium),
          const SizedBox(height: 18),
          NexSearchBar(
            controller: search,
            hint: 'Search by description or reference…',
            onChanged: c.onSearchChanged,
            onFilter: () => _openFilters(c),
          ),
          const SizedBox(height: 16),
          Obx(
            () => TransactionTable(
              transactions: c.transactions.toList(),
              onRowTap: c.openDetail,
              page: 1,
              totalPages: 1,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Future<void> _openFilters(TransactionsController c) async {
    final String? type = await Get.bottomSheet<String>(
      FilterBottomSheet<String>(
        title: 'Filter by type',
        initial: c.type.value,
        options: const <FilterOption<String>>[
          FilterOption<String>('all', 'All types'),
          FilterOption<String>('deposit', 'Deposits'),
          FilterOption<String>('withdrawal', 'Withdrawals'),
          FilterOption<String>('transfer', 'Transfers'),
          FilterOption<String>('loan', 'Loans'),
          FilterOption<String>('card', 'Card payments'),
        ],
      ),
      backgroundColor: Theme.of(Get.context!).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
    if (type != null) c.setFilter(type: type);
  }
}
