import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/utils/responsive.dart';

class AdminMoreView extends StatelessWidget {
  const AdminMoreView({super.key});

  static const List<_Module> _modules = <_Module>[
    _Module('Employees', Icons.badge_outlined, Routes.employees),
    _Module('Branches', Icons.location_city_outlined, Routes.branches),
    _Module('Deposits', Icons.south_west_rounded, Routes.adminTransactions),
    _Module('Withdrawals', Icons.north_east_rounded, Routes.adminTransactions),
    _Module('Transfers', Icons.swap_horiz_rounded, Routes.adminTransactions),
    _Module('Loans', Icons.account_balance_rounded, Routes.loans),
    _Module('Cards', Icons.credit_card_rounded, Routes.cards),
    _Module('KYC verification', Icons.verified_user_outlined, Routes.kyc),
    _Module('Approvals', Icons.pending_actions_rounded, Routes.approvals),
    _Module('Reports', Icons.assessment_outlined, Routes.reports),
    _Module('Audit logs', Icons.history_toggle_off_rounded, Routes.auditLogs),
    _Module('System settings', Icons.settings_outlined, Routes.settings),
    _Module('Security', Icons.shield_outlined, Routes.security),
    _Module('Notifications', Icons.notifications_none_rounded, Routes.notifications),
    _Module('Help & support', Icons.help_outline_rounded, Routes.help),
  ];

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text('All modules', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 4),
          Text('Enterprise administration tools', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: context.responsive(mobile: 2, tablet: 3, desktop: 5),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.25,
            children: _modules
                .map(
                  (m) => Card(
                    child: InkWell(
                      onTap: () => Get.toNamed(m.route),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.lightBlue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(m.icon, color: AppColors.secondaryBlue, size: 20),
                            ),
                            Text(m.label, style: AppTextStyles.labelLarge),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 30),
        ],
      );
}

class _Module {
  const _Module(this.label, this.icon, this.route);
  final String label;
  final IconData icon;
  final String route;
}
