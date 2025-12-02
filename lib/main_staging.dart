import 'package:flutter/material.dart';
import 'package:practice_13/config/app_config.dart';

void main() {
  // Print configuration for debugging
  AppConfig.printConfig();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConfig.displayName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flutter_dash, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            Text(
              'Welcome to ${AppConfig.appName}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Environment: ${AppConfig.environment.name.toUpperCase()}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppConfig.isProduction ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _InfoCard(title: 'API Base URL', value: AppConfig.apiBaseUrl),
            _InfoCard(
              title: 'Debug Features',
              value: AppConfig.debugFeatures ? 'Enabled' : 'Disabled',
            ),
            _InfoCard(
              title: 'Logging',
              value: AppConfig.enableLogging ? 'Enabled' : 'Disabled',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value),
            ],
          ),
        ),
      ),
    );
  }
}
