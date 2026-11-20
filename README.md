# NEXBANK — Next Generation Banking

Native Flutter banking client for **Customer**, **Employee** and **Admin** roles. The UI is
built entirely with Flutter widgets (no WebView), uses GetX for state/routing, and targets the
REST contract in [`docs/API_CONTRACT.md`](docs/API_CONTRACT.md).

> No institution backend or brand assets were supplied with the project. The prompt is the
> source of truth; demo mode ships with an explicitly labelled in-memory simulator and never
> writes to a real ledger.

## Quick start (demo, default)

```bash
flutter pub get --offline
flutter run --dart-define=USE_MOCK=true
```

Demo sign-in:

| Role | Email | Password | OTP |
|---|---|---|---|
| Customer | `customer@nexbank.demo` | `Demo@123` | `123456` |
| Employee | `employee@nexbank.demo` | `Demo@123` | `123456` |
| Admin | `admin@nexbank.demo` | `Demo@123` | `123456` |

Every screen in demo mode shows a **DEMO** badge. Deposits and withdrawals stay `pending` in
the simulator; only the OTP-verified internal transfer posts a simulated ledger movement.

## Live backend

```bash
flutter run \
  --dart-define=USE_MOCK=false \
  --dart-define=NEXBANK_API_BASE_URL=https://api.example.com/v1
```

The backend is authoritative. It must enforce RBAC, maker–checker separation, idempotency
and decimal ledger math; the client-side role checks only shape the UX. See
[`docs/API_CONTRACT.md`](docs/API_CONTRACT.md).

## Release builds

```bash
# Android App Bundle (demo)
flutter build appbundle --release --dart-define=USE_MOCK=true

# Android App Bundle (live)
flutter build appbundle --release \
  --dart-define=USE_MOCK=false \
  --dart-define=NEXBANK_API_BASE_URL=https://api.example.com/v1

# iOS (demo)
flutter build ipa --release --dart-define=USE_MOCK=true

# iOS (live)
flutter build ipa --release \
  --dart-define=USE_MOCK=false \
  --dart-define=NEXBANK_API_BASE_URL=https://api.example.com/v1
```

## Verify

```bash
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test --reporter expanded
```

Current result: **No analyzer issues** and **35 passing tests** (unit + widget). See
[`docs/IMPLEMENTATION_STATUS.md`](docs/IMPLEMENTATION_STATUS.md) for the phase-by-phase
status and verification matrix.

## Structure

```text
lib/
  app/          constants, Material 3 themes, routes, global/feature bindings
  core/         base controller, errors, domain, network/Dio, services, utils
  data/         models, demo simulator, repository abstractions + implementations
  features/     auth, splash, customer, employee, admin, accounts, transactions,
                notifications, profile, reports, settings
  shared/       responsive app shell, cards, dialogs, charts, tables, filters
test/
  helpers/      platform mocks and shared test services
  unit/         RBAC, routes, ledger/idempotency, formatters, PDF bytes
  widget/       responsive shell, deep links, money-flow dialogs
```

## Safety notes

- Balances and transaction status always come from the server; the client never computes a
  an authoritative balance.
- Financial writes carry an `Idempotency-Key`; success UI appears only after confirmation.
- Tokens live only in `flutter_secure_storage`; preferences hold non-sensitive UI settings.
- No fake production transactions: demo data is in-memory, badged, and discarded on exit.
