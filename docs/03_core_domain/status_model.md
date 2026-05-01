# Payment Status Model

## 1. Overview

This document defines the payment lifecycle and all possible states of a Payment.

The status model is a core part of the system and ensures:

- consistent payment processing
- correct handling of asynchronous events
- predictable behavior across integrations

---

## 2. Design Principles

- **Explicit State Machine** — all states and transitions are predefined
- **Single Source of Truth** — status is stored in Payment
- **Deterministic Transitions** — no ambiguous state changes
- **Async-first** — system handles delayed and duplicated events

---

## 3. Payment States

### 3.1 Initial States

| Status  | Description                              |
| ------- | ---------------------------------------- |
| CREATED | Payment is created but not yet processed |

---

### 3.2 Processing States

| Status          | Description                                 |
| --------------- | ------------------------------------------- |
| PENDING         | Payment is being processed                  |
| REQUIRES_ACTION | Additional user action required (e.g., 3DS) |
| PROCESSING      | Payment is being processed by PSP           |

---

### 3.3 Success States

| Status     | Description                     |
| ---------- | ------------------------------- |
| AUTHORIZED | Funds are reserved              |
| CAPTURED   | Funds are successfully captured |

---

### 3.4 Failure States

| Status    | Description                         |
| --------- | ----------------------------------- |
| FAILED    | Payment failed                      |
| CANCELLED | Payment cancelled by system or user |

---

## 4. State Transitions

### 4.1 High-Level Flow

```text
CREATED
  → PENDING
  → REQUIRES_ACTION (optional)
  → PROCESSING
  → AUTHORIZED
  → CAPTURED
```

---

### 4.2 Failure Flow

ANY STATE → FAILED
ANY STATE → CANCELLED

---

## 5. Transition Triggers

| Trigger      | Description                      |
| ------------ | -------------------------------- |
| API Request  | Payment created or updated       |
| PSP Response | Immediate response from PSP      |
| Webhook      | Async update from PSP            |
| System Logic | Antifraud or validation decision |

---

## 6. Antifraud Impact

Antifraud may influence transitions:

CREATED → FAILED (blocked)
CREATED → PENDING (allowed)

---

## 7. Routing Impact

Routing determines which PSP is used during:

PENDING → PROCESSING

Routing does not change status directly but affects processing outcome.

---

## 8. Idempotency Rules

Repeated events must not change state incorrectly
Duplicate webhooks must be ignored
State transitions must be validated before applying

---

## 9. Invalid Transitions

Examples of invalid transitions:

CAPTURED → PENDING
FAILED → PROCESSING
CANCELLED → AUTHORIZED

Such transitions must be rejected by the system.

---

## 10. Notes

Status is always derived from events
Final states: CAPTURED, FAILED, CANCELLED
System must handle out-of-order events safely
