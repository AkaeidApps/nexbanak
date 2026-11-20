import 'package:flutter/material.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.message = 'Loading…'});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CircularProgressIndicator(color: AppColors.secondaryBlue),
            const SizedBox(height: 16),
            Text(message, style: AppTextStyles.bodyMedium),
          ],
        ),
      );
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_rounded,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, size: 34, color: AppColors.secondaryBlue),
              ),
              const SizedBox(height: 18),
              Text(title, style: AppTextStyles.titleMedium, textAlign: TextAlign.center),
              if (message != null) ...<Widget>[
                const SizedBox(height: 8),
                Text(message!,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center),
              ],
              if (onAction != null) ...<Widget>[
                const SizedBox(height: 18),
                OutlinedButton(onPressed: onAction, child: Text(actionLabel ?? 'Retry')),
              ],
            ],
          ),
        ),
      );
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final String s = status.toLowerCase();
    final Color color = switch (s) {
      'completed' || 'active' || 'approved' || 'verified' => AppColors.success,
      'pending' || 'processing' || 'review' => AppColors.warning,
      'rejected' || 'failed' || 'blocked' || 'frozen' || 'closed' => AppColors.error,
      _ => AppColors.textSecondary,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(color: color, fontSize: 10),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: AppTextStyles.headlineSmall),
                if (subtitle != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(subtitle!,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ],
            ),
          ),
          if (onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel ?? 'View all'),
            ),
        ],
      );
}

class DemoBanner extends StatelessWidget {
  const DemoBanner({super.key, this.dense = false});

  final bool dense;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: dense ? 8 : 12, vertical: dense ? 4 : 7),
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.science_outlined, size: 14, color: AppColors.gold),
            SizedBox(width: dense ? 4 : 6),
            Text('DEMO',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.gold, fontSize: dense ? 9 : 10,
                )),
          ],
        ),
      );
}
