/*******************************************************************************
  OLIST E-COMMERCE ANALYTICS PROJECT
  02 - Exploratory Data Analysis (EDA)
  --------------------------------------------------------------------------
  A structured, 8-step EDA framework applied before any deeper analysis:
  1. Database Exploration        5. Dimension Exploration
  2. Data Quality Check          6. Magnitude / Segmentation Analysis
  3. Date/Time Exploration       7. Ranking (Top-N)
  4. Key Metrics Overview        8. Cross-Metric / Relationship Check

  Key finding from this stage: order_reviews contains duplicate review_id
  values (99,224 rows / 98,410 unique) -> addressed in 03_gold_views.sql
*******************************************************************************/

--------------------------------------------------------------------------------
-- STEP 1: DATABASE EXPLORATION
--------------------------------------------------------------------------------
SELECT * FROM INFORMATION_SCHEMA.TABLES;
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'orders';


--------------------------------------------------------------------------------
-- STEP 2: DATA QUALITY CHECK (uniqueness / duplicate check across core tables)
--------------------------------------------------------------------------------
SELECT 'Customers' AS table_name, COUNT(customer_id) AS total_rows, COUNT(DISTINCT customer_id) AS unique_ids FROM olist.customers
UNION ALL
SELECT 'Orders', COUNT(order_id), COUNT(DISTINCT order_id) FROM olist.orders
UNION ALL
SELECT 'Products', COUNT(product_id), COUNT(DISTINCT product_id) FROM olist.products
UNION ALL
SELECT 'Sellers', COUNT(seller_id), COUNT(DISTINCT seller_id) FROM olist.sellers
UNION ALL
SELECT 'Reviews', COUNT(review_id), COUNT(DISTINCT review_id) FROM olist.order_reviews;
-- Finding: 814 duplicate review_id values in order_reviews -> cleaned in the Gold layer


--------------------------------------------------------------------------------
-- STEP 3: DATE / TIME EXPLORATION
--------------------------------------------------------------------------------
SELECT 
    MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS last_order_date,
    DATEDIFF(DAY, MIN(order_purchase_timestamp), MAX(order_purchase_timestamp)) AS total_days_range
FROM olist.orders;


--------------------------------------------------------------------------------
-- STEP 4: KEY METRICS / MEASURES OVERVIEW
--------------------------------------------------------------------------------
SELECT 'Total Orders' AS metric_name, COUNT(order_id) AS metric_value FROM olist.orders
UNION ALL
SELECT 'Total Customers', COUNT(customer_id) FROM olist.customers
UNION ALL
SELECT 'Total Products', COUNT(product_id) FROM olist.products
UNION ALL
SELECT 'Total Sellers', COUNT(seller_id) FROM olist.sellers;


--------------------------------------------------------------------------------
-- STEP 5: DIMENSION EXPLORATION (unique values of categorical fields)
--------------------------------------------------------------------------------
SELECT DISTINCT order_status FROM olist.orders;
SELECT DISTINCT payment_type FROM olist.order_payments;


--------------------------------------------------------------------------------
-- STEP 6: MAGNITUDE / SEGMENTATION ANALYSIS
--------------------------------------------------------------------------------

-- 6.1 Revenue & volume metrics (delivered orders only)
SELECT
    SUM(oi.price) AS total_revenue,
    SUM(oi.freight_value) AS total_freight_cost,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(AVG(oi.price), 2) AS avg_item_price,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight_value,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM olist.order_items oi
JOIN olist.orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';
-- Note: filtering to order_status = 'delivered' was a deliberate correction
-- to avoid inflating revenue with cancelled/undelivered orders

-- 6.2 Geographic distribution (top 10 customer cities)
SELECT TOP 10
    customer_city,
    customer_state,
    COUNT(customer_id) AS total_customers
FROM olist.customers
GROUP BY customer_city, customer_state
ORDER BY total_customers DESC;

-- 6.3 Revenue by product category
SELECT TOP 10
    t.product_category_name_english AS category_name,
    COUNT(oi.order_item_id) AS total_items_sold,
    SUM(oi.price) AS total_revenue
FROM olist.order_items oi
LEFT JOIN olist.products p ON oi.product_id = p.product_id
LEFT JOIN olist.product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY total_revenue DESC;

-- 6.4 Review score distribution
SELECT 
    review_score,
    COUNT(*) AS total_reviews,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS percentage
FROM olist.order_reviews
GROUP BY review_score
ORDER BY review_score DESC;


--------------------------------------------------------------------------------
-- STEP 7: RANKING / TOP-N
--------------------------------------------------------------------------------

-- 7.1 Overall delivery delay rate
SELECT 
    COUNT(order_id) AS total_delivered_orders,
    SUM(CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1 ELSE 0 END) AS on_time_orders,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS delayed_orders,
    CAST(SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id) AS DECIMAL(5,2)) AS delay_percentage
FROM olist.orders
WHERE order_status = 'delivered' 
  AND order_delivered_customer_date IS NOT NULL;

-- 7.2 States with the highest delay rate (min. 500 orders)
SELECT TOP 10
    customer_state,
    COUNT(order_id) AS total_orders,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS delayed_orders,
    CAST(SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id) AS DECIMAL(5,2)) AS delay_percentage
FROM olist.orders o
JOIN olist.customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered' 
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY customer_state
HAVING COUNT(order_id) > 500
ORDER BY delay_percentage DESC;

-- 7.3 Lowest-rated product categories (min. 100 reviews)
SELECT TOP 5
    t.product_category_name_english AS category_name,
    ROUND(AVG(CAST(r.review_score AS FLOAT)), 2) AS avg_review_score,
    COUNT(r.review_id) AS total_reviews
FROM olist.order_reviews r
LEFT JOIN olist.order_items oi ON r.order_id = oi.order_id
LEFT JOIN olist.products p ON oi.product_id = p.product_id
LEFT JOIN olist.product_category_name_translation t ON t.product_category_name = p.product_category_name
GROUP BY t.product_category_name_english
HAVING COUNT(r.review_id) > 100
ORDER BY avg_review_score ASC;


--------------------------------------------------------------------------------
-- STEP 8: CROSS-METRIC / RELATIONSHIP CHECK
--------------------------------------------------------------------------------
-- Does late delivery actually affect customer satisfaction?   
SELECT 
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Delayed Orders'
        ELSE 'On-Time / Early Orders'
    END AS delivery_status,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(CAST(r.review_score AS FLOAT)), 2) AS avg_review_score
FROM olist.orders o
JOIN olist.order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered' 
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Delayed Orders'
        ELSE 'On-Time / Early Orders'
    END;
-- Finding: Delayed orders average a 2.57 review score vs. 4.29 for on-time orders, 
-- showing that delivery performance directly drives customer satisfaction.
