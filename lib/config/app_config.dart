import 'package:practice_13/config/environment.dart';

/// Application configuration that adapts based on build environment
class AppConfig {
  /// Private constructor to prevent instantiation
  AppConfig._();

  /// Key for environment configuration
  static const String _envKey = 'BUILD_ENV';

  /// Key for API URL configuration
  static const String _apiUrlKey = 'API_URL';

  /// Key for enable logging configuration
  static const String _enableLoggingKey = 'ENABLE_LOGGING';

  /// Gets the current build environment
  static BuildEnvironment get environment {
    const envString = String.fromEnvironment(_envKey, defaultValue: 'dev');
    return BuildEnvironment.values.firstWhere(
      (e) => e.name == envString,
      orElse: () => BuildEnvironment.dev,
    );
  }

  /// Gets the API base URL for the current environment
  static String get apiBaseUrl {
    return const String.fromEnvironment(
      _apiUrlKey,
      defaultValue: 'https://api-dev.example.com',
    );
  }

  /// Returns whether logging is enabled
  static bool get enableLogging {
    return const bool.fromEnvironment(_enableLoggingKey, defaultValue: true);
  }

  /// Returns whether the app is in production mode
  static bool get isProduction => environment.isProduction;

  /// Returns whether the app is in development mode
  static bool get isDevelopment => environment.isDevelopment;

  /// Returns whether the app is in staging mode
  static bool get isStaging => environment.isStaging;

  /// Returns the app name based on environment
  static String get appName {
    switch (environment) {
      case BuildEnvironment.dev:
        return 'MyApp Dev';
      case BuildEnvironment.staging:
        return 'MyApp Staging';
      case BuildEnvironment.prod:
        return 'MyApp';
    }
  }

  /// Returns the app display name with version info
  static String get displayName {
    final env = environment.name.toUpperCase();
    return isProduction ? appName : '$appName [$env]';
  }

  /// Returns whether debug features should be enabled
  static bool get debugFeatures => !isProduction;

  /// Returns the timeout duration for API calls (in seconds)
  static int get apiTimeout {
    return isProduction ? 30 : 60;
  }

  /// Prints the current configuration (for debugging)
  static void printConfig() {
    if (!enableLogging) return;

    // ignore: avoid_print
    print('=== App Configuration ===');
    // ignore: avoid_print
    print('Environment: ${environment.name}');
    // ignore: avoid_print
    print('App Name: $appName');
    // ignore: avoid_print
    print('API Base URL: $apiBaseUrl');
    // ignore: avoid_print
    print('Logging Enabled: $enableLogging');
    // ignore: avoid_print
    print('Debug Features: $debugFeatures');
    // ignore: avoid_print
    print('========================');
  }
}
