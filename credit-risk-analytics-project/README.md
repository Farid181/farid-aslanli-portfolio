# 💳 Credit Risk Analytics Project (SQL + Power BI)

An end-to-end analytics project on **loan default risk**. The project covers the main stages of a real credit-risk workflow: exploring relational loan and borrower tables in SQL Server, segmenting borrowers into risk brackets, extracting key default metrics, and presenting the findings in an interactive Power BI dashboard.

---

## 🎯 Business Question

> **Which borrower characteristics are most strongly associated with loan default, and where does portfolio risk concentrate?**

The analysis looks at credit score, debt-to-income (DTI) ratio, loan purpose, loan amount, employment status and employment tenure to identify the segments a lender should watch most closely.

---

## 🛠️ Project Workflow & Technical Highlights

### 1. Database & Data Model
* Worked in **SQL Server** with two relational tables: `loan_applications` (loan-level records and default flag) and `borrower_profiles` (credit score, employment status, tenure), linked by `borrower_id`.
* Each analysis step is saved as its own result table (`SELECT ... INTO`), so the outputs feed directly into Power BI.

### 2. Exploratory Data Analysis (EDA)
Ran a structured **8-step EDA process**:

| Step | Analysis |
|------|----------|
| 1 | Overall portfolio default rate |
| 2 | Default rate by credit score range |
| 3 | Default rate by DTI ratio range |
| 4 | Default rate by loan purpose |
| 5 | Loan amount vs. default status |
| 6 | Default rate by employment status |
| 7 | Default rate by employment tenure |
| 8 | Targeted check: borrowers with <2 years of employment |

### 3. Risk Segmentation
* Converted continuous variables (credit score, DTI, years employed) into risk brackets using `CASE` expressions.
* Used a **CTE** to keep the tenure bucketing readable and to apply a custom sort order to the output.
* Standardized every step on the same three metrics: `total_loans`, `total_defaults`, `default_percentage`.

### 4. Dashboard Design (Power BI)
* Built an executive dashboard with KPI cards, default-rate charts per risk driver, and interactive filters for borrower segments.

---

## 📈 Key Insights

* **Credit score is the strongest signal:** the **520–599** bracket has the highest default rate at **49.14%**, with default risk falling steadily as credit scores rise.
* **High DTI raises default risk:** borrowers with a DTI above **40%** default noticeably more often, and the **50%+** bracket exceeds **31.7%**.
* **Loan purpose matters:** **Wedding** loans have the highest default rate (~**32%**), followed by **Home Improvement** (~**29%**).
* **Loan size is not a differentiator:** average loan amounts are very close for defaulted (~$22.57K) and non-defaulted (~$22.01K) loans, so *who* borrows matters more than *how much*.
* **Short tenure is a red flag:** borrowers employed for **less than 2 years** default at **34.52%**, well above longer-tenure groups.

> 💡 **Takeaway:** Risk concentrates in borrowers with low credit scores, DTI above 40% and short employment history. These are the three filters a lender could prioritize in underwriting.

---

## 📷 Project Screenshots & Visualizations

### 📊 Power BI Dashboard

### Executive Overview
![Dashboard Overview](screenshots/01_credit_risk_dashboard_overview.png)
*Executive summary with key risk KPIs, default distributions, and borrower segment filters.*

### Default Rate by Credit Score
![Credit Score Risk](screenshots/02_credit_score_risk.png)

*Default rate across credit score ranges, highlighting the 520–599 high-risk bracket.*

### Default Rate by DTI Ratio
![DTI Impact](screenshots/03_dti_impact.png)

*Default percentage by debt-to-income tier.*

### Default Rate by Loan Purpose
![Loan Purpose Risk](screenshots/04_loan_purpose_risk.png)

*Loan purposes ranked by default rate, with Wedding and Home Improvement at the top.*

### Default Rate by Employment Tenure
![Employment Tenure](screenshots/05_employment_tenure.png)

*Impact of employment length on default, especially for borrowers with <2 years.*

### Default Rate by Employment Status
![Employment Status](screenshots/06_employment_status.png)

*Default rate variation across employment categories.*

### Loan Amount: Defaulted vs. Non-Defaulted
![Loan Amount](screenshots/07_default_by_loan_amount.png)

*Average loan size for defaulted and non-defaulted loans.*

---

## 📂 Project Files & Structure

* [`eda.sql`](eda.sql): 8-step exploratory data analysis and risk metric extraction
* [`CREDIT RISK DASHBOARD.pbix`](CREDIT%20RISK%20DASHBOARD.pbix): interactive Power BI report
* `screenshots/`: dashboard visuals used in this README

---

## 🧰 Tools & Skills Demonstrated

**SQL Server** · `CASE` bucketing · CTEs · joins · aggregations · `SELECT ... INTO` · **Power BI** · dashboard design · risk segmentation · business storytelling

---

## ✅ Project Status
- [x] Relational data structure and analysis tables built in SQL Server
- [x] 8-step EDA and risk metric extraction completed
- [x] Power BI dashboard designed with risk KPIs and interactive filters
- [x] Documentation and visual showcase published
