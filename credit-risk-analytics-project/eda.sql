/*******************************************************************************
  CREDIT RISK ANALYTICS PROJECT
  Exploratory Data Analysis & Risk Metrics Extraction
  --------------------------------------------------------------------------
  A structured analytical framework evaluating loan default drivers:
  1. Overall Portfolio Defaults             5. Loan Amount vs. Default Status
  2. Default Rate by Credit Score Range     6. Employment Status Analysis
  3. Default Rate by DTI Ratio Range        7. Employment Tenure Assessment
  4. Default Rate by Loan Purpose           8. Short-Term Employment Risk Check

  Key findings: DTI > 40%, credit scores 520-599, and tenure <2 years 
  show the highest correlation with loan defaults.
********************************--------------------------------***************/

CREATE DATABASE CreditRiskAnalytics;
GO

USE CreditRiskAnalytics;
GO


--------------------------------------------------------------------------------
-- STEP 1: OVERALL PORTFOLIO DEFAULT RATE
--------------------------------------------------------------------------------
SELECT 
    COUNT(*) AS total_loans,
    SUM(CAST(defaulted AS INT)) AS total_defaults,
    ROUND(CAST(SUM(CAST(defaulted AS INT)) AS FLOAT) / COUNT(*) * 100, 2) AS default_percentage
INTO dbo.overall_defaults
FROM dbo.loan_applications;


--------------------------------------------------------------------------------
-- STEP 2: DEFAULT RATE BY CREDIT SCORE RANGE
--------------------------------------------------------------------------------
-- Checking min and max bounds for credit scores
/*
SELECT 
	MIN(credit_score) AS min_credit_score,
	MAX(credit_score) AS max_credit_score
FROM dbo.borrower_profiles
*/

SELECT
    CASE 
        WHEN bp.credit_score BETWEEN 520 AND 599 THEN '520-599'
        WHEN bp.credit_score BETWEEN 600 AND 649 THEN '600-649'
        WHEN bp.credit_score BETWEEN 650 AND 699 THEN '650-699'
        WHEN bp.credit_score BETWEEN 700 AND 749 THEN '700-749'
        WHEN bp.credit_score >= 750 THEN '750+'
        ELSE 'Below 520'
    END AS credit_score_range,
    COUNT(*) AS total_loans,
    SUM(CAST(defaulted AS INT)) AS total_defaults,
    ROUND(CAST(SUM(CAST(defaulted AS INT)) AS FLOAT) / COUNT(*) * 100, 2) AS default_percentage
INTO dbo.default_rate_by_credit_score_range
FROM dbo.loan_applications AS la
JOIN dbo.borrower_profiles AS bp
ON la.borrower_id = bp.borrower_id
GROUP BY 
    CASE 
        WHEN bp.credit_score BETWEEN 520 AND 599 THEN '520-599'
        WHEN bp.credit_score BETWEEN 600 AND 649 THEN '600-649'
        WHEN bp.credit_score BETWEEN 650 AND 699 THEN '650-699'
        WHEN bp.credit_score BETWEEN 700 AND 749 THEN '700-749'
        WHEN bp.credit_score >= 750 THEN '750+'
        ELSE 'Below 520'
    END;


--------------------------------------------------------------------------------
-- STEP 3: DEFAULT RATE BY DEBT-TO-INCOME (DTI) RATIO
--------------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN dti_ratio < 20 THEN '0-19'
        WHEN dti_ratio BETWEEN 20 AND 29 THEN '20-29'
        WHEN dti_ratio BETWEEN 30 AND 39 THEN '30-39'
        WHEN dti_ratio BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS dti_ratio_range,
    COUNT(*) AS total_loans,
    SUM(CAST(defaulted AS INT)) AS total_defaults,
    ROUND(CAST(SUM(CAST(defaulted AS INT)) AS FLOAT) / COUNT(*) * 100, 2) AS default_percentage
INTO dbo.default_rate_by_dti
FROM dbo.loan_applications
GROUP BY 
    CASE 
        WHEN dti_ratio < 20 THEN '0-19'
        WHEN dti_ratio BETWEEN 20 AND 29 THEN '20-29'
        WHEN dti_ratio BETWEEN 30 AND 39 THEN '30-39'
        WHEN dti_ratio BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END;


