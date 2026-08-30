# LedgerFlow 2.0 Rebuild Roadmap

This folder is the LedgerFlow 2.0 rebuild branch. The original app is preserved at the repository root while this copy evolves into the new version.

## Current 2.0 Foundation

- The copied app remains runnable with the existing Firebase, Provider, PDF, update, and AI analyst behavior.
- `lib/core/v2` starts the new modular business layer.
- `BusinessScope` centralizes Firestore business path resolution.
- `LedgerMetricsCalculator` extracts reusable cash-flow, bag-cycle, and collection-priority calculations.
- `test/ledger_metrics_calculator_test.dart` protects the first extracted finance calculations.

## Next Build Steps

1. Move duplicated business path logic from repositories and background jobs into `BusinessScope`.
2. Move derived totals from `LedgerState` into tested calculator modules.
3. Split `LedgerState` into smaller controllers for setup, sales, expenses, customers, bag cycles, owner finance, sync, and AI.
4. Introduce a proper settings screen for API keys, Google Sheets URL, business profiles, sync diagnostics, and update status.
5. Add the new daily dashboard, day-end closing checklist, customer aging report, and quick collection mode.

