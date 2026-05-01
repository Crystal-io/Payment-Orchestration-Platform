# PGateway — проект по проектированию payment orchestration gateway

## 1. Стартовая формулировка проекта

**PGateway** — это проект минимального **payment orchestration / gateway core** без UI, сфокусированный на **платежной логике, интеграционном дизайне и аналитических артефактах**.

---

## 2. Границы проекта

### Что входит в scope
- единый API для создания и обработки платежей;
- hosted / redirect payment session как абстрактный сценарий;
- server-to-server сценарий создания платежа;
- маршрутизация платежа в один из PSP;
- status normalization;
- 3DS как часть платежного сценария;
- webhook processing;
- refund / void;
- tokenized recurring payments;
- базовый antifraud rules engine;
- reconciliation на уровне internal record vs PSP result;
- журнал событий и audit trail;
- архитектурная и аналитическая документация.

### Что сознательно НЕ входит в scope
- UI / merchant dashboard;
- merchant onboarding;
- KYC / KYB;
- хранение PAN и полноценная PCI-sensitive card data processing;
- реальная интеграция со схемами Visa / Mastercard;
- chargeback management;
- payout / withdrawal flows;
- settlement ledger уровня банка;
- бухгалтерия и финансовая отчётность enterprise-уровня;
- dispute portal;
- role model для большого back-office.

---

## 3. Продуктовая идея в одной фразе

**PGateway** — это минимальный orchestration-слой, который принимает единый запрос на платёж, применяет платежные и antifraud-правила, выбирает PSP, обрабатывает ответы и webhooks, нормализует статусы и сохраняет целостную историю транзакции.

---

## 5. Минимальный product scope


### MVP-функции
1. Создание платежа.
2. Создание payment session.
3. Выбор маршрута в PSP.
4. Обработка synchronous PSP response.
5. Обработка asynchronous webhook.
6. Нормализация статусов во внутреннюю модель.
7. Поддержка 3DS-перехода как части сценария.
8. Refund.
9. Void / cancel authorized payment.
10. Token-based recurring payment.
11. Antifraud pre-check.
12. Идемпотентность запросов.
13. Retry / fallback на альтернативный PSP.
14. Reconciliation.
15. Audit trail.

### Предлагаемый набор поддерживаемых сценариев
- Card payment with redirect / hosted step;
- Card payment with 3DS required;
- Card payment without 3DS;
- Authorized then captured flow;
- Immediate capture flow;
- Refund full / partial;
- Void before capture;
- Recurring MIT-like payment by token;
- PSP failover scenario;
- Duplicate request scenario.

---

## 6. Роли в системе

Так как UI нет, роли нужны в первую очередь для требований и use cases.

### Внешние роли
- **Merchant System** — внешняя система мерчанта, которая вызывает API.
- **Customer** — инициирует оплату и проходит customer action step.
- **PSP** — внешний платёжный провайдер.
- **Issuer / ACS** — участвует в 3DS-сценарии как внешняя абстракция.

### Внутренние логические роли
- **Risk Engine** — проверяет правила antifraud.
- **Routing Engine** — выбирает PSP.
- **Webhook Processor** — принимает внешние статусы.
- **Reconciliation Service** — сверяет internal state с PSP data.
- **Audit / Event Store** — хранит историю изменений.

---

## 7. Структура проекта для GitHub

Ниже — рекомендуемое дерево репозитория.

