import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/utils/formatters.dart';
import 'package:nexbanak/core/utils/responsive.dart';
import 'package:nexbanak/features/customer/controllers/customer_home_controller.dart';
import 'package:nexbanak/features/customer/views/services_views.dart';
import 'package:nexbanak/shared/widgets/animated_card.dart';
import 'package:nexbanak/shared/widgets/brand_icons.dart';
import 'package:nexbanak/shared/widgets/data_cards.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/financial_chart.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

class CustomerHomeView extends StatelessWidget {
  const CustomerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerHomeController c = Get.find<CustomerHomeController>();
    final String accountNumber =
        c.accounts.isNotEmpty ? c.accounts.first.accountNumber : '••••';

    return ScreenScaffold(
      controller: c,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${Formatters.greeting(DateTime.now())}, ${c.firstName}',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text('Here is your financial overview today.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 22),
            BalanceCard(
              balance: c.stats.value?.totalBalance ?? '0',
              accountNumber: accountNumber,
              hidden: c.balanceHidden.value,
              onToggleVisibility: c.toggleBalance,
              onTap: c.openAccounts,
            ),
            const SizedBox(height: 22),
            SectionHeader(title: 'Quick actions'),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: context.responsive(mobile: 2, tablet: 4, desktop: 4),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.22,
              children: <Widget>[
                QuickActionButton(
                  icon: Icons.swap_horiz_rounded,
                  label: 'Transfer',
                  onTap: c.openTransfer,
                  color: AppColors.success,
                ),
                QuickActionButton(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'MFS (bKash/Nagad)',
                  onTap: () => Get.to<dynamic>(() => const MfsTransferView()),
                  customWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      BrandIcons.bkash(size: 24),
                      const SizedBox(width: 4),
                      BrandIcons.nagad(size: 24),
                    ],
                  ),
                ),
                QuickActionButton(
                  icon: Icons.receipt_long_rounded,
                  label: 'Pay Bills',
                  onTap: () => Get.to<dynamic>(() => const BillPayView()),
                  color: AppColors.info,
                ),
                QuickActionButton(
                  icon: Icons.phone_android_rounded,
                  label: 'Top-up',
                  onTap: () => Get.to<dynamic>(() => const MobileTopupView()),
                  color: AppColors.gold,
                ),
                QuickActionButton(icon: Icons.south_west_rounded, label: 'Deposit', onTap: c.openDeposit),
                QuickActionButton(icon: Icons.north_east_rounded, label: 'Withdraw', onTap: c.openWithdrawal, color: AppColors.gold),
                QuickActionButton(icon: Icons.account_balance_rounded, label: 'Loans', onTap: c.openLoans),
                QuickActionButton(icon: Icons.credit_card_rounded, label: 'Cards', onTap: c.openCards, color: AppColors.gold),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: AnimatedCard(
                    borderRadius: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: FinancialChart(
                        title: 'Income vs expenses',
                        labels: const <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                        primary: c.stats.value?.monthlyIncome ?? const <double>[],
                        secondary: c.stats.value?.monthlyExpense ?? const <double>[],
                      ),
                    ),
                  ),
                ),
                if (!context.isMobile) ...<Widget>[
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: AnimatedCard(
                      borderRadius: 20,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('This month', style: AppTextStyles.titleMedium),
                            const SizedBox(height: 18),
                            _metric('Income', c.stats.value?.income ?? '0', AppColors.success),
                            const SizedBox(height: 14),
                            _metric('Expenses', c.stats.value?.expenses ?? '0', AppColors.error),
                            const SizedBox(height: 14),
                            _metric('Savings', c.stats.value?.savings ?? '0', AppColors.secondaryBlue),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'Recent transactions',
              actionLabel: 'View all',
              onAction: c.openTransactions,
            ),
            const SizedBox(height: 10),
            Column(
              children: c.recent
                  .map(
                    (txn) => TransactionCard(
                      transaction: txn,
                      hidden: c.balanceHidden.value,
                      onTap: () => Get.toNamed(Routes.transactionDetail, arguments: txn.id),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'Notifications',
              actionLabel: 'View all',
              onAction: c.openNotifications,
            ),
            const SizedBox(height: 10),
            ...c.notifications.take(3).map(
                  (n) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AnimatedCard(
                      borderRadius: 14,
                      child: ListTile(
                        leading: const Icon(Icons.notifications_none_rounded,
                            color: AppColors.secondaryBlue),
                        title: Text(n.title, style: AppTextStyles.bodyLarge),
                        subtitle: Text(
                          n.body,
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: c.openNotifications,
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

  Widget _metric(String label, String value, Color color) => Row(
        children: <Widget>[
          Container(width: 6, height: 34, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: AppTextStyles.bodySmall),
              Text(Formatters.money(value), style: AppTextStyles.titleMedium),
            ],
          ),
        ],
      );
}
