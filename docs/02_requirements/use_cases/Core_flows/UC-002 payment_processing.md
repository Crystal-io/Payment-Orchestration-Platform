# UC-002: Payment Processing

````mermaid
sequenceDiagram
    autonumber
    actor Merchant
    participant API as Payment API
    participant PS as Payment Service
    participant RS as Routing Service
    participant AS as Attempt Service
    participant PA as PSP Adapter
    participant PSP as PSP
    participant TS as Transaction Service
    participant EB as Event Bus

    Merchant->>API: POST /payments/{id}/process<br/>Idempotency-Key
    API->>PS: processPayment(payment_id)

    PS->>PS: Validate payment state<br/>Check idempotency<br/>Acquire payment lock
    PS->>RS: Select PSP route
    RS-->>PS: RoutingDecision

    PS->>AS: Create PaymentAttempt
    AS-->>PS: PaymentAttempt CREATED

    PS->>PA: Execute attempt
    PA->>PSP: Authorize / Charge

    alt PSP returns success
        PSP-->>PA: Approved
        PA-->>PS: Normalized success
        PS->>TS: Create SUCCESS Transaction
        PS->>AS: Mark Attempt SUCCEEDED
        PS->>PS: Mark Payment SUCCEEDED
        PS->>EB: Publish payment.succeeded
        PS-->>API: SUCCEEDED
    else PSP returns pending / action required
        PSP-->>PA: Pending / Requires action
        PA-->>PS: Normalized pending
        PS->>TS: Create PENDING Transaction
        PS->>AS: Mark Attempt PENDING / REQUIRES_ACTION
        PS->>PS: Mark Payment PROCESSING / REQUIRES_ACTION
        PS->>EB: Publish payment.pending / requires_action
        PS-->>API: PROCESSING / REQUIRES_ACTION
    else PSP returns decline
        PSP-->>PA: Declined
        PA-->>PS: Normalized decline
        PS->>TS: Create FAILED Transaction
        PS->>AS: Mark Attempt FAILED
        PS->>PS: Mark Payment FAILED
        PS->>EB: Publish payment.failed
        PS-->>API: FAILED
    end

    API-->>Merchant: Payment processing response
    ```

## 1. Overview

Payment Processing is the core orchestration use case responsible for executing an existing `Payment` through a selected PSP.

This use case starts after a `Payment` has been created and is eligible for execution.

It covers:

- Payment Attempt creation
- Routing Decision execution
- PSP capability validation
- PSP authorization / charge request
- synchronous and asynchronous PSP responses
- Payment, Payment Attempt, Transaction state transitions
- event publication through Outbox
- tracing and correlation across internal services and external PSP calls

This use case does not create a new Payment. Payment creation is covered by `UC-001: create_payment`.

---

## 2. Goal

Execute a payment intent by creating a Payment Attempt, selecting the appropriate PSP route, submitting the payment request to PSP, and updating the platform state based on the PSP execution result.

The platform must guarantee that:

- one processing command does not create duplicate financial execution;
- each PSP execution attempt is represented by exactly one Payment Attempt;
- all external PSP results are persisted as append-only Transactions;
- Payment status is derived from Payment Attempt and Transaction outcomes;
- async PSP results can safely update the payment later.

---

## 3. Actors

| Actor | Type | Responsibility |
|---|---|---|
| Merchant System | External | Initiates payment processing or confirms manual payment |
| Payment API | Internal | Accepts processing request |
| Payment Service | Internal | Owns Payment lifecycle and orchestration command |
| Attempt Service | Internal | Creates and manages Payment Attempts |
| Routing Service | Internal | Selects PSP route based on merchant config, rules, capabilities |
| PSP Adapter | Internal | Normalizes PSP-specific API interaction |
| PSP | External | Executes payment authorization / charge |
| Transaction Service | Internal | Stores PSP-originated financial events |
| Event Bus | Internal | Distributes domain events |
| Outbox Publisher | Internal | Publishes events after DB commit |

---

## 4. Preconditions

Payment Processing can start only if:

1. `Payment` exists.
2. `Payment.status` is one of:
   - `CREATED`
   - `PROCESSING_ELIGIBLE`
   - `REQUIRES_CONFIRMATION`
3. `Payment.amount`, `currency`, `merchant_id`, `payment_method`, and `processing_mode` are immutable.
4. Merchant account is active.
5. Payment method is enabled for merchant.
6. Payment method capability supports requested operation:
   - `AUTHORIZE`
   - `SALE`
   - `TOKENIZED_PAYMENT`
   - `3DS_REQUIRED`, if applicable
7. No active non-terminal Payment Attempt exists for the same Payment.
8. Payment is not in terminal state:
   - `SUCCEEDED`
   - `FAILED`
   - `CANCELLED`
   - `EXPIRED`

---

## 5. Trigger

Payment Processing can be triggered by:

| Trigger | Description |
|---|---|
| `AUTO_PROCESS` | Processing starts automatically after Payment creation |
| `MANUAL_CONFIRM` | Merchant explicitly calls confirm/process endpoint |
| Internal retry | Platform retries eligible attempt according to retry policy |
| Failover flow | Platform starts a new attempt after PSP/provider failure |
| Async continuation | PSP webhook updates previously pending attempt |

Primary API trigger:

```http
POST /payments/{payment_id}/process
````
