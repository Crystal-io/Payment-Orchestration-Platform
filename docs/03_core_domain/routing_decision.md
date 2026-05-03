# Routing Decision

## 1. Overview

**Routing Decision** is an **immutable system decision** that determines:

- which PSP should be used for a specific `Payment Attempt`
- which PSPs are available as fallback options
- why a particular routing path was selected

**Core principle:**

> Routing Decision = snapshot of routing logic at execution time

Each `Payment Attempt` has **exactly one Routing Decision**.

---

## 2. Business Value

Routing Decision enables:

- multi-PSP strategy execution
- controlled failover handling
- smart routing based on data and performance
- A/B testing of PSPs
- routing performance analytics
- full auditability (why a PSP was selected)

---

## 3. Relationship with Core Entities

Payment → Payment Attempt → Routing Decision

| Entity          | Relationship           |
| --------------- | ---------------------- |
| Payment         | 1 → N Attempts         |
| Payment Attempt | 1 → 1 Routing Decision |

---

## 4. Lifecycle

### 4.1 Creation

Routing Decision is created:

- during `Payment Attempt` creation
- before sending request to PSP

---

### 4.2 Immutability

After creation:

- must NOT be modified
- serves as source of truth for analysis

If conditions change → a new attempt is created with a new decision

---

## 5. Decision Flow (High-Level)

1. Collect input data
2. Apply routing rules
3. Filter eligible PSPs
4. Score and prioritize PSPs
5. Select primary PSP
6. Build fallback chain
7. Persist Routing Decision

---

## 6. Input Data

Routing Decision uses:

### Payment Data

- amount
- currency
- country
- payment method
- BIN / issuer (if available)

---

### System Context

- PSP availability
- historical success rate
- latency metrics
- error rates

---

### External Signals

- antifraud decision
- risk score
- compliance constraints

---

## 7. Routing Strategies

### 7.1 Rule-based Routing

Examples:

- country → PSP
- currency → PSP
- payment method → PSP

---

### 7.2 Priority Routing

PSPs are selected based on predefined priority:

- primary
- secondary
- tertiary

---

### 7.3 Load Balancing

Traffic distribution strategies:

- weighted (e.g. 70/30 split)
- round-robin

---

### 7.4 Smart Routing (Recommended)

Based on:

- success rate
- latency
- decline patterns

---

### 7.5 A/B Routing (Optional)

Used for:

- PSP performance testing
- conversion optimization

---

## 8. Failover Strategy

### 8.1 Fallback Chain

Routing Decision contains:

- ordered list of PSPs for fallback

Example:

Primary: PSP_A  
Fallback: [PSP_B, PSP_C]

---

### 8.2 Failover Triggers

- timeout
- technical error
- retryable decline
- routing policy rules

---

### 8.3 Failover Behavior

- a new `Payment Attempt` is created
- the next PSP from fallback chain is selected
- a new Routing Decision is generated

---

## 9. Entity Structure

### 9.1 Core Fields

| Field              | Type      | Description                   |
| ------------------ | --------- | ----------------------------- |
| id                 | UUID      | Unique identifier             |
| payment_id         | UUID      | Reference to Payment          |
| payment_attempt_id | UUID      | Reference to Payment Attempt  |
| selected_psp       | string    | Selected PSP                  |
| candidate_psps     | array     | Eligible PSPs                 |
| fallback_order     | array     | Ordered fallback PSP list     |
| decision_reason    | string    | Human-readable explanation    |
| strategy_type      | string    | Rule / priority / smart / A/B |
| created_at         | timestamp | Creation timestamp            |

---

### 9.2 Scoring Fields (Optional but Recommended)

| Field                 | Description                      |
| --------------------- | -------------------------------- |
| psp_scores            | Map<PSP, score>                  |
| success_rate_snapshot | PSP performance at decision time |
| latency_snapshot      | PSP latency data                 |
| error_rate_snapshot   | PSP error rate                   |

---

### 9.3 Context Snapshot

| Field               | Description                       |
| ------------------- | --------------------------------- |
| input_parameters    | Full input used for decision      |
| antifraud_result    | Risk evaluation result            |
| constraints_applied | Compliance / business constraints |

---

## 10. Decision Reasoning

Routing Decision must be **explainable**.

Example:

"PSP_A selected due to highest success rate (92%) for BIN country and lowest latency"

This is critical for:

- debugging
- analytics
- compliance

---

## 11. Interaction with Payment Attempt

- Payment Attempt stores reference to Routing Decision
- Payment Attempt executes selected PSP
- On retry:
  - new Payment Attempt is created
  - new Routing Decision is generated

---

## 12. Observability & Metrics

Key metrics:

- success rate per routing strategy
- PSP selection distribution
- failover frequency
- conversion uplift (A/B routing)
- latency per PSP

---

## 13. Design Decisions

### Immutability

**Why:**

- guarantees auditability
- simplifies analysis

---

### Decision per Attempt

**Why:**

- system conditions change (PSP health, antifraud)
- enables dynamic routing

---

### Explicit Fallback Chain

**Why:**

- ensures predictable system behavior
- provides controlled failover

---

### Snapshot of Metrics

**Why:**

- analytics must reflect system state at decision time

---

## 14. Summary

`Routing Decision` is the **core orchestration component** that:

- controls PSP selection
- enables failover
- supports smart routing
- provides transparency and control

Without this entity, it is not possible to build:

- scalable multi-PSP systems
- adaptive routing mechanisms
- conversion-optimized payment flows
