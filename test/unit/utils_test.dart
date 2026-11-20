import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_theme.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/utils/formatters.dart';
import 'package:nexbanak/core/utils/validators.dart';

void main() {
  group('Formatters', () {
    test('formats authoritative decimal strings and minor units', () {
      expect(Formatters.money('8240.75'), r'$8,240.75');
      expect(Formatters.money(824075), r'$8,240.75');
      expect(Formatters.money('0'), r'$0.00');
      expect(Formatters.maskAccount('1002003001'), '•••• •••• 3001');
      expect(Formatters.initials('alex morgan'), 'AM');
      expect(Formatters.date('2026-01-02T10:00:00Z'), isNot('—'));
      expect(Formatters.greeting(DateTime(2026, 1, 1, 9)), 'Good morning');
      expect(Formatters.greeting(DateTime(2026, 1, 1, 14)), 'Good afternoon');
      expect(Formatters.greeting(DateTime(2026, 1, 1, 20)), 'Good evening');
    });
  });

  group('Validators', () {
    test('validate banking form inputs without accepting bad data', () {
      expect(Validators.email('customer@nexbank.demo'), isNull);
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.password('Demo@123'), isNull);
      expect(Validators.password('short'), isNotNull);
      expect(Validators.password('nouppercase1'), isNotNull);
      expect(Validators.amount('100.50'), isNull);
      expect(Validators.amount('0'), isNotNull);
      expect(Validators.amount('999999999999'), isNotNull);
      expect(Validators.accountNumber('10020030'), isNull);
      expect(Validators.accountNumber('abc123'), isNotNull);
      expect(Validators.otp('123456'), isNull);
      expect(Validators.otp('123'), isNotNull);
      expect(Validators.phone('+15550101'), isNull);
      expect(Validators.phone('123'), isNotNull);
    });
  });

  group('AppTheme', () {
    test('uses the specified palette, Inter font, and Material 3', () {
      expect(AppTextStyles.fontFamily, 'Inter');
      expect(AppTheme.light.useMaterial3, isTrue);
      expect(AppTheme.dark.useMaterial3, isTrue);
      expect(AppTheme.light.colorScheme.primary, AppColors.primaryNavy);
      expect(AppTheme.light.colorScheme.secondary, AppColors.secondaryBlue);
      expect(AppTheme.light.colorScheme.error, AppColors.error);
      expect(AppTheme.light.scaffoldBackgroundColor, AppColors.background);
      expect(AppTheme.dark.scaffoldBackgroundColor, AppColors.darkBackground);
      expect(AppTheme.dark.brightness, Brightness.dark);
      expect(AppTheme.light.textTheme.bodyMedium?.fontFamily, 'Inter');
    });
  });
}
