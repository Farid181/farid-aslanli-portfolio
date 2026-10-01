# 💳 Credit Risk Analytics Project (SQL + Power BI)

An end-to-end data analytics project designed to evaluate **credit risk** and analyze **loan default patterns**. The project covers the main stages of a real financial analytics workflow: exploring relational loan and borrower tables, structuring a comprehensive 8-step EDA framework in SQL, extracting key risk metrics, and designing an interactive Power BI dashboard to uncover high-risk borrower segments.

---

## 🛠️ Project Workflow & Technical Highlights

### 1. Database Setup & Architecture
- Structured relational tables (`loan_applications` and `borrower_profiles`) in **SQL Server** to manage loan records and borrower demographics efficiently.
- Prepared clean analytical datasets to track portfolio exposure, default distribution, and key risk metrics.

### 2. Exploratory Data Analysis (EDA)
- Executed a structured **8-step EDA process**: overall portfolio default rates, credit score risk brackets, debt-to-income (DTI) thresholds, loan purpose analysis, loan amount comparisons, employment status, tenure assessment, and short-term employment risk checks.
- Uncovered critical portfolio risk drivers, identifying exact thresholds where default probabilities surge.

### 3. Risk Metrics & Segmentation
- Categorized continuous financial variables (such as credit scores and DTI ratios) into logical risk brackets using conditional `CASE` statements and CTEs.
- Evaluated borrower vulnerabilities across employment types and tenure lengths to isolate high-risk segments.

### 4. Business Insight Analysis & BI Design
- Analyzed the correlation between high DTI ratios (>40%), low credit scores (520–599), short employment tenure (<2 years), and loan defaults.
- Designed an executive Power BI dashboard using professional corporate branding, clear metrics cards, and optimized data layouts to visualize default rates interactively.

---

## 📈 Key Insights

- **Credit Score Impact:** The credit score bucket with the highest default rate is **520–599** (49.14%), showing a strong inverse correlation between credit health and default risk[cite: 3].
- **Debt-to-Income (DTI) Threshold:** Borrowers with a DTI above **40%** experience significantly higher default vulnerability, with ratios exceeding 50% pushing default rates past **31.7%**[cite: 3].
- **Loan Purpose Vulnerability:** **Wedding** loans exhibit the highest default rate at approximately **32%**, followed by Home Improvement (~29%)[cite: 3].
- **Loan Size Independence:** The average loan amount does not differ drastically between defaulted (~$22.57K) and non-defaulted (~$22.01K) loans, proving that loan size alone is not the primary risk driver[cite: 3, 9].
- **Employment Tenure Risk:** Borrowers with less than **2 years** of employment tenure present a much higher default rate (**34.52%**) compared to long-term groups[cite: 3, 7].

---

## 📷 Project Screenshots & Visualizations

### 📊 Power BI Dashboard Phase

### 1. Executive Overview
![Dashboard Overview](screenshots/01_credit_risk_dashboard_overview.png)
*Full executive summary featuring key risk KPIs, default distributions, and borrower segment filters[cite: 3].*

### 2. Default Rate by Credit Score
![Credit Score Risk](screenshots/02_credit_score_risk.png)
*Default rates across different credit score ranges, highlighting the 520–599 high-risk bucket[cite: 3, 5].*

### 3. Default Rate by DTI Ratio
![DTI Impact](screenshots/03_dti_impact.png)
*Default percentage breakdown by Debt-to-Income ratio tiers[cite: 3, 6].*

### 4. Default Rate by Loan Purposes
![Loan Purpose Risk](screenshots/04_loan_purpose_risk.png)
*Identifying high-risk loan purposes such as Wedding and Home Improvement[cite: 3, 7].*

### 5. Default Rate by Employment Tenure
![Employment Tenure](screenshots/05_employment_tenure.png)
*Impact of employment tenure and short-term employment (<2 years) on defaults[cite: 3, 8].*

### 6. Default Rate by Employment Status
![Employment Status](screenshots/06_employment_status.png)
*Default variations across Part-Time, Self-Employed, Full-Time, and other categories[cite: 3, 9].*

### 7. Default by Loan Amount
![Loan Amount](screenshots/07_default_by_loan_amount.png)
*Comparison of average loan sizes for defaulted vs. non-defaulted portfolios[cite: 3].*

---

## 📂 Project Files & Structure

- [`eda.sql`](eda.sql) — 8-step exploratory data analysis and risk metrics extraction
- [`CREDIT RISK DASHBOARD.pbix`](CREDIT RISK DASHBOARD.pbix) — Executive Power BI interactive report

---

## ✅ Project Status
- [x] Relational schema architecture and data structuring built in SQL Server
- [x] Exploratory Data Analysis and risk metrics extraction implemented via 8-step framework
- [x] Executive Power BI dashboard designed with custom measures and risk indicators
- [x] Portfolio documentation and visual showcase published successfully
