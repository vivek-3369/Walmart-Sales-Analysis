# 🛒 Walmart Sales Analysis

> **An end-to-end data analysis project exploring what drives sales revenue, product profit margins, peak shopping hours, and customer satisfaction across Walmart stores.**

---

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Business Problem](#business-problem)
- [Dataset Used](#dataset-used)
- [Tools Used](#tools-used)
- [Process](#process)
- [Key Insights](#key-insights)
- [Recommendations](#recommendations)
- [Future Scope](#future-scope)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)

---

## 📌 Project Overview

This project analyzes Walmart store sales data across different cities and branches. The main goal is to build a complete data pipeline — turning raw sales records into clean data and using SQL to answer key business questions. 

By looking at sales trends, product profit margins, customer payment methods, busiest shopping shifts, and store performance drops, this analysis provides store managers and regional leaders with practical strategies to boost revenue and improve daily operations.

---

## 🎯 Business Problem

Managing multiple retail stores comes with several everyday challenges:

1. **Store Performance Drops:** Which stores are losing revenue compared to last year, and need immediate attention?
2. **Sales Volume vs. Profit:** Are top-selling items actually making good profit, or are high sales volume hiding thin profit margins?
3. **Staff Scheduling:** When do most customers shop, and how can stores schedule staff to prevent checkout bottlenecks?
4. **Product Ratings by City:** Why do customer satisfaction ratings for the same product category vary across different cities?
5. **Payment Preferences:** How do customers prefer to pay (Cash, Credit Card, E-wallet), and does their payment method affect order size?

Without data, store managers have to make decisions based on gut feeling. This project turns raw transaction records into clear, actionable answers.

---

## 📊 Dataset Used

The dataset contains historical sales records from multiple Walmart store locations and product categories.

### Dataset Summary

| Metric / Property | Details |
| :--- | :--- |
| **Data Source** | [Walmart 10k Sales Datasets (Kaggle)](https://www.kaggle.com/datasets/najir0123/walmart-10k-sales-datasets) |
| **Raw Record Count** | 10,051 transactions |
| **Cleaned Record Count** | 9,969 transactions (after removing duplicates & missing values) |
| **Time Period Covered** | 2019 – 2023 |
| **Total Columns** | 11 original columns + 1 calculated column (`total`) |

### Column Definitions

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| `invoice_id` | Integer | Unique ID for each transaction |
| `branch` | String | Store branch code (e.g., `WALM003`) |
| `city` | String | City where the store is located |
| `category` | String | Product category (e.g., *Health & Beauty*, *Electronics*) |
| `unit_price` | Float | Price per item (cleaned from currency format) |
| `quantity` | Float | Number of items bought in the purchase |
| `date` | Date | Transaction date |
| `time` | Time | Transaction time |
| `payment_method` | String | How the customer paid (*Cash*, *Credit Card*, *E-wallet*) |
| `rating` | Float | Customer review score (scale 3.0 to 10.0) |
| `profit_margin` | Float | Profit margin percentage on the item |
| `total` *(Calculated)* | Float | Total invoice value (`unit_price × quantity`) |

---

## 🛠️ Tools Used

| Tool | Purpose |
| :--- | :--- |
| **Python 3.11** | Core language for data cleaning and pipeline setup |
| **Pandas** | Loading, cleaning, transforming data, and fixing data types |
| **MySQL** | Storing clean data and running analytical queries |
| **SQLAlchemy & PyMySQL** | Connecting Python directly to MySQL for automated data export |
| **SQL (CTEs & Window Functions)** | Writing business queries, ranking top stores, and shift analysis |
| **Jupyter Notebook** | Environment for interactive data exploration |

---

## 🔄 Process

The project follows a simple 6-step pipeline:

```
┌──────────┐     ┌──────────┐     ┌──────────┐     ┌──────────────────┐     ┌───────────┐     ┌───────────────────┐
│ Raw CSV  │ ──► │ Data     │ ──► │ Data     │ ──► │ Feature          │ ──► │ MySQL     │ ──► │ Advanced SQL      │
│ Ingestion│     │ Cleaning │     │ Profiling│     │ Engineering      │     │ Ingestion │     │ Business Queries  │
└──────────┘     └──────────┘     └──────────┘     └──────────────────┘     └───────────┘     └──────────────────┘
```

### 1. Data Loading & Profiling
- Imported `Walmart.csv` (`10,051` rows, `11` columns) into Pandas.
- Checked data structure, summary statistics, and missing values using `.info()` and `.describe()`.

### 2. Data Cleaning
- **Removed Duplicates:** Dropped **51 duplicate rows**, leaving `10,000` rows.
- **Fixed Missing Values:** Dropped **31 blank rows** in price and quantity fields, leaving `9,969` clean rows.
- **Fixed Data Types:** Removed `$` signs from `unit_price`, converted `quantity` to numbers, and parsed `date` to proper date format.
- **Column Standardization:** Lowercased all column headers for clean SQL database naming.

### 3. Feature Engineering
- **Total Revenue (`total`):** Calculated missing transaction totals:
  `total = unit_price * quantity`
- **Total Profit (`total_profit`):** Provided the foundation to calculate net profit per sale in SQL:
  `total_profit = total * profit_margin`

### 4. Database Loading
- Connected Python to a local MySQL database (`walmart_db`) using SQLAlchemy.
- Automatically saved the clean table as `walmart` in MySQL.

### 5. SQL Business Queries
Wrote 9 business queries in SQL using:
- **Group Aggregations:** Summarizing payment counts and shift volume.
- **Window Functions (`RANK()`):** Finding peak sales days and top-rated categories per branch.
- **Common Table Expressions (CTEs):** Comparing Year-over-Year (YoY) store sales between 2022 and 2023.
- **CASE Statements:** Categorizing transaction times into *Morning*, *Afternoon*, and *Evening* shifts.

---

## 💡 Key Insights

From the SQL analysis, 5 main findings stood out:

### 1. 5 Stores Show Revenue Drops
- **5 Walmart branches experienced significant sales drops between 2022 and 2023.**
- *Why it matters:* These stores need immediate inspection to find out if local competition, stock shortages, or management issues caused the drop.

### 2. High Sales Volume Does Not Always Mean High Profit
- Some top-selling product categories have very thin profit margins, while smaller-volume categories yield higher net profit.
- *Why it matters:* Pushing low-margin items takes up valuable store space without adding much to the bottom line.

### 3. Afternoon is the Busiest Shift
- **Afternoon (12:00 PM – 5:00 PM) is the peak shopping period** across almost all store locations, followed by Evening shifts. Mornings are quietest.
- **Busiest days vary by branch.** Store peak days depend on local city routines.

### 4. E-Wallet Users Buy More Items
- **E-wallet is the most popular payment method**, followed by Cash and Credit Cards.
- **E-wallet customers purchase more items per order** compared to cash buyers.

### 5. Customer Satisfaction Varies by City
- Customer ratings for the same product category differ significantly across cities.
- *Why it matters:* Low ratings point to local store or inventory issues rather than nationwide product flaws.

---

## 🎯 Recommendations

Here are clear, practical actions Walmart leadership can take:

### 🎯 Strategic Action Matrix

| Focus Area | Problem Identified | Recommended Action |
| :--- | :--- | :--- |
| 🚩 **Store Turnaround** | 5 branches losing sales YoY | Send regional teams to audit inventory and staff management |
| 💰 **Profit Optimization** | High sales on thin profit margins | Give prime shelf space to high-margin products |
| 👥 **Workforce Management** | Understaffed peak hours | Schedule more staff during Afternoon shifts (12 PM – 5 PM) |
| 💳 **Digital Wallet Push** | Cash users buy fewer items | Offer small discounts for E-wallet checkouts to increase basket size |
| ⭐ **Quality Assurance** | Low category ratings in select cities | Audit product freshness and customer service in low-rated stores |

1. **Focus on Declining Stores:** Immediately inspect the 5 stores with dropping sales to fix stock-outs and operational issues.
2. **Promote High-Margin Items:** Move high-profit categories to front-of-store displays and end-caps.
3. **Match Staff Scheduling to Peak Hours:** Assign more cashiers and support staff during afternoon shifts and store-specific peak days.
4. **Encourage Digital Payments:** Partner with E-wallet providers for loyalty rewards to boost average order size.
5. **Fix Local Service Issues:** Address low product ratings in specific cities by improving store organization and item freshness.

---

## 🚀 Future Scope

Here is how this project can be expanded in the future:

| Upgrade Idea | Objective | Business Value |
| :--- | :--- | :--- |
| **Interactive Dashboard** | Build a dashboard in Power BI or Tableau | Helps store managers view live sales and shifts without writing SQL |
| **Sales Forecasting** | Build a machine learning model (Prophet / XGBoost) | Predicts future monthly sales to prevent overstock and stock-outs |
| **Customer Segmentation** | Group customers by shopping frequency and spending | Enables personalized marketing campaigns and loyalty offers |
| **Automated Pipeline** | Set up an automated ETL workflow using Airflow | Automatically refreshes sales data in MySQL every day |

---

## 📁 Project Structure

```text
Walmart-Sales-Analysis/
│
├── data/
│   ├── raw/                    # Raw dataset (Walmart.csv)
│   └── processed/              # Cleaned CSV ready for database loading
│
├── data_cleaning.ipynb         # Python notebook for cleaning & MySQL export
├── analysis_queries.sql        # SQL file with all 9 business queries
├── requirements.txt            # Python dependencies list
└── README.md                   # Project documentation
```

---

## ⚙️ Getting Started

### 1. Prerequisites
Make sure you have installed:
- **Python 3.11+**
- **MySQL Server & Workbench**
- **Jupyter Notebook** or **VS Code**

### 2. Setup

```bash
# Clone the repository
git clone https://github.com/your-username/Walmart-Sales-Analysis.git

# Go into project folder
cd Walmart-Sales-Analysis

# Create a virtual environment
python -m venv walmart-venv

# Activate virtual environment (Windows)
walmart-venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### 3. Running the Project

1. **Create Database:** Open MySQL and create a database named `walmart_db`.
2. **Clean & Load Data:** Run `data_cleaning.ipynb` to clean raw data and populate the `walmart` table in MySQL.
3. **Run Analytics:** Open `analysis_queries.sql` in MySQL Workbench and run the queries.

---

<div align="center">
  <sub>Simple, clear, and business-focused sales data analysis.</sub>
</div>