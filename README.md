# Click&Shop - E-Commerce Database Project

This project is a PL/SQL-based e-commerce database simulation, created for the Database II course. The objective is to implement a structured database management system to handle an online store's data using stored procedures, functions, triggers, and views.

## Project Overview

**Click&Shop** provides a simulated e-commerce environment, focusing on key database functionalities:

- **Stored Procedures and Functions:** Manage and automate data processes for users, products, orders, and payments.
- **Triggers:** Audit data changes in key tables such as `Product` and `Order`.
- **Views:** Simplify complex queries for product listings, user reviews, order details, and payment history.
- **Data Constraints and Validation:** Ensure data integrity and business rules through constraints and validations.

## Database Structure

The database includes the following main entities:

- **User (UsuarioComprador):** Stores user information with authentication details and address.
- **Vendor (Vendedor):** Manages vendor profiles, including sales data.
- **Product (Producto):** Includes details of products like category, inventory, and price.
- **Order (Orden) & Cart (Carrito):** Manages the user’s shopping cart, order processing, and item tracking.
- **Review (Resenhas):** Allows users to leave ratings and comments on products.
- **Payment (Pago):** Handles user payments and payment status.
- **Audit (Auditoria):** Logs actions on tables for auditing purposes.

## Key Features

1. **Product Management:** Procedures to add and update products, with inventory control.
2. **Cart Operations:** Add or remove items, calculate totals, and validate inventory.
3. **Order Processing:** Generate orders from the cart, with status tracking.
4. **Payment Processing:** Verify payments and update order statuses.
5. **Data Integrity:** Triggers to audit data changes and ensure inventory is properly managed.
6. **User Reviews:** Collects and displays user reviews and ratings.
7. **Admin Views:** Simplified queries for product listings, user reviews, and order history.

## Setup

1. Create the database schema by running the provided SQL scripts.
2. Set up sequences, tables, constraints, and insert initial data.
3. Execute procedures and functions to manage the database as needed.

## Example Queries

- **Product List:** `SELECT * FROM VistaProducto;`
- **User Reviews:** `SELECT * FROM VistaResenhasUsuario;`
- **Customer Orders:** `SELECT * FROM VistaOrdenesCliente;`
- **Customer Payments:** `SELECT * FROM VistaPagosCliente;`
