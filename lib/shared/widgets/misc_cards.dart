import 'package:flutter/material.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/utils/formatters.dart';
import 'package:nexbanak/data/models/notification_model.dart';
import 'package:nexbanak/data/models/user_model.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.item, this.onTap});

  final NotificationModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final IconData icon = switch (item.type) {
      'transaction' => Icons.receipt_long_rounded,
      'security' => Icons.shield_rounded,
      'promotion' => Icons.local_offer_rounded,
      _ => Icons.notifications_rounded,
    };
    final Color color = item.type == 'security' ? AppColors.error : AppColors.secondaryBlue;
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 19),
      ),
      title: Text(item.title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: item.isRead ? FontWeight.w400 : FontWeight.w600,
          )),
      subtitle: Text(
        '${item.body}\n${Formatters.dateTime(item.time)}',
        style: AppTextStyles.bodySmall,
        maxLines: 2,
      ),
      isThreeLine: true,
      trailing: item.isRead
          ? null
          : Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.secondaryBlue, shape: BoxShape.circle)),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.user, this.onEdit});

  final UserModel user;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.primaryNavy,
              child: Text(Formatters.initials(user.name),
                  style: AppTextStyles.headlineSmall.copyWith(color: Colors.white)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(user.name, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 4),
                  Text(user.email, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 6),
                  Text('${user.role.label} • ${user.branch}',
                      style: AppTextStyles.labelSmall),
                ],
              ),
            ),
            if (onEdit != null)
              IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_rounded)),
          ],
        ),
      ),
    );
  }
}
