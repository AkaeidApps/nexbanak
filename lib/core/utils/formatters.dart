import 'package:intl/intl.dart';

/// All money arrives from the backend as a decimal string or integer minor
/// units. Formatting never performs balance calculations.
class Formatters {
  static final NumberFormat _money = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
    locale: 'en_US',
  );
  static final NumberFormat _compact = NumberFormat.compact(locale: 'en_US');
  static final DateFormat _date = DateFormat('dd MMM yyyy');
  static final DateFormat _dateTime = DateFormat('dd MMM yyyy • HH:mm');

  static String money(Object? value) {
    final num amount = switch (value) {
      final String s => num.tryParse(s) ?? 0,
      final int i => i / 100,
      final num n => n,
      _ => 0,
    };
    return _money.format(amount);
  }

  static String compact(num value) => _compact.format(value);

  static String maskAccount(String accountNumber) {
    if (accountNumber.length <= 4) return accountNumber;
    final String tail = accountNumber.substring(accountNumber.length - 4);
    return '•••• •••• $tail';
  }

  static String initials(String name) => name
      .trim()
      .split(RegExp(r'\s+'))
      .take(2)
      .map((part) => part.isEmpty ? '' : part[0].toUpperCase())
      .join();

  static String date(Object? value) {
    final DateTime? parsed = _parse(value);
    return parsed == null ? '—' : _date.format(parsed.toLocal());
  }

  static String dateTime(Object? value) {
    final DateTime? parsed = _parse(value);
    return parsed == null ? '—' : _dateTime.format(parsed.toLocal());
  }

  static DateTime? _parse(Object? value) => switch (value) {
        final DateTime d => d,
        final String s => DateTime.tryParse(s),
        _ => null,
      };

  static String greeting(DateTime now) {
    final int h = now.hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
