# Assumptions

## 1. Overview

This document outlines the key assumptions made during the design and development of the MVP version of the Payment Orchestration Platform.

Assumptions help define boundaries and reduce uncertainty in early stages.

---

## 2. Technical Assumptions

### 2.1 API Design

- The system exposes RESTful APIs
- JSON is used as the primary data format
- API is versioned (e.g., `/v1/`)

### 2.2 System Architecture

- The system is stateless and horizontally scalable
- Services communicate over HTTP (initially)
- Event-driven processing is used for asynchronous flows (webhooks)

### 2.3 Database

- PostgreSQL is used as the primary database
- ACID compliance is required for payment data
- Data consistency is prioritized over eventual consistency (for core payment entities)

---

## 3. Integration Assumptions

### 3.1 PSP Capabilities

- PSP provides:
  - API for payment processing
  - webhook notifications for asynchronous updates
- PSP may return both synchronous and asynchronous responses

### 3.2 Webhooks

- Webhooks may:
  - arrive late
  - be delivered multiple times
  - be delivered out of order

System must handle all these cases safely.

---

## 4. Business Assumptions

### 4.1 Payment Flow

- Payments are primarily card-based
- Each payment has a clear lifecycle and final state

### 4.2 Merchant Behavior

- Merchants rely on webhook notifications
- Merchants may retry requests (idempotency required)

### 4.3 Fraud

- Basic rule-based antifraud is sufficient for MVP
- Advanced fraud detection will be added later

---

## 5. Operational Assumptions

- External systems (PSPs) are unreliable
- Network failures are expected
- Retries and idempotency are required at all layers

---

## 6. Constraints

- MVP must be implemented with minimal complexity
- Time-to-market is prioritized over feature completeness
- System must be extensible without major redesign

---

## 7. Risks Derived from Assumptions

| Assumption                    | Risk                               |
| ----------------------------- | ---------------------------------- |
| PSP is reliable               | PSP downtime may affect payments   |
| Webhooks arrive correctly     | Missing webhook → incorrect status |
| Single PSP is sufficient      | Limits routing and failover        |
| Simple fraud rules are enough | May not detect sophisticated fraud |

---