```text
PGateway/
│
├── README.md
├── docs/
│   ├── 01_Product/
│   │   ├── 01_Project_Vision.md
│   │   ├── 02_Goals_and_NonGoals.md
│   │   ├── 03_Scope.md
│   │   ├── 04_Glossary.md
│   │   └── 05_JTBD.md
│   │
│   ├── 02_Business_Analysis/
│   │   ├── 01_BRD.md
│   │   ├── 02_Stakeholders.md
│   │   ├── 03_Business_Rules.md
│   │   ├── 04_Use_Case_Model.md
│   │   ├── 05_User_Stories.md
│   │   └── 06_Acceptance_Criteria.md
│   │
│   ├── 03_Solution_Design/
│   │   ├── 01_SRS.md
│   │   ├── 02_API_Overview.md
│   │   ├── 03_Error_Handling_Model.md
│   │   ├── 04_Status_Normalization.md
│   │   ├── 05_Idempotency_and_Retries.md
│   │   ├── 06_Antifraud_Rules.md
│   │   ├── 07_Reconciliation_Logic.md
│   │   └── 08_NFR.md
│   │
│   ├── 04_Architecture/
│   │   ├── 01_Architecture_Decision_Record.md
│   │   ├── 02_C4_Context.md
│   │   ├── 03_C4_Container.md
│   │   ├── 04_C4_Component.md
│   │   ├── 05_Data_Model_ERD.md
│   │   ├── 06_Integration_Contracts.md
│   │   └── 07_Security_Model.md
│   │
│   ├── 05_Processes/
│   │   ├── 01_BPMN_Payment_Initiation.md
│   │   ├── 02_BPMN_3DS_Flow.md
│   │   ├── 03_BPMN_Refund_Flow.md
│   │   ├── 04_BPMN_Recurring_Flow.md
│   │   └── 05_BPMN_Reconciliation_Flow.md
│   │
│   ├── 06_UML/
│   │   ├── 01_Sequence_Create_Payment.md
│   │   ├── 02_Sequence_3DS.md
│   │   ├── 03_Sequence_Refund.md
│   │   ├── 04_Sequence_Webhook_Handling.md
│   │   └── 05_State_Payment_Lifecycle.md
│   │
│   ├── 07_Backlog/
│   │   ├── 01_Epics.md
│   │   ├── 02_Release_Plan.md
│   │   ├── 03_MVP_Backlog.md
│   │   └── 04_Risks_and_Assumptions.md
│   │
│   └── 08_Appendix/
│       ├── 01_Statuses_Dictionary.md
│       ├── 02_Error_Codes.md
│       ├── 03_Test_Scenarios.md
│       └── 04_Open_Questions.md
│
├── diagrams/
│   ├── bpmn/
│   ├── uml/
│   ├── c4/
│   └── erd/
│
└── assets/
    └── images/
```

---

## 8. Минимальный набор артефактов

### Обязательно сделать
- README
- Vision / Scope
- JTBD
- BRD
- Use cases
- User stories + acceptance criteria
- SRS
- BPMN по основным сценариям
- UML sequence diagrams
- UML state diagram для payment lifecycle
- C4 Context + Container
- ERD
- Error model
- Status normalization table
- Idempotency / retries logic
- Antifraud rules catalog
- Reconciliation logic
- NFR
- ADR по архитектурному решению

### Можно отложить на вторую волну
- C4 Component
- более подробный API catalog
- test scenarios catalog
- operational runbook
- chargeback future design

---

## 9. Рекомендуемая стартовая архитектурная идея

архитектуру лучше держать достаточно реалистичной, но не перегруженной.

### Высокоуровневые модули
1. **API Layer**
2. **Payment Orchestration Service**
3. **Routing Engine**
4. **Risk Engine**
5. **PSP Adapter Layer**
6. **Webhook Processor**
7. **Token Service**
8. **Reconciliation Service**
9. **Event / Audit Store**
10. **Relational Database**
11. **Message Broker / Async Event Bus**

### Логика разделения
- API принимает единый контракт от merchant system.
- Orchestration Service владеет внутренним payment lifecycle.
- Routing Engine определяет, куда отправить транзакцию.
- Risk Engine принимает решение: allow / review / reject / force_3ds.
- PSP Adapter Layer скрывает специфику внешних PSP.
- Webhook Processor приводит асинхронные статусы к внутренней модели.
- Reconciliation Service сверяет конечные статусы и суммы.
- Event Store хранит полную историю изменений.

---

## 10. Базовые доменные сущности

### Основные сущности
- Merchant
- Payment
- Payment Attempt
- Payment Session
- Payment Method Token
- PSP Route
- Webhook Event
- Refund
- Risk Check
- Reconciliation Record
- Audit Event

### Минимум сущностей для ERD

#### Payment
- payment_id
- merchant_order_id
- amount
- currency
- customer_id
- payment_method_type
- status
- status_reason
- requires_3ds
- selected_psp
- created_at
- updated_at

#### Payment Attempt
- attempt_id
- payment_id
- route_id
- psp_name
- psp_payment_id
- attempt_status
- is_final
- request_payload_hash
- created_at

#### Refund
- refund_id
- payment_id
- amount
- currency
- status
- psp_refund_id
- created_at

#### Risk Check
- risk_check_id
- payment_id
- decision
- rule_triggered
- score
- created_at

#### Webhook Event
- webhook_event_id
- psp_name
- external_event_id
- payment_id
- raw_status
- normalized_status
- processed_flag
- received_at

#### Reconciliation Record
- reconciliation_id
- payment_id
- psp_name
- internal_amount
- psp_amount
- internal_status
- psp_status
- mismatch_flag
- checked_at

