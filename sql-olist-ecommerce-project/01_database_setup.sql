/*******************************************************************************
  OLIST E-COMMERCE ANALYTICS PROJECT
  01 - Database Setup
  --------------------------------------------------------------------------
  Creates the database, the raw ("olist") schema, all 9 source tables,
  and loads the raw CSV files (Kaggle: Brazilian E-Commerce Public Dataset
  by Olist) using BULK INSERT.

  Note: Update the file paths below to match your local environment before
  running this script.
*******************************************************************************/

-- 1. Create the database
CREATE DATABASE OlistECommerce;
GO

USE OlistECommerce;
GO

-- 2. Raw data schema (Bronze layer - untouched source data)
CREATE SCHEMA olist;
GO

-- 3. Customers
CREATE TABLE olist.customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

-- 4. Products
CREATE TABLE olist.products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- 5. Sellers
CREATE TABLE olist.sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

-- 6. Orders
CREATE TABLE olist.orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

-- 7. Order Items
CREATE TABLE olist.order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2)
);

-- 8. Order Payments
CREATE TABLE olist.order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10, 2)
);

-- 9. Order Reviews
CREATE TABLE olist.order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

-- 10. Geolocation
CREATE TABLE olist.geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);

-- 11. Product category name translation (Portuguese -> English)
CREATE TABLE olist.product_category_name_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);
GO

----------------------------------------------------------------------------------------------------
-- Load raw CSV files
-- Replace 'C:\path\to\dataset\' with your local dataset folder
----------------------------------------------------------------------------------------------------

BULK INSERT olist.customers FROM 'C:\path\to\dataset\olist_customers_dataset.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001');

BULK INSERT olist.products FROM 'C:\path\to\dataset\olist_products_dataset.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001');

BULK INSERT olist.sellers FROM 'C:\path\to\dataset\olist_sellers_dataset.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001');

BULK INSERT olist.orders FROM 'C:\path\to\dataset\olist_orders_dataset.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001');

BULK INSERT olist.order_items FROM 'C:\path\to\dataset\olist_order_items_dataset.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001');

BULK INSERT olist.order_payments FROM 'C:\path\to\dataset\olist_order_payments_dataset.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001');

BULK INSERT olist.order_reviews FROM 'C:\path\to\dataset\olist_order_reviews_dataset.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001');

BULK INSERT olist.geolocation FROM 'C:\path\to\dataset\olist_geolocation_dataset.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001');

BULK INSERT olist.product_category_name_translation FROM 'C:\path\to\dataset\product_category_name_translation.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001');
GO

----------------------------------------------------------------------------------------------------
-- Verify row counts after load
----------------------------------------------------------------------------------------------------

SELECT 'Customers' AS table_name, COUNT(*) AS row_count FROM olist.customers
UNION ALL
SELECT 'Products', COUNT(*) FROM olist.products
UNION ALL
SELECT 'Sellers', COUNT(*) FROM olist.sellers
UNION ALL
SELECT 'Orders', COUNT(*) FROM olist.orders
UNION ALL
SELECT 'Order Items', COUNT(*) FROM olist.order_items
UNION ALL
SELECT 'Order Payments', COUNT(*) FROM olist.order_payments
UNION ALL
SELECT 'Order Reviews', COUNT(*) FROM olist.order_reviews
UNION ALL
SELECT 'Geolocation', COUNT(*) FROM olist.geolocation
UNION ALL
SELECT 'Category Translation', COUNT(*) FROM olist.product_category_name_translation;
