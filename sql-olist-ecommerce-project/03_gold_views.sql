/*******************************************************************************
  OLIST E-COMMERCE ANALYTICS PROJECT
  03 - Gold Layer Views

  Business-ready views on top of the raw "olist" schema. 
  Raw tables are never modified directly -- cleaning and aggregation logic lives here.
*******************************************************************************/

CREATE SCHEMA gold;
GO

--------------------------------------------------------------------------------
-- Deduplicated reviews (order_reviews had 814 duplicate review_id values)
--------------------------------------------------------------------------------
CREATE OR ALTER VIEW gold.dim_order_reviews_clean AS
WITH CleanReviews AS (
    SELECT
        review_id,
        order_id,
        review_score,
        review_creation_date,
        ROW_NUMBER() OVER (PARTITION BY review_id ORDER BY review_creation_date DESC) AS rn
    FROM olist.order_reviews
)
SELECT 
    review_id,
    order_id,
    review_score,
    review_creation_date
FROM CleanReviews
WHERE rn = 1;
GO

--------------------------------------------------------------------------------
-- Customer segmentation (RFM: Recency, Frequency, Monetary)

-- F_Score is not NTILE-based: 97% of customers placed exactly one order,
-- so NTILE(5) couldn't split Frequency meaningfully. Scored manually instead.
-- Recency and Monetary have enough spread for NTILE(5) to work.
--------------------------------------------------------------------------------
CREATE OR ALTER VIEW gold.report_customer_rfm AS
WITH CustomerRFM AS (
    SELECT 
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS last_order_date,
        DATEDIFF(DAY, MAX(o.order_purchase_timestamp), (SELECT MAX(order_purchase_timestamp) FROM olist.orders)) AS recency,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price) AS monetary
    FROM olist.orders o
    LEFT JOIN olist.customers c ON o.customer_id = c.customer_id
    LEFT JOIN olist.order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
), 
RFMScores AS (
    SELECT
        customer_unique_id,
        recency,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency DESC) AS R_Score,  -- DESC already puts most-recent customers in tile 5
        CASE 
            WHEN frequency = 1 THEN 1
            WHEN frequency = 2 THEN 3
            ELSE 5
        END AS F_Score,
        6 - NTILE(5) OVER (ORDER BY monetary DESC) AS M_Score  -- top spenders land in tile 1, so invert to score 5
    FROM CustomerRFM
)
SELECT 
    customer_unique_id,
    monetary,
    recency,
    frequency,
    R_Score,
    F_Score,
    M_Score,
    CAST(R_Score AS VARCHAR) + CAST(F_Score AS VARCHAR) + CAST(M_Score AS VARCHAR) AS RFM_Combined_Score,
    CASE 
        WHEN R_Score >= 4 AND F_Score >= 4 THEN 'Champions'
        WHEN R_Score >= 3 AND F_Score >= 3 THEN 'Loyal Customers'
        WHEN R_Score >= 4 AND F_Score >= 1 THEN 'New Customers'
        WHEN R_Score <= 2 AND F_Score >= 3 THEN 'At Risk'
        WHEN R_Score <= 2 AND F_Score <= 2 THEN 'Lost'
        ELSE 'Potential Loyalist'
    END AS Customer_Segment
FROM RFMScores;
GO