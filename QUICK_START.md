# CI/CD Pipeline - Quick Start Guide

## 📋 Prerequisites

- Flutter SDK installed (3.24.0 or higher)
- Git installed
- GitHub account
- (Optional) lcov for coverage reports

## 🚀 Quick Start

### 1. Clone and Setup

```bash
git clone https://github.com/Maksym-Tomusiak/Flutter_CI-CD.git
cd Flutter_CI-CD
flutter pub get
```

### 2. Run the App

**Development:**

```bash
flutter run --dart-define=BUILD_ENV=dev --dart-define=API_URL=https://api-dev.example.com --target=lib/main_dev.dart
```

**Staging:**

```bash
flutter run --dart-define=BUILD_ENV=staging --dart-define=API_URL=https://api-staging.example.com --target=lib/main_staging.dart
```

**Production:**

```bash
flutter run --dart-define=BUILD_ENV=prod --dart-define=API_URL=https://api.example.com --target=lib/main_prod.dart
```

### 3. Local Quality Checks (Before Committing)

```bash
# Format code
dart format .

# Analyze code
flutter analyze --fatal-infos

# Run tests with coverage
flutter test --coverage

# Check coverage threshold (PowerShell on Windows)
powershell -ExecutionPolicy Bypass -File scripts\check_coverage.ps1

# Check coverage threshold (Bash on Linux/macOS/Git Bash)
bash scripts/check_coverage.sh
```

### 4. Build APKs

**Development APK:**

```bash
flutter build apk --dart-define=BUILD_ENV=dev --dart-define=API_URL=https://api-dev.example.com --target=lib/main_dev.dart --release
```

**Staging APK:**

```bash
flutter build apk --dart-define=BUILD_ENV=staging --dart-define=API_URL=https://api-staging.example.com --target=lib/main_staging.dart --release
```

**Production APK:**

```bash
flutter build apk --dart-define=BUILD_ENV=prod --dart-define=API_URL=https://api.example.com --target=lib/main_prod.dart --release
```

## 🔧 Common Tasks

### Increment Version

**PowerShell (Windows):**

```powershell
powershell -ExecutionPolicy Bypass -File scripts\increment_version.ps1
```

**Bash (Linux/macOS/Git Bash):**

```bash
bash scripts/increment_version.sh
```

### View Coverage Report

```bash
# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
# Windows
start coverage/html/index.html

# macOS
open coverage/html/index.html

# Linux
xdg-open coverage/html/index.html
```

### Fix Formatting Issues

```bash
# Auto-format all files
dart format .
```

### Fix Analysis Issues

```bash
# See all issues
flutter analyze

# See verbose output
flutter analyze --verbose
```

## 📊 Understanding the CI/CD Pipeline

### Pipeline Triggers

The pipeline runs on:

- Push to `develop` branch
- Push to `main` branch
- Pull requests to `develop` or `main`

### Pipeline Jobs

1. **🔍 Code Analysis** (analyze)

   - Checkout code
   - Setup Flutter
   - Install dependencies
   - Verify formatting
   - Run static analysis

2. **🧪 Run Tests** (test)

   - Depends on: analyze
   - Run all tests
   - Generate coverage report
   - Validate 70% coverage threshold
   - Upload coverage artifacts

3. **🏗️ Build APK** (build)

   - Depends on: test
   - Build APKs for dev, staging, prod (in parallel)
   - Upload APK artifacts

4. **📋 Build Summary** (build-summary)
   - Display summary
   - Always runs

### Viewing Pipeline Results

1. Go to your GitHub repository
2. Click "Actions" tab
3. Select a workflow run
4. View job details and download artifacts

## 🐛 Troubleshooting

### "Coverage file not found"

**Solution:**

```bash
flutter test --coverage
```

### "Format check failed"

**Solution:**

```bash
dart format .
git add .
git commit --amend --no-edit
```

### "Analysis failed"

**Solution:**

```bash
flutter analyze
# Fix the reported issues
```

### "Tests failed"

**Solution:**

```bash
flutter test --reporter expanded
# Review and fix failing tests
```

### "Coverage below 70%"

**Solution:**
Add more tests to increase coverage:

```bash
# See which files need more coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📁 Project Structure

```
practice_13/
├── .github/workflows/ci.yml    # CI/CD configuration
├── lib/
│   ├── config/
│   │   ├── environment.dart    # Environment enum
│   │   └── app_config.dart     # Configuration management
│   ├── main_dev.dart           # Dev entry point
│   ├── main_staging.dart       # Staging entry point
│   └── main_prod.dart          # Production entry point
├── test/
│   └── widget_test.dart        # All tests
├── scripts/
│   ├── check_coverage.sh       # Coverage check (Bash)
│   ├── check_coverage.ps1      # Coverage check (PowerShell)
│   ├── increment_version.sh    # Version bump (Bash)
│   └── increment_version.ps1   # Version bump (PowerShell)
└── analysis_options.yaml       # Linter rules
```

## ✅ Pre-Commit Checklist

Before pushing code:

- [ ] Code is formatted: `dart format .`
- [ ] No analysis issues: `flutter analyze --fatal-infos`
- [ ] All tests pass: `flutter test`
- [ ] Coverage >= 70%: `powershell scripts\check_coverage.ps1` (Windows) or `bash scripts/check_coverage.sh` (Linux/macOS)
- [ ] Builds successfully: `flutter build apk --target=lib/main_dev.dart`

## 🚀 Deployment Workflow

1. **Development:**

   - Create feature branch: `git checkout -b feature/my-feature`
   - Make changes
   - Run local checks (format, analyze, test)
   - Commit: `git commit -m "feat: add new feature"`
   - Push: `git push origin feature/my-feature`
   - Create Pull Request to `develop`

2. **Staging:**

   - Merge PR to `develop`
   - Pipeline builds and tests
   - Download staging APK from artifacts
   - Test on staging environment

3. **Production:**
   - Create PR from `develop` to `main`
   - Get approval
   - Merge to `main`
   - Pipeline builds production APK
   - Download production APK
   - Deploy to production

## 📚 Additional Resources

- [README.md](README.md) - Full documentation
- [analysis_options.yaml](analysis_options.yaml) - Linter configuration
- [.github/workflows/ci.yml](.github/workflows/ci.yml) - CI/CD workflow

## 💡 Tips

- Use `flutter run --dart-define=BUILD_ENV=dev --target=lib/main_dev.dart` for quick testing
- Always run tests before pushing: `flutter test`
- Check coverage regularly to maintain quality
- Use the scripts to automate version bumping
- Monitor GitHub Actions for pipeline status
