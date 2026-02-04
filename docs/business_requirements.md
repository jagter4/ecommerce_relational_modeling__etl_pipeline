#  E-Commerce Database – Business Requirements Document

## 1. Business Overview

The objective of this project is to design and implement a relational database for an e-commerce platform.  
The database supports core business operations including product management, user registration, order processing, payment tracking, and customer reviews.

This document defines the business requirements that directly drive the Entity-Relationship Diagram (ERD) and the relational database schema.



## 2. Business Goals

- Maintain a structured product catalog
- Manage registered users and customer data
- Track customer orders and purchase history
- Record payments associated with orders
- Capture customer reviews and product ratings
- Enforce data integrity using relational constraints



## 3. Business Entities and Requirements

### 3.1 Products

**Business Requirement:**  
The system must store and manage products available for sale.

**Business Rules:**
- Each product must be uniquely identifiable
- Products must have pricing and inventory information
- Products may belong to a category
- The system must track when a product is added

**Required Attributes:**
- ProductID
- ProductName
- Description
- Price
- StockQuantity
- Category
- DateAdded



### 3.2 Users

**Business Requirement:**  
The system must support registered users who can place orders and submit reviews.

**Business Rules:**
- Each user must have a unique account
- Email addresses must be unique
- User credentials must be stored securely
- User registration date must be recorded

**Required Attributes:**
- UserID
- UserName
- Email
- Password
- Address
- DateRegistered



### 3.3 Orders

**Business Requirement:**  
Users must be able to place orders for products.

**Business Rules:**
- Each order must be associated with one user
- A user can place multiple orders
- Each order must record the total purchase amount
- Orders must store the order date

**Required Attributes:**
- OrderID
- UserID (Foreign Key)
- OrderDate
- TotalAmount



### 3.4 Payments

**Business Requirement:**  
Each order must have a corresponding payment record.

**Business Rules:**
- Each order has exactly one payment
- Payments must reference the associated order
- Payment method and payment date must be stored
- Payment amount must match the order total

**Required Attributes:**
- PaymentID
- OrderID (Foreign Key)
- PaymentMethod
- PaymentDate
- Amount



### 3.5 Reviews

**Business Requirement:**  
Users must be able to leave reviews for products.

**Business Rules:**
- A review must be written by a registered user
- A review must be associated with a product
- A product may have multiple reviews
- Ratings must be between 1 and 5

**Required Attributes:**
- ReviewID
- ProductID (Foreign Key)
- UserID (Foreign Key)
- Rating
- ReviewText



## 4. Entity Relationships

| Relationship | Cardinality | Description |
|--------------|------------|-------------|
| Users → Orders | 1 : M | A user can place multiple orders |
| Orders → Payments | 1 : 1 | Each order has one payment |
| Products → Reviews | 1 : M | A product can receive multiple reviews |
| Users → Reviews | 1 : M | A user can write multiple reviews |

---

## 5. Data Integrity and Constraints

- Primary Keys ensure entity uniqueness
- Foreign Keys enforce referential integrity
- Unique constraint on user email
- Rating values restricted to a valid range (1–5)
- Monetary values stored using fixed-precision decimals

---

**Future Enhancements:**
- Order-Items junction table for detailed order contents
- Inventory movement tracking
- Shipping and delivery status
- User roles and permissions

