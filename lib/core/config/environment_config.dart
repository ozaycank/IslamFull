import 'package:flutter/foundation.dart' show kDebugMode;

enum EnvironmentType { development, staging, production }

/// These values are PUBLIC build-time configuration, not a secret vault.
/// Example: flutter run --dart-define=APP_ENV=development
/// Never put API tokens or private credentials in --dart-define values.
class EnvironmentConfig {
  EnvironmentConfig._();

  static EnvironmentType get environment {
    const env = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'production',
    );

    return EnvironmentType.values.firstWhere(
      (value) => value.name == env,
      orElse: () => EnvironmentType.production,
    );
  }

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.islamfull.example.com',
  );

  static const int connectTimeout = int.fromEnvironment(
    'CONNECT_TIMEOUT',
    defaultValue: 30000,
  );

  static const int receiveTimeout = int.fromEnvironment(
    'RECEIVE_TIMEOUT',
    defaultValue: 30000,
  );

  // Debug logging must never be activated in profile/release builds even
  // when APP_ENV is accidentally set to development.
  static bool get isDevelopment =>
      kDebugMode && environment == EnvironmentType.development;
}
