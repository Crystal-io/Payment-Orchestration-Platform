# Transaction

## 1. Overview

**Transaction** represents a **financial event executed via a PSP** and recorded by the platform.

It captures:

- interaction with external PSP
- financial operation outcome
- linkage to internal payment lifecycle

**Core principle:**

> Transaction = external financial event  
> Ledger = internal financial truth (future module)

---

## 2. Design Goals

The Transaction model must:

- support multi-step financial flows (auth/capture/refund)
- be fully async and event-driven
- support reconciliation and accounting
- be append-only (audit-safe)
- decouple PSP logic from internal financial representation

---

## 3. Relationship with Core Entities

Payment → Payment Attempt → Transaction

| Entity          | Relationship       |
| --------------- | ------------------ |
| Payment         | 1 → N Attempts     |
| Payment Attempt | 1 → N Transactions |

---

## 4. Transaction vs Ledger (Critical Separation)

| Concept     | Responsibility          |
| ----------- | ----------------------- |
| Transaction | External PSP event      |
| Ledger      | Internal money movement |

**Rule:**

> Transaction must NEVER be the only source of financial truth

---

## 5. Transaction Types (Normalized)

### 5.1 Core Financial Operations

| Type          | Description          |
| ------------- | -------------------- |
| AUTHORIZATION | Reserve funds        |
| CAPTURE       | Capture funds        |
| SALE          | Auth + capture       |
| VOID          | Cancel authorization |
| REFUND        | Return funds         |

---

### 5.2 Extended Events

| Type                | Description             |
| ------------------- | ----------------------- |
| PARTIAL_CAPTURE     | Partial capture         |
| REVERSAL            | Pre-settlement reversal |
| CHARGEBACK          | Dispute initiated       |
| CHARGEBACK_REVERSAL | Dispute resolved        |

---

## 6. Event-Driven Model

Transactions must be treated as **events, not state**.

### Rules:

- append-only (no updates)
- each change = new record
- derived state must be calculated

---

## 7. Entity Structure

### 7.1 Core Fields

| Field                 | Type      | Description                  |
| --------------------- | --------- | ---------------------------- |
| id                    | UUID      | Unique identifier            |
| payment_id            | UUID      | Payment reference            |
| payment_attempt_id    | UUID      | Attempt reference            |
| type                  | string    | Transaction type             |
| status                | string    | Event status                 |
| amount                | decimal   | Amount                       |
| currency              | string    | Currency                     |
| psp                   | string    | PSP name                     |
| psp_reference         | string    | PSP transaction ID           |
| parent_transaction_id | UUID      | Link to previous transaction |
| created_at            | timestamp | Event time                   |

---

### 7.2 Status Model

| Status     | Description           |
| ---------- | --------------------- |
| INITIATED  | Sent to PSP           |
| PROCESSING | In progress           |
| SUCCESS    | Completed             |
| FAILED     | Failed                |
| UNKNOWN    | No final confirmation |

---

### 7.3 Financial Snapshot Fields

| Field             | Description    |
| ----------------- | -------------- |
| authorized_amount | Total reserved |
| captured_amount   | Total captured |
| refunded_amount   | Total refunded |

---

### 7.4 PSP Payloads

| Field            | Description  |
| ---------------- | ------------ |
| request_payload  | Sent request |
| response_payload | PSP response |
| webhook_payload  | PSP webhook  |

---

### 7.5 Idempotency

| Field           | Description          |
| --------------- | -------------------- |
| idempotency_key | Unique operation key |

---

## 8. Transaction Chains

Transactions form a **linked chain**:

AUTH → CAPTURE → REFUND

### Example:

AUTH (t1)
└── CAPTURE (t2)
└── REFUND (t3)

---

## 9. Financial Rules

### 9.1 Integrity Constraints

- captured_amount ≤ authorized_amount
- refunded_amount ≤ captured_amount

---

### 9.2 Partial Operations

- multiple captures allowed
- multiple refunds allowed

---

## 10. Async & Webhook Rules

- PSP webhook is source of truth
- system must support:
  - delayed events
  - duplicate events
  - out-of-order events

---

## 11. Retry Rules

Retry allowed when:

- operation is idempotent
- PSP supports retry
- failure is transient

---

## 12. Reconciliation Readiness

Transaction must support:

- matching with PSP reports
- settlement verification
- discrepancy detection

Required fields:

- psp_reference
- amount
- currency
- timestamps

---

## 13. Observability & Metrics

### 13.1 Core Metrics

| Metric                   | Description     |
| ------------------------ | --------------- |
| transaction_success_rate | Success ratio   |
| auth_to_capture_rate     | Conversion rate |
| refund_rate              | Refund ratio    |
| chargeback_rate          | Dispute ratio   |
| transaction_latency      | Processing time |

---

### 13.2 Advanced Metrics

| Metric                  | Description        |
| ----------------------- | ------------------ |
| auth_expiry_rate        | Expired auths      |
| partial_capture_ratio   | Partial vs full    |
| refund_latency          | Time to refund     |
| dispute_resolution_rate | Chargeback success |

---

## 14. Design Decisions

### Event-Based Model

**Why:**

- ensures auditability
- supports async flows
- aligns with PSP behavior

---

### Append-Only Storage

**Why:**

- prevents data corruption
- enables full audit trail

---

### Transaction Chain Model

**Why:**

- supports complex financial flows
- simplifies reconciliation

---

### Separation from Ledger

**Why:**

- PSP ≠ source of financial truth
- enables internal accounting

---

## 15. Future Extensions

The model supports:

- ledger integration
- multi-currency settlement
- fee calculation
- split payments
- marketplace flows

---

## 16. Summary

Transaction is a **PSP-facing financial event layer** that:

- records external financial operations
- supports async processing
- enables reconciliation

In modern architecture:

> Transaction handles external reality  
> Ledger handles internal truth

This separation is critical for:

- scalability
- financial correctness
- enterprise-grade systems
