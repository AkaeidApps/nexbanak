import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nexbanak/core/domain/app_role.dart';
import 'package:nexbanak/shared/widgets/app_shell.dart';
import 'package:nexbanak/shared/widgets/nex_bank_logo.dart';

import '../helpers/test_setup.dart';

void main() {
  setUp(() async {
    await initTestEnvironment();
    await registerCoreServices();
  });

  tearDown(() => Get.reset());

  List<NavItem> items() => const <NavItem>[
        NavItem(
          label: 'Overview',
          icon: Icons.dashboard_rounded,
          page: Text('OVERVIEW PAGE'),
        ),
        NavItem(
          label: 'Payments',
          icon: Icons.payment_rounded,
          page: Text('PAYMENTS PAGE'),
        ),
      ];

  Future<void> pumpShell(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      GetMaterialApp(
        home: NexShell(
          tag: 'responsive-test',
          role: AppRole.customer,
          items: items(),
          onSignOut: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('mobile uses bottom navigation and switches tabs',
      (WidgetTester tester) async {
    await pumpShell(tester, const Size(390, 844));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('OVERVIEW PAGE'), findsOneWidget);
    expect(find.text('Sign out'), findsNothing);

    await tester.tap(find.text('Payments'));
    await tester.pumpAndSettle();
    expect(find.text('PAYMENTS PAGE'), findsOneWidget);
  });

  testWidgets('tablet uses a drawer instead of bottom navigation',
      (WidgetTester tester) async {
    await pumpShell(tester, const Size(900, 800));

    expect(find.byType(NavigationBar), findsNothing);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    expect(find.text('Customer workspace'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
  });

  testWidgets('desktop shows the persistent sidebar', (WidgetTester tester) async {
    await pumpShell(tester, const Size(1440, 900));

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Sign out'), findsOneWidget);
    expect(find.byType(NexBankLogo), findsNWidgets(2));

    await tester.tap(find.text('Payments'));
    await tester.pumpAndSettle();
    expect(find.text('PAYMENTS PAGE'), findsOneWidget);
  });
}
