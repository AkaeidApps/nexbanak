import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/constants/app_constants.dart';
import 'package:nexbanak/features/customer/controllers/money_controller.dart';

import '../helpers/test_setup.dart';

/// Snackbars use real UI timers that are irrelevant to confirming transaction
/// dialogs, so widget tests silence them while leaving repository calls intact.
class QuietMoneyController extends MoneyController {
  @override
  void showSuccess(String message) {}

  @override
  void showError(String message) {}
}

void main() {
  setUp(() async {
    await initTestEnvironment();
    await registerCoreServices();
  });

  tearDown(() => Get.reset());

  Future<MoneyController> boot(WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(home: Scaffold(body: SizedBox.expand())),
    );
    final MoneyController controller = Get.put<MoneyController>(
      QuietMoneyController(),
      permanent: true,
    );
    // The demo simulator starts every call with a 120ms latency. Pump past it
    // so onInit's load() has populated accounts before the test reads them.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    return controller;
  }

  Future<void> pumpFlow(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
  }

  Future<void> closeDialog(WidgetTester tester, Future<void> flow) async {
    expect(find.text('Done'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    await flow;
  }

  testWidgets('deposit request reports pending approval and never posts funds',
      (WidgetTester tester) async {
    final MoneyController c = await boot(tester);
    final String before = c.selectedAccount!.balance;
    c.amount.value = '100.00';
    c.note.value = 'Demo deposit';

    final Future<void> flow = c.deposit();
    await pumpFlow(tester);

    expect(find.text('Request received'), findsOneWidget);
    expect(find.textContaining('Reference: NXB-'), findsOneWidget);
    expect(
      find.text('Your request is awaiting authorized approval.'),
      findsOneWidget,
    );
    await closeDialog(tester, flow);

    expect(c.selectedAccount!.balance, before);
    expect(c.amount.value, isEmpty);
    expect(c.note.value, isEmpty);
  });

  testWidgets('withdrawal request reports pending approval',
      (WidgetTester tester) async {
    final MoneyController c = await boot(tester);
    final String before = c.selectedAccount!.balance;
    c.amount.value = '25.00';

    final Future<void> flow = c.withdrawal();
    await pumpFlow(tester);

    expect(find.text('Request received'), findsOneWidget);
    await closeDialog(tester, flow);
    expect(c.selectedAccount!.balance, before);
  });

  testWidgets('verified transfer shows backend confirmation and updated balances',
      (WidgetTester tester) async {
    final MoneyController c = await boot(tester);
    c.selectedAccountId.value = 'acc_001';
    c.destinationAccount.value = '1002003002';
    c.otp.value = AppConstants.otpDemoCode;
    c.amount.value = '50.00';

    final Future<void> flow = c.transfer();
    await pumpFlow(tester);

    expect(find.text('Transaction complete'), findsOneWidget);
    expect(
      find.text('The backend confirmed your transaction.'),
      findsOneWidget,
    );
    await closeDialog(tester, flow);

    expect(
      c.accounts.firstWhere((a) => a.id == 'acc_001').balance,
      '8190.75',
    );
    expect(
      c.accounts.firstWhere((a) => a.id == 'acc_002').balance,
      '3170.40',
    );
  });

  testWidgets('invalid OTP surfaces an error without a success dialog',
      (WidgetTester tester) async {
    final MoneyController c = await boot(tester);
    c.selectedAccountId.value = 'acc_001';
    c.destinationAccount.value = '1002003002';
    c.otp.value = '000000';
    c.amount.value = '50.00';

    final Future<void> flow = c.transfer();
    await pumpFlow(tester);
    await flow;

    expect(c.errorMessage.value, contains('Incorrect OTP'));
    expect(find.text('Transaction complete'), findsNothing);
    expect(find.text('Request received'), findsNothing);
    expect(c.selectedAccount!.balance, '8240.75');
  });
}
