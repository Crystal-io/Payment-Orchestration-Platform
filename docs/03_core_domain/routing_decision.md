# Routing Decision

## 1. Overview

**Routing Decision** — это **иммутабельное решение системы**, определяющее:

- какой PSP использовать для конкретного `Payment Attempt`
- какие PSP доступны как fallback
- почему был выбран именно этот путь

**Core principle:**

> Routing Decision = snapshot логики маршрутизации в момент выполнения

Каждый `Payment Attempt` имеет **ровно один Routing Decision**.

---

## 2. Business Value

Routing Decision позволяет:

- ✔ реализовать multi-PSP стратегию
- ✔ управлять failover цепочками
- ✔ внедрять smart routing (по данным и метрикам)
- ✔ проводить A/B тестирование PSP
- ✔ анализировать эффективность маршрутизации
- ✔ обеспечивать auditability (почему выбран PSP)

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

Routing Decision создаётся:

- при создании `Payment Attempt`
- до отправки запроса в PSP

---

### 4.2 Immutability

После создания:

- ❗ не изменяется
- используется как источник правды для анализа

Если условия изменились → создаётся новый attempt с новым decision

---

## 5. Decision Flow (High-Level)

1. Collect input data
2. Apply routing rules
3. Filter eligible PSPs
4. Score / prioritize PSPs
5. Select primary PSP
6. Build fallback chain
7. Persist Routing Decision

---

## 6. Input Data

Routing Decision использует:

### Payment Data

- amount
- currency
- country
- payment method
- BIN / issuer (если доступен)

### System Context

- PSP availability
- historical success rate
- latency metrics
- error rates

### External Signals

- antifraud decision
- risk score
- compliance constraints

---

## 7. Routing Strategies

### 7.1 Rule-based Routing

Примеры:

- country → PSP
- currency → PSP
- payment method → PSP

---

### 7.2 Priority Routing

PSP выбирается по приоритету:

- primary
- secondary
- tertiary

---

### 7.3 Load Balancing

Распределение трафика:

- weighted (например 70/30)
- round-robin

---

### 7.4 Smart Routing (Recommended)

На основе:

- success rate
- latency
- decline reasons

---

### 7.5 A/B Routing (Optional)

Используется для:

- тестирования PSP
- оптимизации конверсии

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
- routing policy

---

### 8.3 Failover Behavior

- new `Payment Attempt` is created
- next PSP from fallback chain is used
- new Routing Decision is generated

---

## 9. Entity Structure

### 9.1 Core Fields

| Field              | Type      | Description                   |
| ------------------ | --------- | ----------------------------- |
| id                 | UUID      | Unique identifier             |
| payment_id         | UUID      | Reference to Payment          |
| payment_attempt_id | UUID      | Reference to Payment Attempt  |
| selected_psp       | string    | Chosen PSP                    |
| candidate_psps     | array     | Eligible PSPs                 |
| fallback_order     | array     | Ordered fallback PSP list     |
| decision_reason    | string    | Human-readable explanation    |
| strategy_type      | string    | Rule / priority / smart / A-B |
| created_at         | timestamp | Creation time                 |

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

| Field               | Description                   |
| ------------------- | ----------------------------- |
| input_parameters    | Full input used for decision  |
| antifraud_result    | Risk decision                 |
| constraints_applied | Compliance / business filters |

---

## 10. Decision Reasoning

Routing Decision must be **explainable**.

Example:

"PSP_A selected due to highest success rate (92%) for BIN country + lowest latency"

This is critical for:

- debugging
- analytics
- compliance

---

## 11. Interaction with Payment Attempt

- Attempt stores reference to Routing Decision
- Attempt executes selected PSP
- On retry:
  - new Attempt is created
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

- conditions change (PSP health, antifraud)
- enables dynamic routing

---

### Explicit Fallback Chain

**Why:**

- predictable system behavior
- controlled failover

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

- scalable multi-PSP system
- adaptive routing
- conversion-optimized payment flows
