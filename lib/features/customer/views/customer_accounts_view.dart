import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/features/accounts/controllers/accounts_controller.dart';
import 'package:nexbanak/shared/widgets/data_cards.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

class CustomerAccountsView extends StatelessWidget {
  const CustomerAccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountsController c = Get.find<AccountsController>();

    return ScreenScaffold(
      controller: c,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionHeader(
              title: 'My accounts',
              subtitle: '${c.accounts.length} accounts linked to your profile',
            ),
            const SizedBox(height: 16),
            if (c.accounts.isEmpty)
              const EmptyStateWidget(title: 'No accounts yet')
            else
              ...c.accounts.map(
                (account) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AccountCard(
                    account: account,
                    hidden: c.balanceHidden.value,
                    onTap: () => c.openDetail(account),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.add_circle_outline_rounded,
                    color: Color(0xFF1D4ED8)),
                title: Text('Open a new account', style: AppTextStyles.titleMedium),
                subtitle: const Text('Savings or current account request'),
                onTap: () => _showAccountRequestDialog(c),
              ),
            ),
            const SizedBox(height: 24),
            SectionHeader(title: 'Account services'),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.description_rounded),
                    title: const Text('Statements & history'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Get.toNamed(Routes.customerTransactions),
                  ),
                  ListTile(
                    leading: const Icon(Icons.savings_rounded),
                    title: const Text('Savings goals & fixed deposits'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Get.toNamed(Routes.savings),
                  ),
                  ListTile(
                    leading: const Icon(Icons.credit_card_rounded),
                    title: const Text('Debit & credit cards'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Get.toNamed(Routes.cards),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<void> _showAccountRequestDialog(AccountsController c) async {
    final TextEditingController name = TextEditingController();
    final bool? confirmed = await Get.dialog<bool>(
      StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Open a new account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Obx(
                () => DropdownButtonFormField<String>(
                  initialValue: c.requestType.value,
                  decoration: const InputDecoration(labelText: 'Account type'),
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem(value: 'savings', child: Text('Savings')),
                    DropdownMenuItem(value: 'current', child: Text('Current')),
                  ],
                  onChanged: (String? value) {
                    if (value != null) c.requestType.value = value;
                  },
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Account name'),
                onChanged: (v) => c.requestName.value = v,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
            FilledButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Submit request'),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true) await c.submitAccountRequest();
  }
}
