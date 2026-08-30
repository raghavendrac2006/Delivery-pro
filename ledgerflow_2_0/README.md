# LedgerFlow 2.0

LedgerFlow 2.0 is the clean rebuild workspace for the daily delivery ledger app.
The original project remains available at the repository root, while this folder
keeps the same business workflow and evolves the internals into smaller modules.

Current preserved workflows:

- Daily route setup and product selection
- Sales and customer outstanding tracking
- Expense logging and batch expense history
- Rice flour bag cycles and production usage
- Owner loan and savings ledgers
- PDF export, Google Sheets sync, OTA updates, and Gemini AI analysis

New 2.0 foundation:

- `lib/core/v2/business_scope.dart` centralizes business collection paths.
- `lib/core/v2/ledger_metrics_calculator.dart` extracts finance calculations.
- `test/ledger_metrics_calculator_test.dart` covers the first reusable business math.

## Getting Started

Run from this folder:

```sh
flutter pub get
flutter test
flutter run --dart-define-from-file=api_keys.json
```

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
