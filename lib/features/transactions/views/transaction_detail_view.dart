import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/services/receipt_service.dart';
import 'package:nexbanak/core/utils/formatters.dart';
import 'package:nexbanak/data/models/transaction_model.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';
import 'package:nexbanak/shared/widgets/buttons.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';

class TransactionDetailView extends StatefulWidget {
  const TransactionDetailView({super.key});

  @override
  State<TransactionDetailView> createState() => _TransactionDetailViewState();
}

class _TransactionDetailViewState extends State<TransactionDetailView> {
  TransactionModel? _txn;
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
      final TransactionModel txn =
          await Get.find<RepositoryProvider>().banking.transaction(id);
      if (!mounted) return;
      setState(() {
        _txn = txn;
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
    final TransactionModel? t = _txn;
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction details')),
      body: _loading
          ? const LoadingWidget()
          : _error != null || t == null
              ? EmptyStateWidget(title: 'Unable to load transaction', message: _error, onAction: _load)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: <Widget>[
                              Icon(t.isCredit ? Icons.south_west_rounded : Icons.north_east_rounded,
                                  size: 44,
                                  color: t.isCredit
                                      ? const Color(0xFF059669)
                                      : const Color(0xFF0B1F3A)),
                              const SizedBox(height: 12),
                              Text(t.title, style: AppTextStyles.headlineSmall,
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 8),
                              Text(
                                '${t.isCredit ? '+' : '−'}${Formatters.money(t.amount)}',
                                style: AppTextStyles.numeric.copyWith(
                                  color: t.isCredit
                                      ? const Color(0xFF059669)
                                      : const Color(0xFF0B1F3A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              StatusChip(status: t.status),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        child: Column(
                          children: <Widget>[
                            _row('Reference', t.reference),
                            _row('Type', t.type.toUpperCase()),
                            _row('Date', Formatters.dateTime(t.date)),
                            _row('Category', t.category),
                            if (t.counterparty.isNotEmpty)
                              _row('Counterparty', t.counterparty),
                            if (t.note.isNotEmpty) _row('Note', t.note),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        label: 'Download receipt (PDF)',
                        icon: Icons.picture_as_pdf_rounded,
                        onPressed: () =>
                            Get.find<ReceiptService>().printReceipt(t),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
    );
  }

  Widget _row(String label, String value) => ListTile(
        title: Text(label, style: AppTextStyles.bodySmall),
        trailing: Text(value, style: AppTextStyles.bodyMedium),
      );
}
