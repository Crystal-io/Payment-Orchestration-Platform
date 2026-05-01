# Out of Scope (MVP)

## 1. Overview

This document explicitly defines the features and capabilities that are NOT included in the MVP version of the Payment Orchestration Platform.

Clearly defining out-of-scope items helps:

- prevent scope creep
- align expectations between stakeholders
- focus development efforts on core functionality

---

## 2. Payments

The following payment-related features are excluded:

- Refund processing (full and partial)
- Partial captures
- Multiple capture flows
- Payouts (merchant withdrawals)

---

## 3. Routing

Advanced routing capabilities are not included:

- Multi-PSP dynamic routing
- Load balancing between PSPs
- Cost-based routing
- Performance-based routing (success rate optimization)
- Automatic failover between PSPs

---

## 4. Antifraud

Only basic rule-based antifraud is included in MVP.

Excluded:

- Machine learning models
- Risk scoring engines
- External fraud provider integrations
- Behavioral analysis
- Device fingerprinting

---

## 5. Financial Processing

The MVP does not include financial reconciliation features:

- Settlement tracking
- Reconciliation between PSP and internal records
- Chargeback handling
- Financial reporting

---

## 6. Product Features

User-facing and operational features are excluded:

- Merchant dashboard / UI
- Reporting and analytics
- Admin panel
- Manual payment management tools

---

## 7. Payment Methods

The MVP is limited to basic card payments.

Excluded:

- Alternative payment methods (APMs)
- Digital wallets (Apple Pay, Google Pay)
- Bank transfers
- Cryptocurrency payments

---

## 8. Internationalization

The MVP does not include advanced international features:

- Multi-currency conversion logic
- Localization (languages, formats)
- Regional payment rules

---

## 9. Infrastructure & Scaling

Advanced infrastructure features are out of scope:

- Multi-region deployment
- Active-active failover architecture
- Advanced caching strategies
- Event streaming platforms (Kafka, etc.)

---

## 10. Notes

- Items listed here may be included in future releases (R2+)
- Any new feature request should be evaluated against this list before inclusion
- This document helps enforce MVP boundaries

---
