import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_pages.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/core/domain/app_role.dart';
import 'package:nexbanak/features/admin/views/admin_shell.dart';
import 'package:nexbanak/features/authentication/controllers/auth_controller.dart';
import 'package:nexbanak/features/customer/views/customer_shell.dart';
import 'package:nexbanak/features/employee/views/employee_shell.dart';
import 'package:nexbanak/shared/widgets/app_shell.dart';

import '../helpers/test_setup.dart';

void main() {
  setUp(() async {
    await initTestEnvironment();
    await registerCoreServices();
    Get.put<AuthController>(TestAuthController(), permanent: true);
  });

  tearDown(() => Get.reset());

  Future<void> pumpRoute(WidgetTester tester, AppRole role) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      GetMaterialApp(
        getPages: AppPages.pages,
        initialRoute: role.homeRoute,
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('customer deep link resolves the customer workspace',
      (WidgetTester tester) async {
    await pumpRoute(tester, AppRole.customer);

    expect(find.byType(CustomerShell), findsOneWidget);
    expect(find.byType(NexShell), findsOneWidget);
    expect(find.text('Transfer'), findsWidgets);
    expect(find.text('DEMO'), findsWidgets);
  });

  testWidgets('employee deep link resolves the employee workspace',
      (WidgetTester tester) async {
    await pumpRoute(tester, AppRole.employee);

    expect(find.byType(EmployeeShell), findsOneWidget);
    expect(find.byType(NexShell), findsOneWidget);
    expect(find.text('Approvals'), findsOneWidget);
  });

  testWidgets('admin deep link resolves the admin workspace',
      (WidgetTester tester) async {
    await pumpRoute(tester, AppRole.admin);

    expect(find.byType(AdminShell), findsOneWidget);
    expect(find.byType(NexShell), findsOneWidget);
    expect(find.text('More'), findsOneWidget);
  });

  testWidgets('shared deep links resolve without a role shell',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        getPages: AppPages.pages,
        initialRoute: Routes.settings,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('System settings'), findsOneWidget);
    expect(find.text('DEMO'), findsWidgets);
  });
}
