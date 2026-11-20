import 'package:flutter/material.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/utils/formatters.dart';
import 'package:nexbanak/data/models/account_model.dart';
import 'package:nexbanak/data/models/transaction_model.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
    required this.accountNumber,
    required this.hidden,
    required this.onToggleVisibility,
    this.name = 'Total balance',
    this.onTap,
  });

  final String balance;
  final String accountNumber;
  final bool hidden;
  final VoidCallback onToggleVisibility;
  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: <Color>[AppColors.darkNavy, AppColors.primaryNavy, AppColors.secondaryBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.primaryNavy.withValues(alpha: 0.28),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: -30,
              top: -50,
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 28),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(name,
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text('NEXBANK',
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.gold)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  hidden ? '••••••••' : Formatters.money(balance),
                  style: AppTextStyles.numeric.copyWith(color: Colors.white, fontSize: 32),
                ),
                const SizedBox(height: 18),
                Row(
                  children: <Widget>[
                    Text(Formatters.maskAccount(accountNumber),
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
                    const Spacer(),
                    IconButton(
                      onPressed: onToggleVisibility,
                      icon: Icon(
                        hidden ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      tooltip: hidden ? 'Show balance' : 'Hide balance',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.account,
    required this.hidden,
    this.onTap,
    this.selected = false,
  });

  final AccountModel account;
  final bool hidden;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: account.isSavings
                      ? AppColors.lightBlue
                      : AppColors.gold.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  account.isSavings ? Icons.savings_rounded : Icons.account_balance_wallet_rounded,
                  color: account.isSavings ? AppColors.secondaryBlue : AppColors.gold,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(account.name, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 4),
                    Text(Formatters.maskAccount(account.accountNumber),
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.mutedText(dark))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    hidden ? '•••••' : Formatters.money(account.balance),
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  StatusChip(status: account.status),
                ],
              ),
              if (selected) ...<Widget>[
                const SizedBox(width: 10),
                const Icon(Icons.check_circle, color: AppColors.success),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.transaction,
    this.onTap,
    this.hidden = false,
  });

  final TransactionModel transaction;
  final VoidCallback? onTap;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final IconData icon = switch (transaction.type) {
      'deposit' => Icons.arrow_downward_rounded,
      'withdrawal' => Icons.local_atm_rounded,
      'transfer' => Icons.swap_horiz_rounded,
      'loan' => Icons.account_balance_rounded,
      _ => Icons.credit_card_rounded,
    };
    final Color color = transaction.isCredit ? AppColors.success : AppColors.primaryNavy;
    final bool isPending = transaction.status.toLowerCase() != 'completed';

    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(transaction.title,
          style: AppTextStyles.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${Formatters.date(transaction.date)} • ${transaction.reference}',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.mutedText(dark)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            '${transaction.isCredit ? '+' : '−'}${hidden ? '••••' : Formatters.money(transaction.amount)}',
            style: AppTextStyles.titleMedium.copyWith(color: color),
          ),
          const SizedBox(height: 3),
          if (isPending)
            StatusChip(status: transaction.status)
          else
            Text(transaction.category,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.mutedText(dark))),
        ],
      ),
    );
  }
}

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.secondaryBlue,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline(Theme.of(context).brightness == Brightness.dark)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(label,
                style: AppTextStyles.labelSmall.copyWith(fontSize: 11),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.secondaryBlue,
    this.subtitle,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
                const Spacer(),
                if (subtitle != null)
                  Flexible(
                    child: Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.mutedText(dark), fontSize: 10),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelSmall
                  .copyWith(color: AppColors.mutedText(dark), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
