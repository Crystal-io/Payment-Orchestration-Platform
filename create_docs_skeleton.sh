#!/bin/bash

# Payment-Orchestration-Platform documentation skeleton

mkdir -p docs/00_project
mkdir -p docs/01_discovery
mkdir -p docs/02_requirements
mkdir -p docs/03_core_domain

mkdir -p docs/04_modules/antifraud
mkdir -p docs/04_modules/routing
mkdir -p docs/04_modules/webhooks
mkdir -p docs/04_modules/reconciliation
mkdir -p docs/04_modules/refunds

mkdir -p docs/05_architecture
mkdir -p docs/06_processes_and_models/bpmn
mkdir -p docs/06_processes_and_models/uml
mkdir -p docs/06_processes_and_models/erd

mkdir -p docs/07_contracts/api
mkdir -p docs/07_contracts/events
mkdir -p docs/07_contracts/webhooks

mkdir -p docs/08_integrations
mkdir -p docs/09_data
mkdir -p docs/10_quality
mkdir -p docs/11_operations

mkdir -p diagrams/c4
mkdir -p diagrams/bpmn
mkdir -p diagrams/uml
mkdir -p diagrams/erd

mkdir -p references

touch README.md
touch CHANGELOG.md

touch docs/00_project/vision.md
touch docs/00_project/roadmap.md
touch docs/00_project/stakeholders.md
touch docs/00_project/glossary.md
touch docs/00_project/assumptions.md

touch docs/01_discovery/problem_statement.md
touch docs/01_discovery/business_goals.md
touch docs/01_discovery/scope.md
touch docs/01_discovery/out_of_scope.md
touch docs/01_discovery/risks_and_constraints.md

touch docs/02_requirements/brd.md
touch docs/02_requirements/srs.md
touch docs/02_requirements/fr_catalog.md
touch docs/02_requirements/nfr.md
touch docs/02_requirements/acceptance_criteria.md

touch docs/03_core_domain/payment.md
touch docs/03_core_domain/payment_attempt.md
touch docs/03_core_domain/transaction.md
touch docs/03_core_domain/merchant.md
touch docs/03_core_domain/payment_method.md
touch docs/03_core_domain/status_model.md
touch docs/03_core_domain/business_rules.md

touch docs/04_modules/antifraud/overview.md
touch docs/04_modules/antifraud/risk_rules.md
touch docs/04_modules/antifraud/risk_scoring.md
touch docs/04_modules/antifraud/antifraud_decisions.md

touch docs/04_modules/routing/overview.md
touch docs/04_modules/routing/routing_rules.md
touch docs/04_modules/routing/psp_selection.md
touch docs/04_modules/routing/failover_strategy.md

touch docs/04_modules/webhooks/overview.md
touch docs/04_modules/webhooks/psp_webhooks.md
touch docs/04_modules/webhooks/merchant_webhooks.md
touch docs/04_modules/webhooks/retry_policy.md

touch docs/04_modules/reconciliation/overview.md
touch docs/04_modules/reconciliation/future_scope.md

touch docs/04_modules/refunds/overview.md
touch docs/04_modules/refunds/future_scope.md

touch docs/05_architecture/architecture_overview.md
touch docs/05_architecture/c4_context.md
touch docs/05_architecture/c4_container.md
touch docs/05_architecture/component_view.md
touch docs/05_architecture/integration_view.md
touch docs/05_architecture/extension_points.md
touch docs/05_architecture/architectural_decisions.md

touch docs/06_processes_and_models/bpmn/payment_processing.md
touch docs/06_processes_and_models/bpmn/antifraud_check.md
touch docs/06_processes_and_models/bpmn/routing_and_failover.md

touch docs/06_processes_and_models/uml/sequence_create_payment.md
touch docs/06_processes_and_models/uml/sequence_3ds_payment.md
touch docs/06_processes_and_models/uml/sequence_webhook_processing.md
touch docs/06_processes_and_models/uml/state_payment_lifecycle.md
touch docs/06_processes_and_models/uml/class_domain_model.md

touch docs/06_processes_and_models/erd/database_model.md

touch docs/07_contracts/api/payments_api.md
touch docs/07_contracts/api/refunds_api.md
touch docs/07_contracts/api/merchants_api.md
touch docs/07_contracts/api/openapi.yaml

touch docs/07_contracts/events/event_catalog.md
touch docs/07_contracts/events/payment_events.md
touch docs/07_contracts/events/antifraud_events.md
touch docs/07_contracts/events/routing_events.md

touch docs/07_contracts/webhooks/merchant_webhook_contract.md
touch docs/07_contracts/webhooks/psp_webhook_contract.md

touch docs/08_integrations/psp_adapter.md
touch docs/08_integrations/psp_status_mapping.md
touch docs/08_integrations/stripe_reference.md
touch docs/08_integrations/adyen_reference.md
touch docs/08_integrations/paytech_reference.md
touch docs/08_integrations/hyperswitch_reference.md

touch docs/09_data/data_model.md
touch docs/09_data/database_schema.md
touch docs/09_data/audit_log.md
touch docs/09_data/data_retention.md

touch docs/10_quality/test_strategy.md
touch docs/10_quality/test_scenarios.md
touch docs/10_quality/uat_plan.md
touch docs/10_quality/traceability_matrix.md

touch docs/11_operations/monitoring.md
touch docs/11_operations/logging.md
touch docs/11_operations/alerting.md
touch docs/11_operations/incident_management.md
touch docs/11_operations/runbook.md

touch references/market_research.md
touch references/payment_gateway_references.md
touch references/antifraud_references.md
touch references/routing_references.md

echo "Payment-Orchestration-Platform documentation skeleton created successfully."