# 🛒 Olist E-Commerce Analytics Project (SQL + Power BI)

An end-to-end SQL analytics project on the **Olist Brazilian E-Commerce dataset** (~100K orders, 9 relational tables). The project covers the main stages of a real analytics workflow: exploring an unfamiliar database, finding and fixing data quality issues, building a customer segmentation model, and pulling out business insights.

---

## 🛠️ Project Workflow & Technical Highlights

### 1. Database Setup & Architecture
* Built the database from scratch in **SQL Server**, loading 9 raw CSV tables via `BULK INSERT`.
* Kept raw data untouched in an `olist` schema and put all cleaning/business logic in a separate `gold` schema, so reports stay in sync as new data comes in.

### 2. Exploratory Data Analysis (EDA)
* Ran a structured **8-step EDA process**: structure → data quality → date range → key metrics → categories → segmentation → rankings → cross-checking metrics against each other.
* Found **814 duplicate `review_id` values** in the reviews table during the data quality check.

### 3. Data Cleaning & Modeling
* Built `gold.dim_order_reviews_clean` using `ROW_NUMBER()` to remove the duplicate reviews, keeping only the latest version of each one.
* Built a clean **Star Schema** in Power BI, handling relationships and creating custom measures (like separating column and line metrics to fix label overlap issues).

### 4. Customer Segmentation (RFM)
* Scored every customer on **Recency, Frequency, and Monetary** value and grouped them into 6 segments (Champions, Loyal, New, At Risk, Potential Loyalist, Lost).
* `NTILE(5)` didn't work for Frequency — 97% of customers had placed exactly one order, so there wasn't enough variety to split them into 5 real groups. Scored that one manually instead; Recency and Monetary worked fine with `NTILE(5)`.

### 5. Business Insight Analysis & BI Design
* Compared review scores for delayed vs. on-time deliveries to check whether delivery performance actually affects customer satisfaction.
* Designed an executive Power BI dashboard using professional corporate branding, custom logo, and optimized font sizes (9pt) for clear data labels.

---

## 📈 Key Insights

* **Delivery delays hurt satisfaction — a lot:** delayed orders average a **2.57** review score vs. **4.29** for on-time ones, about a 40% drop.
* **Most customers only buy once:** 97% of customers (90,557 of 93,358) placed exactly one order — a key reason the RFM scoring needed a custom approach for Frequency.
* **Customer base skews toward "Lost" and "New":** together they make up ~78% of customers, with true "Champions" being rare (~0.1%) — expected for a marketplace with a low repeat-purchase rate.
* **Data quality matters:** 814 duplicate reviews were quietly inflating the review count before cleaning — a reminder to never trust raw data at face value.

---

## 📷 Project Screenshots & Visualizations

### 🔍 SQL & Data Quality Phase

![Duplicate reviews found during EDA](screenshots/01_duplicate_reviews_finding.png)
*Duplicate `review_id` values found during the data quality check*

![Delivery delay vs review score](screenshots/02_delivery_vs_review_score.png)
*Delayed vs. on-time orders — average review score*

![RFM segment distribution](screenshots/03_rfm_segment_distribution.png)
*Final customer segment counts*

![Frequency distribution](screenshots/04_frequency_distribution.png)
*Why Frequency needed a manual scoring rule instead of NTILE(5)*

![Business overview](screenshots/05_business_overview.png)
*Total orders, customers, products, and sellers*

---

### 📊 Power BI Dashboard Phase

### 📊 Executive Overview
![Dashboard Overview](screenshots/OLIST_dashboard_overview.png)
*Full executive summary featuring high-level KPIs, revenue trends, payment distributions, and category breakdowns.*

### 👑 Champions Segment Deep-Dive
![Champions Filtered](screenshots/OLIST_dashboard_champions.png)
*Filtering the dashboard by the "Champions" tier to isolate VIP customer behavior and preferred product categories.*

### 📅 Temporal Filtering (2018 Performance)
![2018 Filtered](screenshots/OLIST_dashboard_2018.png)
*Isolating the peak operating year (2018) via interactive year slicers.*

### ⚠️ Risk & Retention Analysis (2017 Lost Customers)
![2017 Lost](screenshots/OLIST_dashboard_2017_lost.png)
*Analyzing the behavioral patterns and payment preferences of "Lost" customers during 2017.*

### 💳 Payment Preferences for At-Risk Users
![At Risk Payment](screenshots/OLIST_dashboard_at_risk_payment.png)
*Cross-filtering "At Risk" customers to examine their preferred transaction methods.*

### 🚀 Platform Inception (2016 Overview)
![2016 Overview](screenshots/OLIST_dashboard_2016_overview.png)
*Inspecting baseline metrics and initial traction during Olist's launch year (2016).*

### 📍 Regional Distribution (São Paulo Focus)
![Top State SP](screenshots/OLIST_dashboard_top_state_sp.png)
*Isolating orders and revenue originating from the primary market region (São Paulo).*

---

## 📂 Project Files & Structure

* [`01_database_setup.sql`](01_database_setup.sql) — schema, tables, raw data load
* [`02_eda.sql`](02_eda.sql) — 8-step exploratory data analysis
* [`03_gold_views.sql`](03_gold_views.sql) — cleaned reviews + RFM segmentation views
* [`04_validation_and_insights.sql`](04_validation_and_insights.sql) — model validation + key findings

---

## ✅ Project Status
* [x] End-to-end data pipeline and `gold` schema architecture built in SQL Server
* [x] Exploratory Data Analysis, data cleaning, and RFM customer segmentation implemented
* [x] Executive Power BI dashboard designed with custom measures and interactive filters
* [x] Portfolio documentation and visual showcase published successfully


https://app.powerbi.com/groups/me/reports/ea10bbfd-2b97-481d-924b-4bb5f92608d6/18b24161ca2248989d8b?experience=power-bi

