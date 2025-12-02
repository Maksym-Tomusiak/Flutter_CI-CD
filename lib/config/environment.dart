/// Defines the build environments available for the application
enum BuildEnvironment {
  /// Development environment
  dev,

  /// Staging environment
  staging,

  /// Production environment
  prod,
}

/// Extension methods for BuildEnvironment
extension BuildEnvironmentExtension on BuildEnvironment {
  /// Returns the string name of the environment
  String get name {
    switch (this) {
      case BuildEnvironment.dev:
        return 'dev';
      case BuildEnvironment.staging:
        return 'staging';
      case BuildEnvironment.prod:
        return 'prod';
    }
  }

  /// Returns whether this is a production environment
  bool get isProduction => this == BuildEnvironment.prod;

  /// Returns whether this is a development environment
  bool get isDevelopment => this == BuildEnvironment.dev;

  /// Returns whether this is a staging environment
  bool get isStaging => this == BuildEnvironment.staging;
}
