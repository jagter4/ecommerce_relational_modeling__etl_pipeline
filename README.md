# E-Commerce Relational Modeling & ETL Pipeline

## 📌 Project Overview
This project demonstrates **relational database design workflow** based on business requirements for an e-commerce system.

The scope of the project includes:
- Analyzing business requirements
- Designing a normalized relational database schema
- Loading operational data from CSV and Excel files
- Validating data integrity using SQL

---

##  Business Requirements Analysis
The first step was analyzing the [business requirements](docs/business_requirements.md) to identify:
- Core business entities
- Attributes and data types
- Relationships and cardinality
- Business rules and constraints

---

## 🗄️ Relational Data Model
Based on the requirements, a normalized relational data model was designed to accurately represent the business domain.

Design principles applied:
- normalization to reduce redundancy
- primary and foreign key relationships
- Enforcement of business rules at the database level
- Referential integrity between related entities

📊 **Logical Schema Diagram:**  

![Logical Schema Diagram](docs/logical%20schema.png)

---


## 🔄 Data Loading (ETL Process)
A data loading pipeline was implemented to populate the relational database tables with operational data.

### Data Sources
- CSV files
- Excel files

### Process Overview
1. **Extract** data from CSV and Excel files
2. **Transform** data by:
   - Cleaning missing or invalid values
   - Standardizing formats and data types
   - Aligning data with relational constraints
3. **Load** data into database tables while preserving referential integrity

--- 
📄 **ETL Implementation:**  

[src/ETL.py](src/ETL.py)


---

##  Data Validation & Integrity Checks
After loading the data, SQL-based validation checks were executed to ensure data correctness and integrity.

Validation examples include:
- Primary key uniqueness checks
- Foreign key consistency checks
- Null checks on mandatory columns
- Row count and consistency verification

These checks help ensure that the database accurately reflects the business rules.

📄 **Validation Queries:**  

[sql/data_validation.sql](sql/data_validation.sql)



## 📂 Repository Structure
```text
.
├── .env
├── .gitignore
├── requirements.txt
│
├── datasets/
│   ├── orders_data.csv
│   ├── payments_data.xlsx
│   ├── products_data.csv
│   ├── reviews_data.xlsx
│   └── users_data.csv
│
├── docs/
│   ├── business_requirements.md
│   └── logical schema.png
│
├── sql/
│   ├── data_validation.sql
│   └── ddl_schema.sql
│
└── src/
    ├── ETL.py 
    └── utils.py
