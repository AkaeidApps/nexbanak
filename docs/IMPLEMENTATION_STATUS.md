# NEXBANK — Implementation status (Phases 1–9)

All nine phases are implemented. The workspace has no git repository, so nothing has been
committed or pushed; all files are local working-tree changes.

| Phase | Scope | Status | Key artifacts |
|---|---|---|---|
| 1 | Source analysis & product contract | Complete | `docs/PHASE_1_ANALYSIS.md`, `docs/API_CONTRACT.md` |
| 2 | Dependencies, brand tokens, design system | Complete | `pubspec.yaml`, `lib/app/theme/*`, `lib/shared/widgets/*`, bundled Inter fonts |
| 3 | Core services & network layer | Complete | `lib/core/network/*`, `lib/core/services/*`, `lib/core/base_controller.dart` |
| 4 | Data layer & demo simulator | Complete | `lib/data/models/*`, `lib/data/providers/*`, `lib/data/repositories/*` |
| 5 | Auth & onboarding flows | Complete | splash, onboarding, login, register, forgot/OTP/reset, biometrics |
| 6 | Role shells, dashboards, navigation | Complete | `lib/shared/widgets/app_shell.dart`, three role shells, `lib/app/routes/*` |
| 7 | Banking features & money workflows | Complete | transfers, deposits, withdrawals, beneficiaries, loans, cards, savings, approvals, KYC, reports |
| 8 | Shared/deep views & responsive polish | Complete | notifications, profile, security, history, help, settings, audit, detail screens, PDF documents |
| 9 | Automated tests & verification | Complete | `test/unit/*`, `test/widget/*`, analyzer and full test suite green |

## Verification run

```bash
flutter analyze --no-fatal-infos --no-fatal-warnings
# No issues found!

flutter test --reporter expanded
# 35 tests passed.
```

Coverage highlights:

- **Auth/roles:** role wire values, UX permissions, demo credentials, OTP reset, JWT service.
- **Routes/bindings:** every declared `Routes.*` has a unique page, role deep links resolve,
  demo repositories are wired by `AppBinding`.
- **Money safety:** deposit/withdrawal requests remain pending and do not mutate balances;
  idempotency keys are required; OTP-verified transfer debits/credits exact decimal strings;
  self-approval is rejected; audit events are recorded.
- **UI:** balance masking, mobile/tablet/desktop shells, role deep links, transaction dialogs
  distinguishing “backend confirmed” from “pending approval”, demo badge on shell and shared screens.
- **Documents:** receipt and statement PDF builders produce valid `%PDF` byte streams.

## Runtime verification matrix

| Check | Result |
|---|---|
| Named routes and role deep links (`/customer/home`, `/employee/home`, `/admin/home`) | Verified by widget tests |
| Independent role navigation stacks and shell layouts | Verified by widget tests |
| Demo badge visible in shells and shared screens | Verified by widget tests |
| Money dialogs: confirmed transfer vs pending request | Verified by widget tests |
| Responsive breakpoints: mobile bottom nav, tablet drawer, desktop sidebar | Verified at 390×844, 900×800, 1440×900 |
| PDF receipt / account statement generation | Verified by byte-level unit tests |
| Live backend persistence and end-to-end server RBAC | Not verifiable: no backend supplied |

## Commands

### Demo (default)

```bash
flutter pub get --offline
flutter run --dart-define=USE_MOCK=true
```

Demo users: `customer@nexbank.demo`, `employee@nexbank.demo`, `admin@nexbank.demo`.
Password: `Demo@123`. OTP: `123456`.

### Live

```bash
flutter run \
  --dart-define=USE_MOCK=false \
  --dart-define=NEXBANK_API_BASE_URL=https://api.example.com/v1
```

### Release builds

```bash
flutter build appbundle --release --dart-define=USE_MOCK=true
flutter build ipa --release --dart-define=USE_MOCK=true

# Live variants add USE_MOCK=false and NEXBANK_API_BASE_URL.
```

## Known limitations

- The demo data source is in-memory only; restarting the app resets it.
- No institution backend was available, so live API persistence, real KYC and real
  maker–checker enforcement remain contract requirements for the server, not verified runtime
  behaviour.
- `flutter pub get --offline` is reliable in this environment; a plain `flutter pub get` has
  previously timed out on network resolution.
