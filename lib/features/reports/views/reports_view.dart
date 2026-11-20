import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/utils/formatters.dart';
import 'package:nexbanak/features/settings/controllers/system_controller.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final SystemController c = Get.find<SystemController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: ScreenScaffold(
        controller: c,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Financial reports', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 14),
            Obx(
              () => DropdownButtonFormField<String>(
                initialValue: c.reportType.value,
                decoration: const InputDecoration(labelText: 'Report type'),
                items: const <DropdownMenuItem<String>>[
                  DropdownMenuItem(value: 'monthly', child: Text('Monthly performance')),
                  DropdownMenuItem(value: 'transactions', child: Text('Transactions')),
                  DropdownMenuItem(value: 'loans', child: Text('Loans')),
                ],
                onChanged: (String? value) {
                  if (value != null) {
                    c.reportType.value = value;
                    c.loadReport();
                  }
                },
              ),
            ),
            const SizedBox(height: 18),
            Obx(
              () => c.reportRows.isEmpty
                  ? const EmptyStateWidget(title: 'No report data')
                  : Card(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const <DataColumn>[
                            DataColumn(label: Text('Period')),
                            DataColumn(label: Text('Deposits')),
                            DataColumn(label: Text('Withdrawals')),
                            DataColumn(label: Text('Transactions')),
                          ],
                          rows: c.reportRows
                              .map(
                                (r) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text('${r['period'] ?? ''}')),
                                    DataCell(Text(Formatters.money(r['deposits']))),
                                    DataCell(Text(Formatters.money(r['withdrawals']))),
                                    DataCell(Text('${r['transactions'] ?? 0}')),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
