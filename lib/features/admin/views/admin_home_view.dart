import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/utils/formatters.dart';
import 'package:nexbanak/core/utils/responsive.dart';
import 'package:nexbanak/features/admin/controllers/admin_home_controller.dart';
import 'package:nexbanak/features/admin/controllers/approvals_controller.dart';
import 'package:nexbanak/shared/widgets/data_cards.dart';
import 'package:nexbanak/shared/widgets/financial_chart.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminHomeController c = Get.find<AdminHomeController>();
    final ApprovalsController approvals = Get.find<ApprovalsController>();

    return ScreenScaffold(
      controller: c,
      child: Obx(
        () {
          final stats = c.stats.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Enterprise overview', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 4),
              Text('Real-time pulse of your banking operation',
                  style: AppTextStyles.bodyMedium),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: context.responsive(mobile: 2, tablet: 3, desktop: 5),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.25,
                children: <Widget>[
                  StatCard(label: 'Total customers', value: '${stats?.totalCustomers ?? 0}', icon: Icons.people_outline_rounded),
                  StatCard(label: 'Total accounts', value: '${stats?.totalAccounts ?? 0}', icon: Icons.account_balance_wallet_rounded),
                  StatCard(label: 'Total deposits', value: Formatters.compact(double.tryParse(stats?.totalDeposits ?? '0') ?? 0), icon: Icons.south_west_rounded, color: const Color(0xFF059669)),
                  StatCard(label: 'Total withdrawals', value: Formatters.compact(double.tryParse(stats?.totalWithdrawals ?? '0') ?? 0), icon: Icons.north_east_rounded, color: const Color(0xFFC9A227)),
                  StatCard(label: 'Transactions', value: '${stats?.totalTransactions ?? 0}', icon: Icons.swap_horiz_rounded),
                  StatCard(label: 'Active loans', value: '${stats?.totalLoans ?? 0}', icon: Icons.account_balance_rounded),
                  StatCard(label: 'Active employees', value: '${stats?.activeEmployees ?? 0}', icon: Icons.badge_outlined),
                  StatCard(label: 'Branches', value: '${stats?.totalBranches ?? 0}', icon: Icons.location_city_outlined),
                  StatCard(label: 'Pending approvals', value: '${stats?.pendingApprovals ?? 0}', icon: Icons.pending_actions_rounded, color: const Color(0xFFD97706)),
                  StatCard(label: 'Suspicious activity', value: '${stats?.suspiciousTransactions ?? 0}', icon: Icons.warning_amber_rounded, color: const Color(0xFFDC2626)),
                ],
              ),
              const SizedBox(height: 22),
              FinancialChart(
                title: 'Financial performance',
                labels: AdminHomeController.monthLabels,
                primary: c.depositSeries,
                secondary: c.withdrawalSeries,
                primaryLabel: 'Deposits',
                secondaryLabel: 'Withdrawals',
                bar: true,
              ),
              const SizedBox(height: 22),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: FinancialChart(
                      title: 'Customer growth',
                      labels: AdminHomeController.monthLabels,
                      primary: stats?.customerGrowth ?? const <double>[],
                      primaryLabel: 'Customers',
                    ),
                  ),
                  if (!context.isMobile) ...<Widget>[
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Approval queue', style: AppTextStyles.titleMedium),
                              const SizedBox(height: 12),
                              ...approvals.items.take(4).map(
                                    (item) => ListTile(
                                      title: Text(item.customerName, style: AppTextStyles.bodyMedium),
                                      subtitle: Text('${item.type} • ${item.amount}'),
                                      trailing: const Icon(Icons.chevron_right_rounded),
                                      onTap: () => Get.toNamed(Routes.approvals),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}
