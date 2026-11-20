import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/features/admin/controllers/approvals_controller.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/filters.dart';
import 'package:nexbanak/shared/widgets/input_fields.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

class ApprovalsView extends StatelessWidget {
  const ApprovalsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ApprovalsController c = Get.find<ApprovalsController>();
    final TextEditingController search = TextEditingController();

    return ScreenScaffold(
      controller: c,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Approval queue', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 4),
          Text('Maker–checker controls prevent self-approval',
              style: AppTextStyles.bodyMedium),
          const SizedBox(height: 18),
          NexSearchBar(
            controller: search,
            hint: 'Search requests…',
            onChanged: (v) => c.search.value = v,
            onFilter: () async {
              final String? type = await Get.bottomSheet<String>(
                FilterBottomSheet<String>(
                  title: 'Filter by type',
                  initial: c.filterType.value,
                  options: const <FilterOption<String>>[
                    FilterOption<String>('all', 'All'),
                    FilterOption<String>('deposit', 'Deposits'),
                    FilterOption<String>('withdrawal', 'Withdrawals'),
                    FilterOption<String>('account', 'Accounts'),
                    FilterOption<String>('loan', 'Loans'),
                  ],
                ),
                backgroundColor: Theme.of(context).cardColor,
              );
              if (type != null) {
                c.filterType.value = type;
                c.load();
              }
            },
          ),
          const SizedBox(height: 16),
          Obx(
            () => c.filtered.isEmpty
                ? const EmptyStateWidget(
                    title: 'No pending approvals',
                    message: 'Requests will appear here for authorized review.',
                    icon: Icons.pending_actions_rounded,
                  )
                : Column(
                    children: c.filtered
                        .map(
                          (item) => Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      StatusChip(status: item.status),
                                      const SizedBox(width: 10),
                                      Text(item.type.toUpperCase(),
                                          style: AppTextStyles.labelSmall),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(item.customerName,
                                      style: AppTextStyles.titleMedium),
                                  const SizedBox(height: 4),
                                  Text(item.description,
                                      style: AppTextStyles.bodySmall),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: <Widget>[
                                      Text('Amount: ${item.amount}',
                                          style: AppTextStyles.bodyMedium),
                                      const Spacer(),
                                      if (c.isSelfMaker(item))
                                        Text('Made by you — approval blocked',
                                            style: AppTextStyles.bodySmall.copyWith(
                                                color: const Color(0xFFDC2626)))
                                      else ...<Widget>[
                                        OutlinedButton(
                                          onPressed: () => c.reject(item),
                                          child: const Text('Reject'),
                                        ),
                                        const SizedBox(width: 8),
                                        FilledButton(
                                          onPressed: () => c.approve(item),
                                          child: const Text('Approve'),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