---

## 11. Базовые статусы платежа

### Внутренняя canonical status model
- CREATED
- PENDING_CUSTOMER_ACTION
- PENDING_PROCESSING
- AUTHORIZED
- CAPTURED
- PARTIALLY_CAPTURED
- DECLINED
- CANCELLED
- EXPIRED
- REFUNDED
- PARTIALLY_REFUNDED
- FAILED_TECHNICAL

### Почему нужна canonical status model
Потому что каждый PSP возвращает собственные статусы. Внутри системы должен быть единый словарь, чтобы:
- упрощать интеграции;
- не завязывать мерчанта на конкретный PSP;
- строить единые правила обработки;
- упрощать reconciliation и reporting.

---

## 12. Ключевые бизнес-правила

1. Каждый `create payment` должен поддерживать идемпотентность.
2. Один payment может иметь несколько attempts.
3. Финальный статус платежа определяется по внутренним правилам нормализации.
4. Webhook не должен ломать уже достигнутый финальный статус без явного допустимого перехода.
5. Refund не может превышать доступный capture amount.
6. Void допустим только до capture.
7. Retry допустим только для retryable failure.
8. Risk Engine может принудительно включать 3DS.
9. При деградации PSP Routing Engine должен уметь выбрать fallback.
10. Все внешние и внутренние изменения состояния должны логироваться как audit events.

---

## 13. Набор основных use cases

### UC-01 Создать платёж
Merchant System создаёт новый платёж через единый API.

### UC-02 Получить payment session
Система возвращает session / redirect step для customer action.

### UC-03 Выполнить маршрутизацию
Система выбирает подходящий PSP по правилам маршрутизации.

### UC-04 Обработать 3DS-сценарий
Система переводит платёж в customer action flow и ожидает результат.

### UC-05 Обработать synchronous authorization response
Система принимает ответ PSP и обновляет внутренний статус.

### UC-06 Обработать webhook
Система принимает asynchronous event и нормализует состояние платежа.

### UC-07 Выполнить refund
Merchant System создаёт запрос на возврат средств.

### UC-08 Выполнить recurring payment by token
Система инициирует повторный платёж по токену.

### UC-09 Выполнить reconciliation
Система сверяет internal record с данными PSP.

### UC-10 Обработать дублирующий запрос
Система возвращает идемпотентный результат без повторного создания сущности.

---

## 14. Набор стартовых epics

### Epic 1. Payment Initiation
Функции создания платежа, валидации запроса и создания payment record.

### Epic 2. Payment Routing
Функции выбора PSP и fallback logic.

### Epic 3. 3DS and Customer Action
Функции customer action flow и обработки результата 3DS.

### Epic 4. Payment Status Lifecycle
Функции state management, normalization и allowed transitions.

### Epic 5. Refund and Void
Функции возврата и отмены авторизации.

### Epic 6. Token and Recurring
Функции token-based повторных платежей.

### Epic 7. Antifraud Rules
Функции risk checks и forced decision logic.

### Epic 8. Webhooks
Функции приёма, дедупликации и обработки webhook-событий.

### Epic 9. Reconciliation
Функции сверки internal и PSP данных.

### Epic 10. Audit and Observability
Функции correlation IDs, event history и audit trail.

---

## 15. Шаги выполнения проекта

Ниже — рекомендуемая последовательность, чтобы проект развивался логично.

### Этап 1. Product framing
**Цель:** зафиксировать, что именно мы строим и зачем.

#### Сделать
- README
- Vision
- Goals / Non-goals
- Scope
- Glossary
- JTBD

#### Результат этапа
Появляется понятное описание продукта, его границ и бизнес-смысла.

---

### Этап 2. Business analysis
**Цель:** описать требования на уровне бизнеса и сценариев использования.

#### Сделать
- BRD
- Stakeholders
- Business rules
- Use case model
- User stories
- Acceptance criteria

#### Результат этапа
Появляется чёткое понимание, какие задачи система должна решать и какие сценарии обязана поддерживать.

---

### Этап 3. Process modeling
**Цель:** разложить платежные сценарии по шагам и ролям.

#### Сделать BPMN для:
- payment initiation;
- 3DS flow;
- refund flow;
- recurring payment flow;
- reconciliation flow.

#### Результат этапа
Появляется наглядная модель процессов, по которой легче проверять пропуски и edge cases.

---

### Этап 4. System analysis
**Цель:** зафиксировать внутреннюю логику системы.

#### Сделать
- SRS
- API overview
- Error handling model
- Status normalization
- Idempotency and retries
- Antifraud rules
- Reconciliation logic
- NFR

