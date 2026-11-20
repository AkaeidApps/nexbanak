# NEXBANK — Phase 1: Source Analysis & Product Contract

## 1. Finding about the "existing website"

The supplied workspace (`/home/akaid/nexbanak`) contains a **default Flutter counter-starter**
(`lib/main.dart`, `test/widget_test.dart`) and no other application code. A search of the
surrounding workspace found **no NEXBANK website source, backend service, OpenAPI/Swagger
specification, database schema, or brand asset files**.

Therefore, per the project brief:

> "If the website source code is available, inspect and reuse its existing backend, API
> contracts, database schema and assets."

…there is nothing available to reuse. The **prompt itself is the source of truth** for brand,
design, navigation, roles, features and workflows. All screens are implemented as native
Flutter UI (no WebView).

`docs/API_CONTRACT.md` defines the REST contract the Flutter client targets. The client is
fully wired to that contract via Dio. Because no institution-authorised backend is available,
the app ships with an **explicitly labelled DEMO DATA SOURCE** (switchable via
`--dart-define=USE_MOCK=true`, default `true`). Every demo action is labelled in the UI with a
"DEMO" badge and never writes to a real ledger. Set `USE_MOCK=false` and provide
`NEXBANK_API_BASE_URL` to talk to a real backend.

## 2. Brand contract (from brief)

| Token | Hex |
|---|---|
| Primary Navy | `#0B1F3A` |
| Secondary Blue | `#1D4ED8` |
| White | `#FFFFFF` |
| Background | `#F1F5F9` |
| Success Green | `#059669` |
| Error Red | `#DC2626` |
| Premium Gold | `#C9A227` |
| Dark Navy | `#071629` |
| Light Blue | `#EFF6FF` |
| Border | `#E2E8F0` |
| Primary Text | `#172033` |
| Secondary Text | `#64748B` |

- App name: **NEXBANK** · Tagline: **NEXT GENERATION BANKING**
- Typography: **Inter** (bundled local OTF assets; no runtime font fetch)
- Style: premium corporate banking, Material 3, rounded cards, subtle shadows,
  smooth motion, light + dark themes.

## 3. Screen inventory (derived from the brief)

### Shared / pre-auth
Splash · Onboarding · Login · Registration · Forgot password · OTP verification ·
Password reset · Biometric prompt · Role selection (demo) · Session expiry.

### Customer
- Navigation: Home · Accounts · Transfer · Transactions · Profile
- Dashboard: greeting, balance card with hide/show, savings overview, income/expense
  statistics, recent transactions, charts, quick actions, notifications.
- Accounts: My accounts, savings/current details, statements, opening request, status.
- Operations: deposit request, withdrawal request, internal transfer, beneficiaries,
  history, details, receipt/PDF.
- Services: loans (apply/status/repay), debit/credit cards + blocking, savings goals,
  fixed deposits.
- Services: notifications, profile, password, security, login history, help & support.

### Admin
- Dashboard KPIs: customers, accounts, deposits, withdrawals, transactions, loans,
  active employees, branches, pending approvals, suspicious transactions.
- Analytics: monthly deposit/withdrawal, transaction stats, customer/account growth,
  financial performance.
- Modules (each with search, filters, validation): Customers · Employees · Accounts ·
  Branches · Deposits · Withdrawals · Transfers · Transactions · Loans · Cards ·
  KYC · Reports · Audit logs · Notifications · Security · System settings.

### Employee
- Dashboard · Customer search/details · Account verification · Deposit/withdrawal
  processing · Customer requests · Transaction monitoring · Loan review · KYC ·
  Work history · Notifications · Profile · Approvals (maker–checker).

## 4. API modules (target contract)

`auth, customers, employees, accounts, deposits, withdrawals, transfers, transactions,
beneficiaries, loans, cards, notifications, reports, audit, settings, branches, kyc`

See `docs/API_CONTRACT.md` for paths, verbs, auth scopes and payload shapes.

## 5. Non-negotiable engineering rules applied

- No authoritative balance calculation in Flutter — balances always come from the API.
- Financial writes use an `Idempotency-Key` header.
- Success UI is shown only after backend confirmation.
- JWT access + refresh tokens in `flutter_secure_storage`; refresh-token rotation.
- RBAC enforced client-side for UX and **documented as required server-side** (`API_CONTRACT.md`).
- Every role has an independent shell/navigation stack.
- Money represented as integer minor units / decimal strings; never `double` for ledger math.
