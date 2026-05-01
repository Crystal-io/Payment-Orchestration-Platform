# Stakeholders

## 1. Overview

This document identifies all key stakeholders involved in the Payment Orchestration Platform and defines their roles and responsibilities.

---

## 2. Stakeholder Groups

### 2.1 External Stakeholders

#### Merchant

- Integrates with the platform via API
- Initiates payments
- Receives payment status updates via webhooks

#### Payment Service Provider (PSP)

- Processes payment transactions
- Handles authorization and settlement
- Sends asynchronous notifications (webhooks)

---

### 2.2 Internal Stakeholders

#### Product Owner

- Defines product vision and roadmap
- Prioritizes features and requirements
- Ensures business value delivery

#### Engineering Team

- Designs and implements the system
- Maintains system stability and performance
- Integrates with external systems (PSPs)

#### Risk / Fraud Team

- Defines antifraud rules and policies
- Monitors suspicious transactions
- Adjusts risk decision logic

#### Support / Operations Team

- Monitors system behavior
- Handles incidents and failures
- Supports merchants in case of issues

---

## 3. Responsibilities Matrix

| Stakeholder      | Responsibility                               |
| ---------------- | -------------------------------------------- |
| Merchant         | Initiates payments, handles user interaction |
| PSP              | Executes payment processing                  |
| Payment Gateway  | Orchestrates payment lifecycle               |
| Product Owner    | Defines product direction                    |
| Engineering Team | Builds and maintains system                  |
| Risk Team        | Defines antifraud logic                      |
| Operations Team  | Monitors and supports system                 |

---

## 4. Communication Flows

- Merchant ↔ Payment Gateway (API + Webhooks)
- Payment Gateway ↔ PSP (API + Webhooks)
- Internal Teams ↔ System (Monitoring, Logs, Alerts)

---

## 5. Notes

- The Payment Gateway acts as a central orchestrator between all stakeholders
- External systems (PSPs) are treated as unreliable and must be handled accordingly
- Internal roles are designed to ensure scalability and maintainability of the system

---