#### Результат этапа
Появляется системная спецификация, достаточная для начала реализации backend-сервиса.

---

### Этап 5. Architecture design
**Цель:** описать архитектуру и декомпозицию системы.

#### Сделать
- ADR
- C4 Context
- C4 Container
- при желании C4 Component
- ERD
- Security model
- Integration contracts

#### Результат этапа
Появляется чёткая картина того, из каких частей состоит система и как они взаимодействуют.

---

### Этап 6. UML modeling
**Цель:** показать динамику взаимодействий и lifecycle.

#### Сделать
- Sequence: create payment
- Sequence: 3DS
- Sequence: refund
- Sequence: webhook handling
- State diagram: payment lifecycle

#### Результат этапа
Появляются модели, удобные для обсуждения с разработчиками.

---

### Этап 7. Backlog and release planning
**Цель:** перевести документацию в план поставки.

#### Сделать
- epics
- MVP backlog
- release plan
- risks and assumptions
- open questions

#### Результат этапа
Появляется roadmap, с которым уже можно идти в delivery.

---

## 16. Практический порядок написания документов

Если делать всё одному, лучше идти не по названию артефактов, а по зависимости между ними.

### Правильный порядок
1. README
2. Project Vision
3. Goals / Non-goals
4. Scope
5. Glossary
6. JTBD
7. BRD
8. Business Rules
9. Use Case Model
10. User Stories
11. Acceptance Criteria
12. BPMN
13. SRS
14. Error Handling Model
15. Status Normalization
16. Idempotency and Retries
17. Antifraud Rules
18. Reconciliation Logic
19. NFR
20. ADR
21. C4 diagrams
22. ERD
23. UML diagrams
24. MVP Backlog
25. Release Plan

---

## 17. Что писать в README

README должен быстро объяснять посетителю репозитория:
- что это за проект;
- почему он создан;
- какой scope выбран;
- какие артефакты внутри;
- какие ключевые сценарии описаны;
- где искать архитектуру, требования и диаграммы.

### Рекомендуемая структура README
- Название проекта
- Краткое описание
- Цель проекта
- Scope / Non-scope
- Основные сценарии
- Структура репозитория
- Список артефактов
- Возможные будущие улучшения

---

## 18. На что особенно обратить внимание

### 1. Не расползаться в лишний scope
Для учебного проекта минимализм — плюс, а не минус.

### 2. Делать единый внутренний словарь
Statuses, decline reasons, event types и error codes должны быть унифицированы.

### 3. Всегда учитывать async-реальность платежей
Платёж не заканчивается synchronous response. Нужны webhook и delayed finalization.

### 4. Продумать state transitions
Не каждый статус может перейти в любой другой. Нужна явная state machine.

### 5. Не забыть про идемпотентность
Для payments и refunds это обязательный элемент.

### 6. Не забыть про технические сбои
Нужно отдельно описывать business decline и technical failure.

### 7. Фиксировать assumptions
Все спорные или учебные допущения лучше держать отдельно в документе assumptions.

---

## 19. Предлагаемый стартовый набор PSP для модели

Так как проект учебный, лучше использовать абстрактные провайдеры:
- **PSP_A** — основной провайдер;
- **PSP_B** — резервный провайдер;
- **Mock_ACS** — симуляция 3DS / customer action step.

Это позволит:
- не зависеть от конкретной документации провайдера;
- строить собственную canonical model;
- концентрироваться на логике orchestration, а не на изучении чужих API.

---

## 20. Какой результат считать успешным

Проект можно считать успешно спроектированным, если по репозиторию можно понять:
- какую проблему решает система;
- какие сценарии поддерживаются;
- какие у системы границы;
- как выглядит payment lifecycle;
- как устроены routing, 3DS, refunds, retries и reconciliation;
- какие сущности лежат в основе data model;
- как система взаимодействует с внешними PSP;
- с чего разработчик может начать реализацию.

---

## 21. Финальная рекомендация

Для учебного проекта лучше строить не «ещё один PSP», а **минимальный payment orchestration gateway core**.

Это даст:
- реалистичный, но контролируемый scope;
- сильный аналитический и архитектурный кейс;
- понятный набор артефактов для GitHub;
- хорошую основу для интервью и портфолио.

Главная идея проекта:

> Спроектировать систему, которая принимает единый платёжный запрос, применяет внутренние правила, выбирает PSP, управляет жизненным циклом платежа и сохраняет консистентную внутреннюю модель транзакции.

