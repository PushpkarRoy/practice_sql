# 📊 Practice SQL – Subqueries & Window Functions Mastery 🚀

Welcome to my **Practice SQL Projects** — a collection of real-world SQL challenges designed to master **subqueries** and **window functions**.  
Each project simulates real-life business problems from healthcare and sales industries — built for **data analyst and BI analyst roles** (6–10 LPA level).

---

## 🧠 What You'll Learn

| Skill Category         | Techniques Covered |
|------------------------|--------------------|
| 🔍 Subqueries          | Scalar, Correlated, `EXISTS`, `HAVING`, Nested |
| 🧮 Window Functions     | `RANK()`, `ROW_NUMBER()`, `LAG()`, `LEAD()`, `NTILE()`, `SUM() OVER` |
| 🔗 Joins & Aggregation | `JOIN`, `GROUP BY`, `HAVING`, `PARTITION BY`, `ORDER BY` |
| 📊 Business Insights   | Revenue, Visits, Follow-ups, Ranking, Growth %, Client Spend |
| 📆 Date Logic           | 60-day filters, First/Last visit, Month & Day partitions |

---

## 📁 Projects & Datasets

### 🏥 Project 1: **Hospital Subquery Analysis**
- Focus: Advanced subquery practice using a healthcare scenario 
- 📂 Tables:
  - `patients`: Basic patient info
  - `doctors`: Doctor details including specialty
  - `visits`: Visit history with billing & follow-up status
- ✅ Highlights:
  - Patients with no follow-ups
  - Doctors not visited in 60 days
  - Patients visiting all specialties
  - Highest billing clients

### 📈 Project 2: **Sales – Window Functions Mastery**
- Focus: Window function use in a corporate sales setup
- 📂 Tables:
  - `sales_reps`: Regional sales team info
  - `clients`: Industry-based clients
  - `sales`: Transactions (rep × client × date × amount)
- ✅ Highlights:
  - Rank reps/clients by sales
  - Running totals and growth %
  - Row-wise comparisons
  - Monthly and day-wise performance

---

## 📂 File Structure

| File                                   | Description                        |
|----------------------------------------|------------------------------------|
| `practice_window_SQL.sql`              | 10 advanced window function queries |
| `Sub_query_sql_practice.sql`           | 10 complex subquery challenges      |
| `sales_reps.csv`, `clients.csv`, `sales.csv` | Sales data for import                |
| `README.md`                            | You are here ✅                     |

---

## 📌 Problem Statements Solved

### ✅ Subquery Challenges
1. Patients billed more than avg
2. Doctors with high avg billing
3. Patients with all-specialty visits
4. Dormant doctors (60+ days no visit)
5. Patients with only 1 follow-up
6. Top revenue doctors
7. First visit outside patient city
8. More than 2 city visits per doctor

### ✅ Window Function Scenarios
1. Row number per rep
2. Rank top 3 reps
3. Running total per rep
4. Monthly revenue and % growth
5. Client spend ranking
6. First sale date per rep
7. Day-wise trend (last 30 days)
8. Industry sales breakdown
9. Highest single sale per rep
10. % contribution to rep’s total

---

## 👨‍💻 About Me

I'm **Pushpkar Roy**, an aspiring data analyst building real-world projects using:
- ✅ SQL (advanced level)
- 📊 Power BI
- 🧮 Python
- 📘 Excel

Currently targeting **6–10 LPA roles** and building a strong technical + project-based portfolio.

---

## 💼 Resume-Ready Highlights

- Solved 20+ real-world SQL problems across healthcare and sales domains
- Mastered subqueries, joins, `HAVING`, and filtering with logic
- Used window functions (`RANK`, `LAG`, `NTILE`, `SUM OVER`) to track trends and ranks
- Simulated realistic datasets with 1000+ records for client-ready analysis
- Created business-driven insights (growth %, top customers, dormant behavior)

---

# 📊 Practice SQL Project — Multi-Table Business Analysis

