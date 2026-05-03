# Merchant

## 1. Overview

**Merchant** represents a **business entity (client/tenant)** using the Payment Orchestration Platform to process payments.

The system is **multi-tenant**, where each Merchant:

- operates independently
- has isolated configuration
- controls its own payment behavior

**Core principle:**

> Merchant = tenant + configuration boundary

---

## 2. Business Role

Merchant is responsible for:

- initiating payments (via API)
- defining payment processing configuration
- controlling routing and retry behavior
- integrating with webhooks
- managing PSP connectivity

All core flows are executed **within merchant context**.

---

## 3. Relationship with Core Entities

Merchant → Payment → Payment Attempt → Routing Decision

| Entity          | Relationship           |
| --------------- | ---------------------- |
| Merchant        | 1 → N Payments         |
| Payment         | 1 → N Attempts         |
| Payment Attempt | 1 → 1 Routing Decision |

---

## 4. Entity Structure

### 4.1 Core Fields

| Field      | Type      | Description                   |
| ---------- | --------- | ----------------------------- |
| id         | UUID      | Unique identifier             |
| name       | string    | Merchant name                 |
| status     | string    | ACTIVE / SUSPENDED / DISABLED |
| created_at | timestamp | Creation timestamp            |
| updated_at | timestamp | Last update timestamp         |

---

### 4.2 Configuration Fields

| Field                     | Type    | Description              |
| ------------------------- | ------- | ------------------------ |
| enabled_psps              | array   | List of available PSPs   |
| default_currency          | string  | Default currency         |
| supported_currencies      | array   | Allowed currencies       |
| supported_payment_methods | array   | Allowed payment methods  |
| routing_strategy          | string  | Rule / priority / smart  |
| max_attempts              | integer | Max attempts per payment |
| failover_enabled          | boolean | Enables PSP failover     |
| antifraud_enabled         | boolean | Enables antifraud checks |

---

### 4.3 Integration Fields

| Field          | Type   | Description                |
| -------------- | ------ | -------------------------- |
| webhook_url    | string | Merchant webhook endpoint  |
| webhook_secret | string | Signature verification key |
| api_key        | string | API authentication key     |

---

## 5. Configuration Model

Merchant configuration defines **runtime behavior of the system**.

### 5.1 PSP Configuration

- which PSPs are available
- priority / weighting
- country or method restrictions

---

### 5.2 Routing Configuration

Defines:

- routing strategy
- fallback chain behavior
- load balancing rules

---

### 5.3 Retry Configuration

Defines:

- max attempts
- retryable conditions
- retry delays (optional)

---

### 5.4 Antifraud Configuration

Defines:

- whether antifraud is enabled
- rules / thresholds (external or internal)

---

## 6. Multi-Tenancy Rules

### 6.1 Data Isolation

- Each merchant’s data must be fully isolated
- No cross-merchant data access is allowed

---

### 6.2 Configuration Isolation

- Routing, retry, and PSP configuration must be merchant-specific
- Changes must not affect other merchants

---

### 6.3 Security Boundary

- API access must be scoped per merchant
- All operations must validate merchant identity

---

## 7. Lifecycle

### 7.1 Onboarding

Merchant is created with:

- basic profile
- initial configuration
- API credentials

---

### 7.2 Activation

Merchant becomes active when:

- PSP configuration is completed
- webhook endpoint is configured
- system validation passes

---

### 7.3 Suspension

Merchant may be suspended due to:

- compliance issues
- fraud detection
- manual action

Effect:

- new payments are blocked
- existing flows may continue (configurable)

---

### 7.4 Deactivation

- Merchant is fully disabled
- no payment operations allowed

---

## 8. Interaction with Other Components

### 8.1 Payment Processing

- All payments are created under a merchant
- Merchant configuration defines processing behavior

---

### 8.2 Routing

- Routing Decision uses merchant configuration
- PSP selection is constrained by merchant settings

---

### 8.3 Payment Attempts

- Retry limits are defined per merchant
- Failover behavior is controlled by merchant configuration

---

### 8.4 Webhooks

- System sends events to merchant webhook
- Delivery and retry depend on merchant setup

---

## 9. Observability & Metrics

Metrics per merchant:

- payment success rate
- PSP performance
- retry effectiveness
- failover usage
- error distribution

---

## 10. Design Decisions

### Merchant as Configuration Boundary

**Why:**

- allows flexible customization per client
- supports multiple business models
- isolates risk and failures

---

### Multi-Tenant Architecture

**Why:**

- enables platform scalability
- reduces operational overhead
- supports SaaS model

---

### Centralized Configuration

**Why:**

- simplifies routing and retry logic
- avoids hardcoding behavior in services

---

## 11. Summary

`Merchant` is the **top-level domain entity** that:

- defines system behavior via configuration
- isolates tenants in a multi-tenant environment
- controls routing, retry, and PSP usage

All payment processing flows are executed **within merchant context**, making it a critical foundation for the platform.
