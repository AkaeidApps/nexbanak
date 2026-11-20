import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/features/settings/controllers/system_controller.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/input_fields.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

class AuditLogsView extends StatelessWidget {
  const AuditLogsView({super.key});

  @override
  Widget build(BuildContext context) {
    final SystemController c = Get.find<SystemController>();
    final TextEditingController search = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Audit logs')),
      body: ScreenScaffold(
        controller: c,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Immutable activity trail', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 14),
            NexSearchBar(
              controller: search,
              hint: 'Search actor or action…',
              onChanged: (v) {
                c.auditSearch.value = v;
                c.loadAll();
              },
            ),
            const SizedBox(height: 16),
            Obx(
              () => c.audit.isEmpty
                  ? const EmptyStateWidget(title: 'No audit events')
                  : Card(
                      child: Column(
                        children: c.audit
                            .map(
                              (e) => ListTile(
                                leading: Icon(
                                  e.risk == 'medium'
                                      ? Icons.warning_amber_rounded
                                      : Icons.history_rounded,
                                  color: e.risk == 'medium'
                                      ? const Color(0xFFD97706)
                                      : const Color(0xFF1D4ED8),
                                ),
                                title: Text(e.action, style: AppTextStyles.bodyLarge),
                                subtitle: Text('${e.actor} • ${e.target} • ${e.ip}'),
                                trailing: Text(e.time.substring(0, e.time.length.clamp(0, 16)),
                                    style: AppTextStyles.bodySmall),
                              ),
                            )
                            .toList(),
                      ),
                    ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
