import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_13/config/app_config.dart';
import 'package:practice_13/config/environment.dart';
import 'package:practice_13/main_dev.dart' as dev;
import 'package:practice_13/main_staging.dart' as staging;
import 'package:practice_13/main_prod.dart' as prod;

void main() {
  group('AppConfig Tests', () {
    test('should return correct default environment', () {
      expect(AppConfig.environment, equals(BuildEnvironment.dev));
    });

    test('should return correct default API URL', () {
      expect(AppConfig.apiBaseUrl, equals('https://api-dev.example.com'));
    });

    test('should return correct app name for dev environment', () {
      expect(AppConfig.appName, contains('Dev'));
    });

    test('should have logging enabled by default', () {
      expect(AppConfig.enableLogging, isTrue);
    });

    test('should have debug features enabled in non-production', () {
      expect(AppConfig.debugFeatures, isTrue);
    });

    test('should return correct API timeout', () {
      expect(AppConfig.apiTimeout, isA<int>());
      expect(AppConfig.apiTimeout, greaterThan(0));
    });

    test('should return correct display name', () {
      final displayName = AppConfig.displayName;
      expect(displayName, isNotEmpty);
    });
  });

  group('BuildEnvironment Tests', () {
    test('should have correct environment names', () {
      expect(BuildEnvironment.dev.name, equals('dev'));
      expect(BuildEnvironment.staging.name, equals('staging'));
      expect(BuildEnvironment.prod.name, equals('prod'));
    });

    test('should correctly identify production environment', () {
      expect(BuildEnvironment.prod.isProduction, isTrue);
      expect(BuildEnvironment.dev.isProduction, isFalse);
      expect(BuildEnvironment.staging.isProduction, isFalse);
    });

    test('should correctly identify development environment', () {
      expect(BuildEnvironment.dev.isDevelopment, isTrue);
      expect(BuildEnvironment.prod.isDevelopment, isFalse);
      expect(BuildEnvironment.staging.isDevelopment, isFalse);
    });

    test('should correctly identify staging environment', () {
      expect(BuildEnvironment.staging.isStaging, isTrue);
      expect(BuildEnvironment.dev.isStaging, isFalse);
      expect(BuildEnvironment.prod.isStaging, isFalse);
    });
  });

  group('Dev Environment Widget Tests', () {
    testWidgets('MainApp should build without errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const dev.MainApp());
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should display app name in AppBar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const dev.MainApp());
      await tester.pumpAndSettle();

      expect(find.text(AppConfig.displayName), findsOneWidget);
    });

    testWidgets('should display welcome message', (WidgetTester tester) async {
      await tester.pumpWidget(const dev.MainApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Welcome to'), findsOneWidget);
    });

    testWidgets('should display Flutter icon', (WidgetTester tester) async {
      await tester.pumpWidget(const dev.MainApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.flutter_dash), findsOneWidget);
    });

    testWidgets('should display environment name', (WidgetTester tester) async {
      await tester.pumpWidget(const dev.MainApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Environment:'), findsOneWidget);
    });

    testWidgets('should display API Base URL info card', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const dev.MainApp());
      await tester.pumpAndSettle();

      expect(find.text('API Base URL'), findsOneWidget);
    });

    testWidgets('should display Debug Features info card', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const dev.MainApp());
      await tester.pumpAndSettle();

      expect(find.text('Debug Features'), findsOneWidget);
    });

    testWidgets('should display Logging info card', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const dev.MainApp());
      await tester.pumpAndSettle();

      expect(find.text('Logging'), findsOneWidget);
    });

    testWidgets('should display info cards with values', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const dev.MainApp());
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsAtLeast(3));
    });
  });

  group('Staging Environment Widget Tests', () {
    testWidgets('MainApp should build without errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const staging.MainApp());
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should display correct widgets', (WidgetTester tester) async {
      await tester.pumpWidget(const staging.MainApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.flutter_dash), findsOneWidget);
      expect(find.byType(Card), findsAtLeast(3));
    });
  });

  group('Production Environment Widget Tests', () {
    testWidgets('MainApp should build without errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const prod.MainApp());
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should display correct widgets', (WidgetTester tester) async {
      await tester.pumpWidget(const prod.MainApp());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.flutter_dash), findsOneWidget);
      expect(find.byType(Card), findsAtLeast(3));
    });

    testWidgets('should display all UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(const prod.MainApp());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Column), findsAtLeast(1));
    });
  });

  group('InfoCard Widget Tests', () {
    testWidgets('InfoCard should display title and value', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: dev.HomePage())),
      );
      await tester.pumpAndSettle();

      // Verify cards are displayed
      expect(find.byType(Card), findsAtLeast(3));

      // Verify text content exists
      expect(find.text('API Base URL'), findsOneWidget);
      expect(find.text('Debug Features'), findsOneWidget);
      expect(find.text('Logging'), findsOneWidget);
    });
  });

  group('Theme Tests', () {
    testWidgets('dev app should use Material3', (WidgetTester tester) async {
      await tester.pumpWidget(const dev.MainApp());
      await tester.pumpAndSettle();

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.useMaterial3, isTrue);
    });

    testWidgets('staging app should use Material3', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const staging.MainApp());
      await tester.pumpAndSettle();

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.useMaterial3, isTrue);
    });

    testWidgets('prod app should use Material3', (WidgetTester tester) async {
      await tester.pumpWidget(const prod.MainApp());
      await tester.pumpAndSettle();

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme?.useMaterial3, isTrue);
    });
  });
}