--------------------------------------------------------------------------------
-- STEP 4: DEFAULT RATE BY LOAN PURPOSE
--------------------------------------------------------------------------------
SELECT    
    loan_purpose,
    COUNT(*) AS total_loans,
    SUM(CAST(defaulted AS INT)) AS total_defaults,
    ROUND(CAST(SUM(CAST(defaulted AS INT)) AS FLOAT) / COUNT(*) * 100, 2) AS default_percentage
INTO dbo.default_rate_by_loan_purpose
FROM dbo.loan_applications
GROUP BY loan_purpose
ORDER BY default_percentage DESC;


--------------------------------------------------------------------------------
-- STEP 5: LOAN AMOUNT VS. DEFAULT STATUS
--------------------------------------------------------------------------------
SELECT
    defaulted,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_amount), 0) AS avg_loan_amount,
    MIN(loan_amount) AS min_loan,
    MAX(loan_amount) AS max_loan
INTO dbo.default_by_loan_amount
FROM dbo.loan_applications
GROUP BY defaulted;


--------------------------------------------------------------------------------
-- STEP 6: DEFAULT RISK BY EMPLOYMENT STATUS
--------------------------------------------------------------------------------
SELECT
    bp.employment_status,
    COUNT(*) AS total_loans,
    SUM(CAST(defaulted AS INT)) AS total_defaults,
    ROUND(CAST(SUM(CAST(defaulted AS INT)) AS FLOAT) / COUNT(*) * 100, 2) AS default_percentage
INTO dbo.default_rate_by_employment_status
FROM dbo.loan_applications AS la
JOIN dbo.borrower_profiles AS bp
ON la.borrower_id = bp.borrower_id
GROUP BY bp.employment_status
ORDER BY default_percentage DESC;


--------------------------------------------------------------------------------
-- STEP 7: DEFAULT RISK BY EMPLOYMENT TENURE (YEARS EMPLOYED)
--------------------------------------------------------------------------------
WITH LoanData AS (
    SELECT 
        CASE 
            WHEN bp.years_employed < 2 THEN '<2 years'
            WHEN bp.years_employed BETWEEN 2 AND 5 THEN '2-5 years'
            WHEN bp.years_employed BETWEEN 6 AND 10 THEN '6-10 years'
            ELSE '10+ years'
        END AS employment_tenure,
        la.defaulted
    FROM dbo.loan_applications AS la
    JOIN dbo.borrower_profiles AS bp
    ON la.borrower_id = bp.borrower_id
)
SELECT 
    employment_tenure,
    COUNT(*) AS total_loans,
    SUM(CAST(defaulted AS INT)) AS total_defaults,
    ROUND(CAST(SUM(CAST(defaulted AS INT)) AS FLOAT) / COUNT(*) * 100, 2) AS default_percentage
INTO dbo.default_rate_by_employment_tenure
FROM LoanData
GROUP BY employment_tenure
ORDER BY 
    CASE employment_tenure
        WHEN '<2 years' THEN 1
        WHEN '2-5 years' THEN 2
        WHEN '6-10 years' THEN 3
        ELSE 4
    END ASC;


--------------------------------------------------------------------------------
-- STEP 8: TARGETED RISK CHECK FOR SHORT-TERM EMPLOYED BORROWERS (<2 YEARS)
--------------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN bp.years_employed < 2 THEN '<2 years'
        ELSE '2+ years'
    END AS employment_group,
    COUNT(*) AS total_loans,
    SUM(CAST(defaulted AS INT)) AS total_defaults,
    ROUND(CAST(SUM(CAST(defaulted AS INT)) AS FLOAT) / COUNT(*) * 100, 2) AS default_percentage
INTO dbo.default_rate_by_employment_group
FROM loan_applications la
JOIN borrower_profiles bp ON la.borrower_id = bp.borrower_id
GROUP BY 
	CASE 
        WHEN bp.years_employed < 2 THEN '<2 years'
        ELSE '2+ years'
    END 
ORDER BY employment_group;
