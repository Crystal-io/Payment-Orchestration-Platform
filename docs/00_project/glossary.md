# Glossary

## 1. Overview

This document defines key terms used across the Payment Orchestration Platform.

The glossary ensures consistent understanding between business, product, and engineering teams.

---

## 2. Core Terms

### Payment

A business entity representing a customer's intent to transfer money for a product or service.

---

### Payment Attempt

A single attempt to process a payment through a specific PSP.

A payment may have multiple attempts (e.g., retries or failover).

---

### Transaction

A financial operation related to a payment, such as:

- authorization
- capture
- refund (future)

---

### Payment Status

The current state of a payment in its lifecycle (e.g., PENDING, AUTHORIZED, FAILED).

---

## 3. Actors

### Merchant

A client of the platform that integrates via API to process payments.

---

### Customer

An end-user who initiates a payment (not directly interacting with the gateway API).

---

### Payment Gateway

The system being built. It orchestrates the payment flow between merchants and PSPs.

---

### PSP (Payment Service Provider)

An external system that processes payments (e.g., Stripe, Adyen).

---

## 4. Processing Concepts

### Antifraud

A process that evaluates the risk level of a payment and produces a decision:

- ALLOW
- BLOCK
- REVIEW (future)

---

### Routing

The process of selecting a PSP to process a payment.

---

### Idempotency

A mechanism ensuring that repeated requests produce the same result without duplication.

---

### Webhook

An asynchronous HTTP callback used to notify systems about events.

Examples:

- PSP → Gateway (payment update)
- Gateway → Merchant (status notification)

---

### 3DS (3D Secure)

An additional authentication step required by some card payments.

---

## 5. Technical Concepts

### API (Application Programming Interface)

Interface used by merchants to interact with the payment gateway.

---

### Adapter

A component that translates internal logic into PSP-specific API calls.

---

### Event

A record of something that happened in the system (e.g., PaymentCreated, PaymentFailed).

---

### State Machine

A model that defines valid transitions between payment statuses.

---

## 6. Notes

- All terms are used consistently across documentation
- New terms should be added here before being used in other documents

---
