/*******************************************************************************
  OLIST E-COMMERCE ANALYTICS PROJECT
  04 - Validation Queries & Key Insights
  --------------------------------------------------------------------------
  Queries used to check that the RFM model in 03_gold_views.sql makes
  sense, plus the main findings from the project. Not production views,
  just notes on the process.
*******************************************************************************/

--------------------------------------------------------------------------------
-- A) Why Frequency is scored manually instead of with NTILE(5)
--------------------------------------------------------------------------------
SELECT frequency, COUNT(*) AS customer_count
FROM (
    SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS frequency
    FROM olist.orders o
    LEFT JOIN olist.customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) t
GROUP BY frequency
ORDER BY frequency;

-- Result: 90,557 of 93,358 customers (97%) placed exactly 1 order.
-- With almost everyone having the same value, NTILE(5) can't break them into 5 meaningful groups 
-- hence the manual CASE rule for F_Score in 03_gold_views.sql.


--------------------------------------------------------------------------------
-- B) Checking that Recency and Monetary don't have the same issue
--------------------------------------------------------------------------------
SELECT 
    COUNT(*) AS total_customers,
    COUNT(DISTINCT recency) AS distinct_recency_values,
    COUNT(DISTINCT monetary) AS distinct_monetary_values
FROM (
    SELECT 
        c.customer_unique_id,
        DATEDIFF(DAY, MAX(o.order_purchase_timestamp), (SELECT MAX(order_purchase_timestamp) FROM olist.orders)) AS recency,
        SUM(oi.price) AS monetary
    FROM olist.orders o
    LEFT JOIN olist.customers c ON o.customer_id = c.customer_id
    LEFT JOIN olist.order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) t;

-- Result: 611 different recency values and 8,143 different monetary
-- values across 93,358 customers -- plenty of variety, so NTILE(5)
-- works fine here, unlike Frequency above.


--------------------------------------------------------------------------------
-- C) Checking the final customer segments look right
--------------------------------------------------------------------------------
SELECT Customer_Segment, COUNT(*) AS total_customers
FROM gold.report_customer_rfm
GROUP BY Customer_Segment
ORDER BY total_customers DESC;

-- Result:
--   Lost                36,351  (~39%)
--   New Customers        36,140  (~39%)
--   Potential Loyalist   18,066  (~19%)
--   Loyal Customers       1,687  (~1.8%)
--   At Risk                 993  (~1.1%)
--   Champions                121  (~0.1%)

-- Makes sense for a marketplace where most customers only buy once, consistent with finding (A).


--------------------------------------------------------------------------------
-- D) Main finding: Does a late delivery actually affect the review score?
--------------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Delayed Orders'
        ELSE 'On-Time / Early Orders'
    END AS delivery_status,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(CAST(r.review_score AS FLOAT)), 2) AS avg_review_score
FROM olist.orders o
JOIN gold.dim_order_reviews_clean r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered' 
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Delayed Orders'
        ELSE 'On-Time / Early Orders'
    END;

-- Result: 2.57 avg. review score for delayed orders vs. 4.29 for on-time ones.
-- Uses the cleaned gold.dim_order_reviews_clean view instead of the raw table,
-- so duplicate reviews don't skew this.