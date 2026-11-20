import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/features/employee/controllers/employee_controller.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/input_fields.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

class EmployeeCustomersView extends StatelessWidget {
  const EmployeeCustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    final EmployeeController c = Get.find<EmployeeController>();
    final TextEditingController search = TextEditingController();

    return ScreenScaffold(
      controller: c,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Customer directory', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 4),
          Text('Search customers and verify their details',
              style: AppTextStyles.bodyMedium),
          const SizedBox(height: 18),
          NexSearchBar(
            controller: search,
            hint: 'Name, email or customer ID…',
            onChanged: c.onSearch,
          ),
          const SizedBox(height: 16),
          Obx(
            () => c.customers.isEmpty
                ? const EmptyStateWidget(title: 'No customers found')
                : Card(
                    child: Column(
                      children: c.customers
                          .map(
                            (p) => ListTile(
                              leading: CircleAvatar(child: Text(p.name.isEmpty ? '?' : p.name[0])),
                              title: Text(p.name, style: AppTextStyles.bodyLarge),
                              subtitle: Text('${p.email} • ${p.branch}'),
                              trailing: StatusChip(status: p.kyc),
                              onTap: () => c.showCustomer(p),
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
