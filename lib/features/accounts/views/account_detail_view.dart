import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/services/receipt_service.dart';
import 'package:nexbanak/core/utils/formatters.dart';
import 'package:nexbanak/data/models/account_model.dart';
import 'package:nexbanak/data/models/transaction_model.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';
import 'package:nexbanak/shared/widgets/data_cards.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/transaction_table.dart';

class AccountDetailView extends StatefulWidget {
  const AccountDetailView({super.key});

  @override
  State<AccountDetailView> createState() => _AccountDetailViewState();
}

class _AccountDetailViewState extends State<AccountDetailView> {
  AccountModel? _account;
  List<TransactionModel> _transactions = <TransactionModel>[];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final String id = Get.arguments?.toString() ?? '';
    try {
      final banking = Get.find<RepositoryProvider>().banking;
      final AccountModel account = await banking.account(id);
      final List<TransactionModel> txns =
          await banking.transactions(accountId: id);
      if (!mounted) return;
      setState(() {
        _account = account;
        _transactions = txns;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AccountModel? account = _account;
    return Scaffold(
      appBar: AppBar(title: const Text('Account details')),
      body: _loading
          ? const LoadingWidget()
          : _error != null || account == null
              ? EmptyStateWidget(title: 'Unable to load account', message: _error, onAction: _load)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BalanceCard(
                        balance: account.balance,
                        accountNumber: account.accountNumber,
                        hidden: false,
                        onToggleVisibility: () {},
                        name: account.name,
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child: Column(
                          children: <Widget>[
                            _row('Account number', account.accountNumber),
                            _row('Type', account.type.toUpperCase()),
                            _row('Status', account.status.toUpperCase()),
                            _row('Branch', account.branch),
                            _row('Opened', Formatters.date(account.openedAt)),
                            if (account.interestRate != null)
                              _row('Interest rate', '${account.interestRate}%'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SectionHeader(
                        title: 'Account statement',
                        actionLabel: 'Download PDF',
                        onAction: () async {
                          await Get.find<ReceiptService>().printStatement(account, _transactions);
                        },
                      ),
                      const SizedBox(height: 10),
                      TransactionTable(
                        transactions: _transactions,
                        onRowTap: (t) => Get.toNamed(Routes.transactionDetail, arguments: t.id),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
    );
  }

  Widget _row(String label, String value) => ListTile(
        title: Text(label, style: AppTextStyles.bodySmall),
        trailing: Text(value, style: AppTextStyles.titleMedium),
      );
}
