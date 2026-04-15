create database ecommerce;
use ecommerce;
create table orders(order_id varchar(50),customer_id varchar(50),
order_status varchar(20), order_purchase_timestamp datetime,
order_approved_at datetime,order_delivered_carrier_date datetime,
order_delivered_customer_date DATETIME,
order_estimated_delivery_date DATETIME );
CREATE TABLE customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price FLOAT,
    freight_value FLOAT
);
CREATE TABLE products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);
CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value FLOAT
);
DROP TABLE orders;
CREATE TABLE orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp VARCHAR(50),
    order_approved_at VARCHAR(50),
    order_delivered_carrier_date VARCHAR(50),
    order_delivered_customer_date VARCHAR(50),
    order_estimated_delivery_date VARCHAR(50)
);
DROP TABLE products;
CREATE TABLE products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_length VARCHAR(20),
    product_description_length VARCHAR(20),
    product_photos_qty VARCHAR(20),
    product_weight_g VARCHAR(20),
    product_length_cm VARCHAR(20),
    product_height_cm VARCHAR(20),
    product_width_cm VARCHAR(20)
);
DROP TABLE products;
CREATE TABLE products (
    product_id VARCHAR(100),
    product_category_name VARCHAR(200),
    product_name_length VARCHAR(200),
    product_description_length VARCHAR(200),
    product_photos_qty VARCHAR(50),
    product_weight_g VARCHAR(50),
    product_length_cm VARCHAR(50),
    product_height_cm VARCHAR(50),
    product_width_cm VARCHAR(50)
);

SET sql_mode = '';
SELECT * FROM customers LIMIT 10;
SELECT COUNT(*) AS total_customers FROM customers;
-- which state has most cust
SELECT customer_state, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;
-- Customers by City (Top 10)
SELECT customer_city, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 10;

SELECT * FROM orders;
SELECT COUNT(*) FROM orders;
-- Orders by Status
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;

-- orders Over Time
SELECT DATE(order_purchase_timestamp) AS order_date,
       COUNT(*) AS total_orders
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- connect customers and orders
SELECT 
    c.customer_city,
    c.customer_state,
    o.order_id,
    o.order_status
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
LIMIT 20;
 -- Top Cities with Most Orders
 SELECT 
    c.customer_city,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_city
ORDER BY total_orders DESC
LIMIT 10;

SELECT 
    c.customer_state,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;

DROP TABLE order_items;

DROP TABLE order_items;
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date varchar(50),
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);
SELECT COUNT(*) FROM order_items;
-- Total Revenue
SELECT SUM(price) AS total_revenue
FROM order_items;
-- Revenue by Customer
SELECT 
    c.customer_id,
    SUM(oi.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;
-- Top Orders by Revenue
SELECT 
    o.order_id,
    SUM(oi.price) AS order_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY order_revenue DESC
LIMIT 10;
-- Average Order Value
SELECT 
    AVG(order_total) AS avg_order_value
FROM (
    SELECT 
        order_id,
        SUM(price) AS order_total
    FROM order_items
    GROUP BY order_id
) t;
-- Top Products
SELECT 
    product_id,
    COUNT(*) AS total_sold
FROM order_items
GROUP BY product_id
ORDER BY total_sold DESC
LIMIT 10;
-- Delivery Performance + Revenue
SELECT 
    CASE 
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date 
        THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY delivery_status;
-- Monthly Revenue Trend
SELECT 
    MONTH(o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;





















