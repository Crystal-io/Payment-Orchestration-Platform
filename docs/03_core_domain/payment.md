# Payment Domain Model

## 1. Overview

The Payment entity is the core business object of the system.

It represents a single payment initiated by a merchant and managed by the Payment Orchestration Platform throughout its lifecycle.

The Payment acts as:

- a source of truth for the transaction
- a container for all processing steps (fraud, routing, PSP interaction)
- a stable abstraction over PSP-specific implementations

---

## 2. Design Principles

- **Single Source of Truth** — Payment stores the canonical state
- **Extensible** — supports antifraud, routing, retries without redesign
- **PSP-agnostic** — abstracts external provider differences
- **Immutable Events, Mutable State** — state evolves via events

---

## 3. Entity Structure

### 3.1 Core Fields

| Field       | Type      | Description               |
| ----------- | --------- | ------------------------- |
| id          | UUID      | Unique payment identifier |
| merchant_id | UUID      | Reference to merchant     |
| amount      | Decimal   | Payment amount            |
| currency    | String    | ISO currency code         |
| status      | Enum      | Current payment status    |
| created_at  | Timestamp | Creation time             |
| updated_at  | Timestamp | Last update time          |

---

### 3.2 Payment Details

| Field       | Type   | Description                    |
| ----------- | ------ | ------------------------------ |
| description | String | Payment description            |
| return_url  | String | URL for redirect after payment |
| metadata    | JSON   | Arbitrary merchant data        |

---

### 3.3 Processing Context (Extensible)

| Field            | Type | Description                      |
| ---------------- | ---- | -------------------------------- |
| antifraud_result | JSON | Result of risk evaluation        |
| routing_decision | JSON | Selected PSP and routing info    |
| next_action      | JSON | Required user action (e.g., 3DS) |

---

### 3.4 Idempotency

| Field           | Type   | Description                         |
| --------------- | ------ | ----------------------------------- |
| idempotency_key | String | Prevents duplicate payment creation |

---

## 4. Related Entities

### 4.1 PaymentAttempt

Represents an attempt to process the payment via a PSP.

A Payment may have multiple attempts (failover, retries).
Payment
└── PaymentAttempt (1..N)

---

### 4.2 Transaction

Represents financial operations:

- authorization
- capture
- refund (future)  
  Payment
  └── Transaction (1..N)

---

## 5. Lifecycle Responsibility

The Payment entity is responsible for:

- tracking current status
- storing processing context
- linking attempts and transactions
- ensuring consistency across async events

---

## 6. State Management

Payment status is managed via a state machine (defined in `status_model.md`).

State transitions are triggered by:

- API calls
- PSP responses
- webhooks

---

## 7. Extensibility Model

The Payment entity is designed to support additional modules without modification of core fields.

Examples:

- antifraud → writes into `antifraud_result`
- routing → writes into `routing_decision`
- 3DS → updates `next_action`

---

## 8. Example (JSON Representation)

{
"id": "pay_123",
"merchant_id": "m_456",
"amount": 100.00,
"currency": "EUR",
"status": "PENDING",
"description": "Order #1001",
"return_url": "https://merchant.com/return",
"metadata": {
"order_id": "1001"
},
"antifraud_result": {
"decision": "ALLOW",
"score": 10
},
"routing_decision": {
"psp": "Stripe"
},
"next_action": null,
"created_at": "2026-01-01T10:00:00Z",
"updated_at": "2026-01-01T10:00:05Z"
}

---

## 9. Key Decisions

- Payment is **not tied to a single PSP**
- Multiple attempts are allowed
- Processing context is stored as JSON (flexible schema)
- State is explicit and controlled via state machine

---

## 10. Risks

- Overuse of JSON fields may reduce schema clarity
- Incorrect state transitions may lead to inconsistencies
- Missing idempotency may cause duplicate payments

---
