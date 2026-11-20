import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/features/admin/controllers/admin_records_controller.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/filters.dart';
import 'package:nexbanak/shared/widgets/input_fields.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

/// Shared management table for customers, employees, branches and KYC.
class RecordsListView extends StatelessWidget {
  const RecordsListView({
    super.key,
    required this.tag,
    required this.title,
    required this.emptyHint,
  });

  final String tag;
  final String title;
  final String emptyHint;

  @override
  Widget build(BuildContext context) {
    final AdminRecordsController c =
        Get.find<AdminRecordsController>(tag: tag);
    final TextEditingController search = TextEditingController();

    return ScreenScaffold(
      controller: c,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: AppTextStyles.headlineMedium),
          const SizedBox(height: 4),
          Text('Search, filter and review records', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 18),
          NexSearchBar(
            controller: search,
            hint: 'Search $title.toLowerCase()…',
            onChanged: c.onSearch,
            onFilter: () => _openStatusFilter(c),
          ),
          const SizedBox(height: 16),
          Obx(
            () {
              if (tag == 'branches') {
                if (c.branches.isEmpty) {
                  return EmptyStateWidget(title: emptyHint);
                }
                return Card(
                  child: Column(
                    children: c.branches
                        .map(
                          (b) => ListTile(
                            leading: const Icon(Icons.location_city_outlined),
                            title: Text(b.name, style: AppTextStyles.bodyLarge),
                            subtitle: Text('${b.code} • ${b.city} • ${b.manager}'),
                            trailing: StatusChip(status: b.status),
                          ),
                        )
                        .toList(),
                  ),
                );
              }
              if (tag == 'kyc') {
                if (c.kyc.isEmpty) return EmptyStateWidget(title: emptyHint);
                return Card(
                  child: Column(
                    children: c.kyc
                        .map(
                          (k) => ListTile(
                            leading: const Icon(Icons.badge_outlined),
                            title: Text(k.customerName, style: AppTextStyles.bodyLarge),
                            subtitle: Text('${k.documentType} • ${k.submittedAt}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                StatusChip(status: k.status),
                                if (k.status == 'pending')
                                  PopupMenuButton<String>(
                                    onSelected: (v) => c.reviewKyc(k, v),
                                    itemBuilder: (_) => const <PopupMenuEntry<String>>[
                                      PopupMenuItem(value: 'verified', child: Text('Verify')),
                                      PopupMenuItem(value: 'rejected', child: Text('Reject')),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
              }
              if (c.people.isEmpty) return EmptyStateWidget(title: emptyHint);
              return Card(
                child: Column(
                  children: c.people
                      .map(
                        (p) => ListTile(
                          leading: CircleAvatar(
                            child: Text(p.name.isEmpty ? '?' : p.name[0]),
                          ),
                          title: Text(p.name, style: AppTextStyles.bodyLarge),
                          subtitle: Text('${p.email} • ${p.branch}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              StatusChip(status: p.status),
                              IconButton(
                                icon: const Icon(Icons.chevron_right_rounded),
                                onPressed: () => c.showPerson(p),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Future<void> _openStatusFilter(AdminRecordsController c) async {
    final String? status = await Get.bottomSheet<String>(
      FilterBottomSheet<String>(
        title: 'Filter by status',
        initial: c.status.value,
        options: const <FilterOption<String>>[
          FilterOption<String>('all', 'All'),
          FilterOption<String>('active', 'Active'),
          FilterOption<String>('pending', 'Pending'),
          FilterOption<String>('verified', 'Verified'),
          FilterOption<String>('rejected', 'Rejected'),
        ],
      ),
      backgroundColor: Theme.of(Get.context!).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
    if (status != null) c.onStatus(status);
  }
}
