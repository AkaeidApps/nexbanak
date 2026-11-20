import 'package:get/get.dart';
import 'package:nexbanak/app/constants/app_constants.dart';
import 'package:nexbanak/core/utils/formatters.dart';
import 'package:nexbanak/data/models/account_model.dart';
import 'package:nexbanak/data/models/transaction_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Generates PDF receipts/statements client-side from confirmed server data.
/// It never creates or modifies financial records. Document builders are
/// public so the rendered bytes can be verified without a print channel.
class ReceiptService extends GetxService {
  Future<void> printReceipt(TransactionModel txn) async {
    final pw.Document doc = buildReceiptDocument(txn);
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  Future<void> printStatement(
    AccountModel account,
    List<TransactionModel> transactions,
  ) async {
    final pw.Document doc = buildStatementDocument(account, transactions);
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  pw.Document buildReceiptDocument(TransactionModel txn) {
    final pw.Document doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: <pw.Widget>[
            pw.Container(
              color: const PdfColor.fromInt(0xFF0B1F3A),
              padding: const pw.EdgeInsets.all(20),
              child: pw.Row(
                children: <pw.Widget>[
                  pw.Text('NEXBANK',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      )),
                  pw.Spacer(),
                  pw.Text(AppConstants.tagline,
                      style: const pw.TextStyle(color: PdfColors.white, fontSize: 9)),
                ],
              ),
            ),
            pw.SizedBox(height: 28),
            pw.Text('Transaction receipt',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 18),
            _row('Reference', txn.reference),
            _row('Description', _ascii(txn.title)),
            _row('Type', txn.type.toUpperCase()),
            _row('Date', _ascii(Formatters.dateTime(txn.date))),
            _row('Status', txn.status.toUpperCase()),
            _row('Amount', Formatters.money(txn.amount)),
            if (txn.note.isNotEmpty) _row('Note', _ascii(txn.note)),
            pw.Spacer(),
            pw.Divider(),
            pw.Text(
              'This receipt reflects a server-confirmed transaction. '
              'Demo-mode receipts are not valid banking documents.',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
            ),
          ],
        ),
      ),
    );
    return doc;
  }

  pw.Document buildStatementDocument(
    AccountModel account,
    List<TransactionModel> transactions,
  ) {
    final pw.Document doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: <pw.Widget>[
            pw.Text(_ascii('NEXBANK — Account statement'),
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            pw.Text(_ascii('${account.name} • ${Formatters.maskAccount(account.accountNumber)}')),
            pw.Text(_ascii('Generated ${Formatters.dateTime(DateTime.now().toIso8601String())}')),
            pw.SizedBox(height: 16),
            pw.TableHelper.fromTextArray(
              headers: <String>['Date', 'Reference', 'Description', 'Amount'],
              data: transactions
                  .map((t) => <String>[
                        Formatters.date(t.date),
                        _ascii(t.reference),
                        _ascii(t.title),
                        '${t.isCredit ? '+' : '-'}${Formatters.money(t.amount)}',
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ),
    );
    return doc;
  }

  /// The bundled standard PDF fonts are WinAnsi; keep generated documents
  /// free of typographic punctuation that cannot be encoded.
  String _ascii(String value) => value
      .replaceAll('•', '-')
      .replaceAll('—', '-')
      .replaceAll('−', '-')
      .replaceAll('’', "'")
      .replaceAll('‘', "'")
      .replaceAll('“', '"')
      .replaceAll('”', '"');

  pw.Widget _row(String label, String value) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 6),
        child: pw.Row(
          children: <pw.Widget>[
            pw.SizedBox(width: 130, child: pw.Text(label,
                style: const pw.TextStyle(color: PdfColors.grey700))),
            pw.Expanded(child: pw.Text(value)),
          ],
        ),
      );
}
