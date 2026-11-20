import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/features/notifications/controllers/notifications_controller.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/misc_cards.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationsController c = Get.find<NotificationsController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: <Widget>[
          Obx(
            () => c.unreadCount > 0
                ? TextButton(onPressed: c.markAllRead, child: const Text('Mark all read'))
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: ScreenScaffold(
        controller: c,
        child: Obx(
          () => c.items.isEmpty
              ? const EmptyStateWidget(
                  title: 'No notifications', icon: Icons.notifications_none_rounded)
              : Card(
                  child: Column(
                    children: c.items
                        .map(
                          (n) => NotificationTile(
                            item: n,
                            onTap: () => c.markRead(n.id),
                          ),
                        )
                        .toList(),
                  ),
                ),
        ),
      ),
    );
  }
}
