# Scope

## 1. Overview

This document defines the scope of the MVP version of the Payment Orchestration Platform, including what is included and excluded from the initial release.

---

## 2. In Scope (MVP)

The MVP focuses on delivering a minimal, end-to-end payment processing flow.

### 2.1 Payment Processing

- Create payment via API
- Retrieve payment status
- Maintain payment lifecycle

### 2.2 PSP Integration

- Integration with a single PSP
- Use of adapter pattern to abstract PSP-specific logic

### 2.3 Webhook Processing

- Receive and process PSP webhooks
- Update payment status based on asynchronous events
- Ensure idempotent processing of webhooks

### 2.4 Merchant Notifications

- Send webhook notifications to merchants
- Notify about payment status updates

### 2.5 Antifraud (Basic)

- Perform rule-based risk evaluation
- Produce simple decision: `ALLOW` or `BLOCK`

### 2.6 Routing (Basic)

- Select PSP based on predefined static rules
- No dynamic optimization or scoring

### 2.7 Idempotency

- Prevent duplicate payment creation
- Ensure safe retries for API calls

---

## 3. Out of Scope (MVP)

The following features are explicitly excluded from the MVP:

### 3.1 Payments

- Refund processing
- Partial captures
- Payouts

### 3.2 Routing

- Multi-PSP smart routing
- Load balancing across PSPs
- Cost-based optimization

### 3.3 Antifraud

- Machine learning models
- Advanced risk scoring
- External fraud providers integration

### 3.4 Financial Processing

- Settlement tracking
- Reconciliation
- Chargeback management

### 3.5 Product Features

- Merchant dashboard / UI
- Reporting and analytics
- Multi-currency support (advanced scenarios)

---

## 4. Future Scope (Post-MVP)

Planned enhancements include:

- Multi-PSP support with failover
- Smart routing (based on success rate, cost, risk)
- Advanced antifraud (risk scoring, ML models)
- Refunds and full transaction lifecycle
- Reconciliation and settlement tracking
- Support for alternative payment methods (APMs)

---

## 5. Scope Boundaries

### Included:

- Backend services only
- API-first system
- Card payments (primary use case)

### Excluded:

- Frontend/UI
- Direct bank integrations
- Manual operations interface

---

## 6. Assumptions

- PSP provides webhook support
- Merchant integrates via REST API
- System is stateless and scalable
- Payment lifecycle is managed centrally

---

## 7. Risks

- PSP behavior may be inconsistent
- Webhooks may be delayed or duplicated
- Incorrect scope definition may lead to overengineering

---
