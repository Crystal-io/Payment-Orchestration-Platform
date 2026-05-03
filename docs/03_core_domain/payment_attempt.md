# Payment Attempt

## 1. Overview

**Payment Attempt** represents a **single execution attempt of a Payment through a specific PSP (Payment Service Provider)**.

A single `Payment` can have **multiple Payment Attempts** due to:

- retries (same PSP)
- failover (different PSP)
- routing decisions (multi-PSP strategy)

**Core principle:**

> Payment = business intent  
> Payment Attempt = technical execution

---

## 2. Business Value

Separating `Payment` and `Payment Attempt` enables:

- ✔ Safe retry without losing history
- ✔ Multi-PSP orchestration and routing
- ✔ Failover between PSPs
- ✔ PSP performance analytics (success rate, latency, errors)
- ✔ Per-attempt antifraud decisions
- ✔ Strong idempotency control
- ✔ Full audit trail of execution attempts

---

## 3. Relationship with Payment

Payment (1) ---- (N) Payment Attempts

| Field          | Description                      |
| -------------- | -------------------------------- |
| payment_id     | Reference to Payment             |
| attempt_number | Sequential number of attempt     |
| is_active      | Indicates current active attempt |

### Rules

- Only **one active attempt** at any given time
- New attempt is created when:
  - retry is triggered
  - failover occurs
  - routing decision changes PSP

---

## 4. Lifecycle Triggers

### 4.1 Initial Attempt

Created after:

- Payment creation
- basic validation
- initial antifraud checks

---

### 4.2 Retry

Triggered when:

- soft decline (e.g. insufficient funds)
- network errors / timeouts
- PSP technical failures
- unknown status (no webhook confirmation)

Retry can:

- reuse same PSP
- switch PSP (depending on routing rules)

---

### 4.3 Failover

Triggered when:

- PSP is unavailable
- high failure rate detected
- hard decline mapped as retryable (business decision)
- routing engine selects alternative PSP

---

### 4.4 User-driven Retry

Triggered by:

- user action (e.g. "Try again")
- expired session recovery
- 3DS re-attempt

---

## 5. Entity Structure

### 5.1 Core Fields

| Field           | Type      | Description                         |
| --------------- | --------- | ----------------------------------- |
| id              | UUID      | Unique identifier                   |
| payment_id      | UUID      | Parent Payment reference            |
| attempt_number  | integer   | Incremental attempt index           |
| is_active       | boolean   | Active attempt flag                 |
| psp             | string    | Selected PSP                        |
| payment_method  | string    | Payment method (card, wallet, etc.) |
| amount          | decimal   | Attempt amount                      |
| currency        | string    | Currency                            |
| status          | string    | Attempt status                      |
| failure_reason  | string    | Normalized failure reason           |
| psp_reference   | string    | PSP-side transaction ID             |
| idempotency_key | string    | Unique key per attempt              |
| created_at      | timestamp | Creation time                       |
| updated_at      | timestamp | Last update                         |

---

### 5.2 Technical Fields

| Field               | Description              |
| ------------------- | ------------------------ |
| request_payload     | Raw request sent to PSP  |
| response_payload    | Last response from PSP   |
| webhook_payload     | Last webhook received    |
| latency_ms          | Processing time          |
| retry_count         | Retry attempts counter   |
| routing_decision_id | Link to routing decision |

---

## 6. Status Model

Payment Attempt follows **event-driven async lifecycle**, aligned with PSP responses.

### Example statuses:

- `INITIATED`
- `PROCESSING`
- `REQUIRES_ACTION` (e.g. 3DS)
- `AUTHORIZED`
- `CAPTURED`
- `FAILED`
- `UNKNOWN`

> PSP webhook is the **source of truth** for final state.

---

## 7. Retry Logic

### 7.1 Retry Strategy Types

| Strategy        | Description                               |
| --------------- | ----------------------------------------- |
| Immediate retry | Instant retry on transient error          |
| Delayed retry   | Retry after timeout                       |
| Smart retry     | Based on error code / antifraud / routing |
| No retry        | Hard decline                              |

---

### 7.2 Retry Decision Factors

- PSP error code mapping
- antifraud decision
- payment method type
- issuer response
- retry limits (max_attempts)

---

### 7.3 Idempotency

Each attempt must have:

- unique `idempotency_key`
- safe reprocessing without duplication

---

## 8. Failover Strategy

### 8.1 Failover Triggers

- PSP timeout
- technical error
- degraded performance
- routing engine decision

---

### 8.2 Failover Rules

- new attempt is created with:
  - new PSP
  - new idempotency key
- previous attempt is marked inactive
- full traceability is preserved

---

## 9. Interaction with Routing Engine

Payment Attempt is tightly coupled with routing:

- routing decision defines:
  - PSP
  - priority
  - fallback chain

- each attempt stores:
  - routing decision reference
  - execution outcome

---

## 10. Interaction with Antifraud

Antifraud can:

- block attempt creation
- require step-up (3DS)
- allow retry / deny retry
- affect routing decision

Antifraud decisions are **evaluated per attempt**, not per payment.

---

## 11. Observability & Metrics

Key metrics per attempt:

- success rate per PSP
- latency
- error distribution
- retry effectiveness
- failover success rate

---

## 12. Design Decisions

### Separation of Payment vs Attempt

**Why:**

- avoids overwriting execution history
- enables orchestration logic
- supports async flows

---

### Attempt-level Idempotency

**Why:**

- prevents duplicate PSP transactions
- ensures safe retries

---

### Single Active Attempt

**Why:**

- simplifies state management
- avoids race conditions

---

### Webhook-driven Updates

**Why:**

- PSP is source of truth
- ensures consistency in async flows

---

## 13. Summary

`Payment Attempt` is a **core orchestration unit** that enables:

- retry and failover strategies
- multi-PSP execution
- antifraud and routing integration
- full observability and control

Without this entity, a scalable Payment Orchestration Platform is not feasible.
