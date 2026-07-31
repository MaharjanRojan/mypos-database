# MyPOS Database System 🛒📊

A robust, relational Point of Sale (POS) database schema built for MySQL. Designed with automated inventory triggers, transactional stored procedures, and strict data integrity constraints tailored for retail and liquor store management.

## 🚀 Features
- **Relational Integrity:** Fully normalized schema supporting Products, Inventory, Vendors, Taxes, Sales, Payments, and Employees.
- **Automated Inventory Control:** Triggers (`AFTER INSERT`, `AFTER UPDATE`, `AFTER DELETE`) that automatically manage stock levels when items are sold or refunded.
- **Transactional Stored Procedures:** Built-in procedures (`create_sale`, `add_sale_item`, `finalize_sale`) for safely handling cart calculations, taxes, deposits, and cash change calculations.
- **Audit Ready:** Timestamps and tracking for employee actions, customer history, and financial logs.

---

## 📂 Project Structure
```text
mypos-database/
├── schema/
│   ├── 01_schema.sql         # Table definitions and foreign keys
│   ├── 02_triggers.sql       # Automated inventory triggers
│   └── 03_procedures.sql     # Business logic stored procedures
├── sample_data/
│   └── 04_seed_data.sql      # Initial test data
├── tests/
│   └── 05_test_queries.sql   # Workflow test cases & verification
└── README.md