import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nexbanak/core/services/receipt_service.dart';
import 'package:nexbanak/data/models/account_model.dart';
import 'package:nexbanak/data/models/transaction_model.dart';

void main() {
  const TransactionModel txn = TransactionModel(
    id: 'txn_001',
    reference: 'NXB-901201',
    title: 'Transfer to Maria Santos',
    type: 'transfer',
    amount: '100.25',
    direction: 'debit',
    status: 'completed',
    date: '2026-01-02T10:00:00Z',
    accountId: 'acc_001',
    note: 'Demo receipt',
  );

  const AccountModel account = AccountModel(
    id: 'acc_001',
    accountNumber: '1002003001',
    name: 'Everyday Savings',
    type: 'savings',
    balance: '8240.75',
    currency: 'USD',
    status: 'active',
    openedAt: '2025-01-01T00:00:00Z',
  );

  test('receipt document renders valid PDF bytes', () async {
    final Uint8List bytes = await ReceiptService().buildReceiptDocument(txn).save();

    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });

  test('statement document renders valid PDF bytes', () async {
    final Uint8List bytes = await ReceiptService()
        .buildStatementDocument(account, <TransactionModel>[txn])
        .save();

    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}
