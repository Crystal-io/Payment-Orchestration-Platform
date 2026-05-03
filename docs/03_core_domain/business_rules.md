# Business Rules

## 1. Overview

This document defines the **core business rules and decision logic framework** governing the Payment Orchestration Platform.

Unlike static rule definitions, the system follows a:

> **Policy-driven, event-based rule execution model**

Business rules control:

- payment lifecycle behavior
- retry and failover decisions
- routing constraints
- antifraud enforcement
- system consistency and safety

---

## 2. Design Principles

### 2.1 Policy-Based Architecture

Rules are not hardcoded — they are:

- configurable
- versioned
- context-aware

> Business Rules = Executable Policies

---

### 2.2 Event-Driven Execution

Rules are evaluated on events:

- Payment Created
- Attempt Started
- PSP Response Received
- Webhook Received
- Retry Triggered

---

### 2.3 Deterministic Outcomes

Given same inputs → same decision must be produced

---

### 2.4 Explainability

Every rule execution must produce:

- decision
- reason
- input context

---

### 2.5 Extensibility

New rules must be added without:

- changing core code
- breaking existing flows

---

## 3. Rule Execution Stages

### 3.1 Pre-Processing Rules

Executed before attempt creation:

- validation
- antifraud pre-check
- payment eligibility

---

### 3.2 Processing Rules

Executed during attempt:

- routing selection
- retry decisions
- failover logic

---

### 3.3 Post-Processing Rules

Executed after PSP response:

- status normalization
- retry eligibility
- finalization

---

## 4. Rule Categories

### 4.1 Validation Rules

Ensure input correctness:

- amount > 0
- supported currency
- valid payment method
- merchant is active

---

### 4.2 Routing Rules

Define PSP selection:

- method compatibility
- region restrictions
- PSP availability
- merchant configuration

---

### 4.3 Retry Rules

Control retry behavior:

- retryable error detection
- max_attempts enforcement
- method-specific retry policy

---

### 4.4 Failover Rules

Control PSP switching:

- fallback chain execution
- failover eligibility
- failover limits

---

### 4.5 Antifraud Rules

Influence decision making:

- block payment
- require step-up (3DS)
- allow or deny retry

---

### 4.6 Status Rules

Ensure valid state transitions:

- enforce state machine
- prevent invalid transitions
- normalize PSP statuses

---

### 4.7 Financial Rules

Ensure financial integrity:

- prevent over-capture
- prevent over-refund
- ensure transaction consistency

---

## 5. Rule Inputs

Rules operate on unified context:

### 5.1 Payment Context

- amount
- currency
- method
- merchant configuration

---

### 5.2 Attempt Context

- attempt_number
- previous failures
- retry_count

---

### 5.3 Routing Context

- available PSPs
- fallback chain
- scoring data

---

### 5.4 External Signals

- antifraud result
- risk score
- PSP response codes

---

## 6. Rule Outputs

Each rule execution produces:

| Output      | Description                     |
| ----------- | ------------------------------- |
| decision    | ALLOW / DENY / RETRY / FAILOVER |
| reason_code | Machine-readable reason         |
| explanation | Human-readable explanation      |
| next_action | What system should do           |

---

## 7. Retry Rules (Detailed)

Retry is allowed only when:

- failure is classified as retryable
- retry limit not exceeded
- payment method supports retry
- antifraud allows retry

---

## 8. Failover Rules (Detailed)

Failover is allowed when:

- PSP failure is retryable
- alternative PSP exists
- failover limit not exceeded

Failover must:

- create new Payment Attempt
- use next PSP in fallback chain

---

## 9. Idempotency Rules

- all operations must be idempotent
- duplicate requests must not create side effects
- retry must be safe

---

## 10. Consistency Rules

### 10.1 State Consistency

- Payment state must reflect latest valid attempt
- Transaction state must reflect PSP state

---

### 10.2 Eventual Consistency

System allows:

- async updates
- delayed confirmations

But must ensure:

- final state correctness

---

## 11. Safety Rules

### 11.1 No Infinite Loops

- retry loops must be limited
- failover loops must be limited

---

### 11.2 Circuit Breakers (Recommended)

System should:

- disable failing PSPs temporarily
- reroute traffic automatically

---

### 11.3 Timeout Handling

- long-running operations must be terminated
- UNKNOWN state must be handled explicitly

---

## 12. Observability & Auditability

Every rule execution must be logged:

- input context
- decision
- timestamp
- affected entities

---

## 13. Rule Versioning

Rules must support:

- versioning
- gradual rollout
- rollback capability

---

## 14. Design Decisions

### Policy-Based Rules

**Why:**

- flexibility
- configurability
- faster iteration

---

### Event-Driven Execution

**Why:**

- aligns with async architecture
- supports real-time decisions

---

### Explainable Decisions

**Why:**

- debugging
- compliance
- analytics

---

### Separation from Core Logic

**Why:**

- avoids tight coupling
- enables rule engine evolution

---

## 15. Summary

Business Rules form the **decision engine of the platform**:

- control payment behavior
- enforce system integrity
- enable smart routing and retry

A modern system must treat rules as:

> dynamic, explainable, and configurable policies

This approach enables:

- higher conversion rates
- safer payment processing
- faster product iteration
- enterprise-grade flexibility
