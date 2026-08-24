--Q2 - PRODUCT PERFORMANCE
--================================================
--Identify the top 10 products by total revenue in 2024.
--Include product name, category, total revenue and total
--number of orders. Sort by revenue descending.
--================================================

--a. order_items
SELECT *
FROM order_items;

--b. orders in 2024
SELECT oi.*, o.order_date
FROM order_items oi
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31';

--c. revenue per product
SELECT
	oi.product_id,
	SUM(oi.line_total) AS total_revenue,
	COUNT(DISTINCT oi.order_id) AS
total_orders
FROM order_items oi
JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY oi.product_id;

--d. Adding product details
SELECT
	p.product_name,
	p.category,
	SUM(oi.line_total) AS total_revenue,
	COUNT(DISTINCT oi.order_id) AS
total_orders
FROM order_items oi
JOIN orders o
ON oi.order_id = o.order_id
JOIN products p
ON oi.product_id = p.product_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY p.product_name, p.category;

--e. Limiting to 10 products
SELECT
	p.product_name,
	p.category,
	SUM(oi.line_total) AS total_revenue,
	COUNT(DISTINCT oi.order_id) AS
total_orders
FROM order_items oi
JOIN orders o
ON oi.order_id = o.order_id
JOIN products p
ON oi.product_id = p.product_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 10;

--END OF Q2-PRODUCT PERFORMANCE--