import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexbanak/shared/widgets/data_cards.dart';

void main() {
  testWidgets('balance card masks and reveals the balance on demand',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: _BalanceVisibilityHost()),
      ),
    );

    expect(find.text('••••••••'), findsOneWidget);
    expect(find.text(r'$8,240.75'), findsNothing);
    expect(find.text('•••• •••• 3001'), findsOneWidget);

    await tester.tap(find.byTooltip('Show balance'));
    await tester.pump();

    expect(find.text('••••••••'), findsNothing);
    expect(find.text(r'$8,240.75'), findsOneWidget);
    expect(find.byTooltip('Hide balance'), findsOneWidget);

    await tester.tap(find.byTooltip('Hide balance'));
    await tester.pump();
    expect(find.text('••••••••'), findsOneWidget);
  });
}

class _BalanceVisibilityHost extends StatefulWidget {
  const _BalanceVisibilityHost();

  @override
  State<_BalanceVisibilityHost> createState() => _BalanceVisibilityHostState();
}

class _BalanceVisibilityHostState extends State<_BalanceVisibilityHost> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) => Center(
        child: BalanceCard(
          balance: '8240.75',
          accountNumber: '1002003001',
          hidden: _hidden,
          onToggleVisibility: () => setState(() => _hidden = !_hidden),
        ),
      );
}
