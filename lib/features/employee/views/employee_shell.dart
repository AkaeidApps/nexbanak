import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/core/domain/app_role.dart';
import 'package:nexbanak/features/authentication/controllers/auth_controller.dart';
import 'package:nexbanak/features/employee/views/employee_customers_view.dart';
import 'package:nexbanak/features/employee/views/employee_home_view.dart';
import 'package:nexbanak/features/employee/views/employee_operations_view.dart';
import 'package:nexbanak/features/employee/views/employee_profile_view.dart';
import 'package:nexbanak/features/employee/views/approvals_view.dart';
import 'package:nexbanak/shared/widgets/app_shell.dart';

class EmployeeShell extends StatelessWidget {
  const EmployeeShell({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();
    return NexShell(
      tag: 'employee',
      role: AppRole.employee,
      onSignOut: auth.signOut,
      onNotificationTap: () => Get.toNamed(Routes.notifications),
      items: const <NavItem>[
        NavItem(label: 'Dashboard', icon: Icons.dashboard_rounded, page: EmployeeHomeView()),
        NavItem(label: 'Customers', icon: Icons.people_outline_rounded, page: EmployeeCustomersView()),
        NavItem(label: 'Operations', icon: Icons.work_outline_rounded, page: EmployeeOperationsView()),
        NavItem(label: 'Approvals', icon: Icons.pending_actions_rounded, page: ApprovalsView()),
        NavItem(label: 'Profile', icon: Icons.person_outline_rounded, page: EmployeeProfileView()),
      ],
    );
  }
}
