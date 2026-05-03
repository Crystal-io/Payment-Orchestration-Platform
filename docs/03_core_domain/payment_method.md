# Payment Method

## 1. Overview

**Payment Method** defines **how a payment is performed from the end-user perspective**, including:

- the type of payment instrument used
- the execution flow (interaction model)
- processing characteristics (sync/async)
- behavioral constraints (retry, failover, authentication)

**Core principle:**

> Payment Method defines execution behavior, not just payment type

---

## 2. Design Goals

The Payment Method model must:

- support global and local payment methods
- unify heterogeneous PSP implementations
- enable flexible routing and failover
- support async-first processing
- allow extension without schema changes
- separate concerns (method, instrument, flow)

---

## 3. Core Concepts

### 3.1 Payment Method vs Payment Instrument

| Concept            | Description                                               |
| ------------------ | --------------------------------------------------------- |
| Payment Method     | Abstract way of paying (CARD, BANK_TRANSFER, WALLET)      |
| Payment Instrument | конкретные данные (card PAN, token, IBAN, wallet payload) |

**Rule:**

> Payment Method = behavior  
> Payment Instrument = data

---

### 3.2 Method Structure

| Field       | Description                                            |
| ----------- | ------------------------------------------------------ |
| method_type | High-level category (CARD, WALLET, BANK_TRANSFER, APM) |
| method_code | Specific method (visa, mastercard, ideal, klarna)      |
| scheme      | Network/provider (visa, sepa, etc.)                    |
| region      | Applicable geography                                   |

---

## 4. Classification

### 4.1 By Method Type

| Type          | Examples              |
| ------------- | --------------------- |
| CARD          | Visa, Mastercard      |
| WALLET        | Apple Pay, Google Pay |
| BANK_TRANSFER | SEPA, Faster Payments |
| APM           | iDEAL, Klarna, Sofort |

---

### 4.2 By Interaction Model (Flow Type)

| Flow Type | Description                        |
| --------- | ---------------------------------- |
| DIRECT    | Server-to-PSP, no user interaction |
| REDIRECT  | User redirected to PSP/bank        |
| SDK       | Handled via PSP SDK                |
| OFFLINE   | Delayed/manual completion          |

---

### 4.3 By Processing Type

| Type  | Description              |
| ----- | ------------------------ |
| SYNC  | Immediate response       |
| ASYNC | Final result via webhook |

---

## 5. Execution Model

### 5.1 Flow Types

#### DIRECT

- used for tokenized cards
- lowest latency
- no UI interaction

---

#### REDIRECT

- used for APMs and bank flows
- requires return handling
- introduces drop-off risk

---

#### SDK

- mobile/web SDK
- supports wallets and 3DS
- better UX control

---

#### OFFLINE

- bank transfers, invoices
- long lifecycle
- fully async

---

## 6. Capability Model (Core Design)

System uses **capability-based approach instead of hardcoded logic**.

### 6.1 Capability Flags

| Capability               | Description             |
| ------------------------ | ----------------------- |
| supports_3ds             | Requires authentication |
| supports_capture         | Supports capture step   |
| supports_partial_capture | Allows partial capture  |
| supports_refund          | Refund supported        |
| supports_recurring       | Subscription support    |
| supports_tokenization    | Can be stored           |
| requires_redirect        | Needs user interaction  |
| is_async                 | Async processing        |

---

### 6.2 Why Capability-Based

**Benefits:**

- eliminates hardcoded logic
- enables dynamic routing
- simplifies adding new methods

---

## 7. PSP Compatibility Layer

Each PSP supports a subset of methods.

| Payment Method | PSP A | PSP B |
| -------------- | ----- | ----- |
| CARD           | ✔     | ✔     |
| IDEAL          | ✔     | ✖     |
| KLARNA         | ✔     | ✔     |

### Rules:

- routing must validate compatibility
- unsupported combinations must be filtered early

---

## 8. Routing Impact

Payment Method affects:

- PSP selection
- fallback availability
- routing scoring

**Example:**

- PSP_A better for cards
- PSP_B better for APMs

---

## 9. Retry Behavior

| Method Type   | Retry Strategy                 |
| ------------- | ------------------------------ |
| CARD          | Smart retry (issuer-dependent) |
| WALLET        | Limited retry                  |
| BANK_TRANSFER | No retry                       |
| APM           | Case-specific                  |

### Rules:

- retry must respect method constraints
- some methods cannot be retried safely

---

## 10. Failover Constraints

- not all PSPs support all methods
- failover must respect compatibility
- fallback chain must be filtered by method

---

## 11. Status Model Impact

Payment Method affects:

- need for `REQUIRES_ACTION` (3DS)
- async flows (`PROCESSING`, delayed confirmation)
- timeout expectations

---

## 12. Tokenization Model

System must support:

### 12.1 Token Types

| Type           | Description            |
| -------------- | ---------------------- |
| PSP Token      | Issued by PSP          |
| Network Token  | Issued by card network |
| Internal Token | Platform-managed       |

---

### 12.2 Benefits

- faster checkout
- higher authorization rate
- reduced PCI scope

---

## 13. Regional Optimization

System must support:

- local payment methods (iDEAL, BLIK, Pix)
- currency-method compatibility
- region-based routing rules

---

## 14. Interaction with Core Components

### 14.1 Payment

- defines how payment is executed
- determines processing behavior

---

### 14.2 Payment Attempt

- defines retry logic
- defines execution flow

---

### 14.3 Routing Decision

- filters PSPs
- affects scoring and fallback

---

### 14.4 Antifraud

- risk scoring depends on method
- different methods require different controls

---

## 15. Observability

Metrics per Payment Method:

- conversion rate
- failure rate
- retry success rate
- latency
- drop-off rate (for redirect flows)

---

## 16. Design Decisions

### Separation of Concerns

**Why:**

- enables flexibility
- avoids tight coupling
- supports scaling

---

### Capability-Based Model

**Why:**

- dynamic system behavior
- easier extensibility

---

### Abstract Method Layer

**Why:**

- decouples system from PSPs
- simplifies orchestration

---

## 17. Summary

Payment Method is a **core orchestration driver** that:

- defines execution behavior
- constrains routing and retry
- impacts user experience and conversion

A modern design must be:

- abstract
- capability-driven
- extensible
- async-first

This enables:

- higher conversion rates
- better routing decisions
- faster integration of new payment methods
- long-term scalability
