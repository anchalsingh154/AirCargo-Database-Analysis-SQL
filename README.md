# ✈️ Air Cargo Database Analysis | SQL Project

## 📌 Problem Statement
Air Cargo is an aviation company providing passenger and freight air transport.  
The company wants to prepare reports on:
- Regular passengers for offers  
- Busiest routes to optimize aircraft allocation  
- Ticket sales details for business performance  

This project focuses on creating a **relational database schema**, queries, views, stored procedures, and functions to analyze Air Cargo operations.

---

## 🎯 Project Objectives
- Identify **regular customers** for offers  
- Analyze **busiest routes** to plan aircraft requirements  
- Evaluate **ticket sales & revenue**  
- Build stored procedures & functions for reporting automation  

---

## 📂 Dataset Description
The database consists of the following tables:

- **Customer** → customer details  
- **Passengers_on_flights** → travel details  
- **Ticket_details** → ticket purchase & sales  
- **Routes** → flight routes and distances  

---

## 🛠️ Operations Implemented
1. Created **ER diagram** for airline database  
2. Created `route_details` table with constraints  
3. Queries to fetch passengers, ticket sales, routes, revenue analysis  
4. **Indexes** to improve performance  
5. Views for **business class customers**  
6. Stored Procedures for:  
   - Passengers between route ranges  
   - Routes with >2000 miles  
   - Categorizing flights (SDT, IDT, LDT)  
7. Stored Function for **complimentary services** eligibility  
8. Cursor-based query for extracting customers  

---

## 📊 Tech Stack
- **MySQL / SQL**  
- **MySQL Workbench** (for ER diagram)  

---

## 🚀 How to Run
1. Clone this repository:
   ```bash
   git clone https://github.com/anchalsingh154/AirCargo-Database-Analysis-SQL.git

📷 ER Diagram

<img width="1286" height="795" alt="image" src="https://github.com/user-attachments/assets/fe118095-9ee8-4c6e-b85b-86e75cb90f25" />
