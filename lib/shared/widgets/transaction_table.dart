import 'package:flutter/material.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/utils/formatters.dart';
import 'package:nexbanak/data/models/transaction_model.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';

class TransactionTable extends StatelessWidget {
  const TransactionTable({
    super.key,
    required this.transactions,
    this.onRowTap,
    this.page = 1,
    this.totalPages = 1,
    this.onPageChanged,
  });

  final List<TransactionModel> transactions;
  final ValueChanged<TransactionModel>? onRowTap;
  final int page;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    if (transactions.isEmpty) {
      return const EmptyStateWidget(title: 'No transactions found');
    }
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                  dark ? AppColors.darkSurfaceAlt : AppColors.lightBlue),
              columns: const <DataColumn>[
                DataColumn(label: Text('Reference')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Status')),
              ],
              rows: transactions.map((TransactionModel t) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(t.reference, style: AppTextStyles.bodySmall)),
                    DataCell(ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 220),
                      child: Text(t.title, style: AppTextStyles.bodySmall,
                          overflow: TextOverflow.ellipsis),
                    )),
                    DataCell(Text(Formatters.date(t.date), style: AppTextStyles.bodySmall)),
                    DataCell(Text(t.type.toUpperCase(), style: AppTextStyles.bodySmall)),
                    DataCell(Text(
                      '${t.isCredit ? '+' : '−'}${Formatters.money(t.amount)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: t.isCredit ? AppColors.success : AppColors.textPrimary,
                      ),
                    )),
                    DataCell(StatusChip(status: t.status)),
                  ],
                  onSelectChanged: onRowTap == null ? null : (_) => onRowTap!(t),
                );
              }).toList(),
            ),
          ),
          if (totalPages > 1 && onPageChanged != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    onPressed: page > 1 ? () => onPageChanged!(page - 1) : null,
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Text('$page / $totalPages', style: AppTextStyles.bodySmall),
                  IconButton(
                    onPressed: page < totalPages ? () => onPageChanged!(page + 1) : null,
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
