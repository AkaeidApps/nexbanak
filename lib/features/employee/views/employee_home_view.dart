import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/core/utils/responsive.dart';
import 'package:nexbanak/features/admin/controllers/approvals_controller.dart';
import 'package:nexbanak/features/employee/controllers/employee_controller.dart';
import 'package:nexbanak/shared/widgets/data_cards.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

class EmployeeHomeView extends StatelessWidget {
  const EmployeeHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final EmployeeController c = Get.find<EmployeeController>();
    final ApprovalsController approvals = Get.find<ApprovalsController>();
    final String name = Get.find<AuthService>().user?.name ?? 'Employee';

    return ScreenScaffold(
      controller: c,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Good day, $name', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 4),
            Text('Your branch operations at a glance',
                style: AppTextStyles.bodyMedium),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: context.responsive(mobile: 2, tablet: 3, desktop: 4),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: <Widget>[
                StatCard(label: 'Pending approvals', value: '${approvals.items.length}', icon: Icons.pending_actions_rounded, color: const Color(0xFFD97706)),
                StatCard(label: 'KYC reviews', value: '${c.kyc.length}', icon: Icons.verified_user_outlined),
                StatCard(label: 'Customers', value: '${c.customers.length}', icon: Icons.people_outline_rounded),
                StatCard(label: 'Monitored transactions', value: '${c.transactions.length}', icon: Icons.receipt_long_rounded),
              ],
            ),
            const SizedBox(height: 22),
            SectionHeader(title: 'Priority queue', actionLabel: 'Open approvals', onAction: () => Get.toNamed(Routes.approvals)),
            const SizedBox(height: 10),
            Card(
              child: approvals.items.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('No pending approvals'),
                    )
                  : Column(
                      children: approvals.items
                          .take(5)
                          .map(
                            (item) => ListTile(
                              leading: const Icon(Icons.request_page_outlined),
                              title: Text('${item.type.toUpperCase()} • ${item.customerName}', style: AppTextStyles.bodyLarge),
                              subtitle: Text('${item.amount} • ${item.submittedAt}'),
                              trailing: const Icon(Icons.chevron_right_rounded),
                              onTap: () => Get.toNamed(Routes.approvals),
                            ),
                          )
                          .toList(),
                    ),
            ),
            const SizedBox(height: 18),
            SectionHeader(title: 'Recent work', actionLabel: 'Work history', onAction: () => Get.toNamed(Routes.auditLogs)),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: c.workHistory
                    .take(5)
                    .map(
                      (e) => ListTile(
                        leading: const Icon(Icons.history_rounded),
                        title: Text(e.action, style: AppTextStyles.bodyMedium),
                        subtitle: Text('$e.target • ${e.time}'),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
