class Validators {
  static String? required(String? value, [String label = 'This field']) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final RegExp re = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!re.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Use at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Include an uppercase letter';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Include a number';
    return null;
  }

  static String? amount(String? value, {num min = 0.01, num max = 100000000}) {
    if (value == null || value.trim().isEmpty) return 'Enter an amount';
    final num? parsed = num.tryParse(value.replaceAll(',', ''));
    if (parsed == null || parsed <= 0) return 'Enter a valid amount';
    if (parsed < min) return 'Minimum amount is $min';
    if (parsed > max) return 'Amount exceeds the permitted limit';
    return null;
  }

  static String? accountNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'Account number is required';
    if (!RegExp(r'^[0-9]{8,20}$').hasMatch(value.trim())) {
      return 'Enter 8–20 digits';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(value.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? otp(String? value) {
    if (value == null || value.length != 6) return 'Enter the 6-digit code';
    return null;
  }
}