> A hands-on SQL project to practice **complex queries** across multiple business tables using realistic data. Built for data analyst & BI roles.

---

## 📌 Project Overview

This project is designed to improve SQL query skills using a realistic business scenario involving:
- Customers
- Orders
- Order Items

It covers 15 strong real-world SQL problems that go beyond basic CRUD — using **aggregations, joins, subqueries, and window functions** to derive business insights.

---

## 🧾 Dataset Structure

### `customers`
| Column        | Type      | Description               |
|---------------|-----------|---------------------------|
| customer_id   | INT       | Unique customer ID        |
| name          | VARCHAR   | Customer name             |
| city/state    | VARCHAR   | Location info             |
| signup_date   | DATE      | When they joined the platform |

### `orders`
| Column         | Type      | Description               |
|----------------|-----------|---------------------------|
| order_id       | INT       | Unique order ID           |
| customer_id    | INT       | Link to `customers`       |
| total_amount   | FLOAT     | Total bill amount         |
| payment_method | VARCHAR   | Payment type (Cash, UPI)  |
| discount_applied | VARCHAR | Whether a discount was used |
| order_status   | VARCHAR   | Delivered / Returned      |
| order_date     | DATE      | Order placed date         |

### `order_items`
| Column        | Type     | Description                 |
|---------------|----------|-----------------------------|
| order_item_id | INT      | Item in an order            |
| product_name  | VARCHAR  | Name of the product         |
| category      | VARCHAR  | Electronics, Fashion, etc.  |
| price         | FLOAT    | Unit price                  |
| quantity      | INT      | Units purchased             |
| is_returned   | VARCHAR  | Was this item returned?     |

---

## ✅ SQL Skills Covered

- 🧮 Aggregations (`SUM`, `AVG`, `COUNT`)
- 🔗 Multi-table joins
- 📊 Window functions: `RANK()`, `OVER`, `PARTITION BY`
- 📅 Date-based filtering
- 🎯 Customer behavior analysis
- 📦 Product & return pattern detection

---

## 📚 Key Questions Solved

1. Top 5 returned products with return %  
2. Customers ordering from 2+ cities  
3. Monthly customer retention rate  
4. Customers with ₹10K+ purchases & no discounts  
5. Best-performing payment method  
6. City-wise Q1 vs Q2 revenue trend with % growth  
7. Electronics buyers (non-returners) with high quantity  
8. Top return-affected product categories  
9. Consistent customers (every month in last 6)  
10. Customers who signed up recently and are active  
11. Orders with unusually high discounts  
12. Category-wise top-selling products using `RANK()`  
13. Days since last purchase per customer  
14. Risky categories with return rate > 10%  
15. Average basket size by city with ranking  

---

## 📁 Files

| File Name           | Description                      |
|---------------------|----------------------------------|
| `practice_SQL.sql`  | All queries and table creation   |
| `README.md`         | Project documentation (this file)|

---

## 💡 How to Use

1. Create the tables in PostgreSQL or MySQL
2. Insert your test data (or use dummy generators)
3. Run queries from `practice_SQL.sql`
4. Modify or extend questions based on interest

---

## 🧑‍💻 About Me

Hi, I’m **Pushpkar Roy** – a passionate data analyst practicing end-to-end SQL, Power BI, and Python projects for 6–10 LPA roles.

---

## 📌 Resume Bullet (You Can Add This)

- Built a 3-table SQL project using realistic e-commerce-style data  
- Practiced advanced SQL techniques including `JOIN`, `GROUP BY`, `RANK()`, and business KPI tracking  
- Solved 15+ analytics-driven queries to understand customer, product, and order-level insights

---

## 🌟 Like this? Check out more SQL + BI projects on my GitHub!


## 🏷️ Tags  
`#SQLProject` `#Subqueries` `#WindowFunctions` `#DataAnalytics` `#HospitalSQL` `#SalesSQL` `#PushpkarRoyPortfolio`

---

> 💡 Tip: Clone this project and run it in your SQL environment for hands-on practice!

