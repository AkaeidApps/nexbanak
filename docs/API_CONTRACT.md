# NEXBANK REST API Contract (client target)

Base URL: `--dart-define=NEXBANK_API_BASE_URL=https://api.nexbank.example/v1`
Demo switch: `--dart-define=USE_MOCK=true` (default). Demo is visibly badged in the UI.

## Conventions

- JSON request/response. All protected routes require `Authorization: Bearer <accessToken>`.
- `POST/PATCH` money operations **must** send `Idempotency-Key: <uuid>`; server deduplicates.
- Money fields are decimal **strings** (e.g. `"12500.50"`) — never floats.
- Timestamps are ISO-8601 UTC. Lists support `?page=1&limit=20&search=&from=&to=&status=`.
- Errors: `{ "error": { "code": "INSUFFICIENT_FUNDS", "message": "...", "details": {} } }`.
- **Server must re-validate role and maker–checker rules on every route.** Frontend checks
  are UX only. A checker must never be the maker of the same operation.

## Auth (`/auth`)

| Verb | Path | Access | Purpose |
|---|---|---|---|
| POST | `/auth/login` | public | email + password → access/refresh tokens, user, role |
| POST | `/auth/register` | public | customer registration (pending KYC) |
| POST | `/auth/refresh` | refresh token | rotate refresh, issue new access |
| POST | `/auth/logout` | auth | revoke refresh token/device |
| POST | `/auth/forgot-password` | public | send OTP |
| POST | `/auth/verify-otp` | public | verify OTP, return reset token |
| POST | `/auth/reset-password` | reset token | set new password |
| POST | `/auth/biometric/verify` | auth | verify biometric assertion |
| GET | `/auth/me` | auth | current session + permissions |
| GET | `/auth/login-history` | auth | device/login audit |

## Accounts / transactions

| Verb | Path | Access |
|---|---|---|
| GET | `/accounts?type=&status=&page=` | customer(own)/employee/admin |
| GET | `/accounts/:id` | owner or staff |
| POST | `/accounts/requests` | customer |
| GET | `/accounts/:id/statements?from=&to=` | owner or staff |
| POST | `/deposits` | customer (request) |
| POST | `/withdrawals` | customer (request) |
| POST | `/transfers` | customer |
| GET | `/transactions?accountId=&type=&status=&page=` | owner or staff |
| GET | `/transactions/:id` | owner or staff |
| GET | `/transactions/:id/receipt.pdf` | owner or staff |
| GET/POST/DELETE | `/beneficiaries` | customer |

## Loans / cards / savings

`GET|POST /loans`, `POST /loans/:id/repay`, `GET /loans/:id`;
`GET /cards`, `PATCH /cards/:id/status`, `GET /savings-goals`, `POST /savings-goals`,
`GET /fixed-deposits`, `POST /fixed-deposits`.

## Staff workflows

| Verb | Path | Access | Notes |
|---|---|---|---|
| GET | `/approvals?type=&status=` | employee/admin | pending maker queue |
| POST | `/approvals/:id/approve` | checker | 409 if maker == checker |
| POST | `/approvals/:id/reject` | checker | reason required |
| GET | `/customers`, `/employees`, `/branches` | staff | search + pagination |
| GET/PATCH | `/kyc/:id`, `/kyc?status=` | staff | verify/reject KYC |
| GET | `/reports/:type?from=&to=` | staff | CSV/PDF/JSON |
| GET | `/audit-logs?actor=&from=&to=` | admin | immutable audit trail |
| GET/PATCH | `/settings`, `/security` | admin | system + security config |
| GET | `/notifications`, PATCH `/notifications/:id/read` | auth | per-user |

## Status model

`pending → approved → processing → completed` or `rejected / failed / cancelled`.
Financial completion (balance mutation) occurs **only** in the backend transaction;
the client never marks an operation complete locally.
