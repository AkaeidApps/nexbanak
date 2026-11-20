/// Application-wide constants. No production secrets live here.
class AppConstants {
  static const String appName = 'NEXBANK';
  static const String tagline = 'NEXT GENERATION BANKING';
  static const String appVersion = '1.0.0';

  /// Demo data is compiled in by default. Set `USE_MOCK=false` at build time to
  /// use the real REST backend. The UI always shows a DEMO badge when active.
  static const bool useMock = bool.fromEnvironment('USE_MOCK', defaultValue: true);
  static const String apiBaseUrl = String.fromEnvironment(
    'NEXBANK_API_BASE_URL',
    defaultValue: 'https://api.nexbank.example/v1',
  );

  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 20000;
  static const int defaultPageSize = 20;
  static const int maxAmountMinorUnits = 100000000000; // 1B in minor units

  // Responsive breakpoints (logical pixels)
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  static const String otpDemoCode = '123456';
}
