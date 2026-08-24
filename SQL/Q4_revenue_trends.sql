--Q4 - QUARTERLY REVENUE TRENDS
--========================================================================
--Compare quarterly revenue across 2023 and 2024. For each quarter
--calculate total revenue, average order value and total number of orders.
--Identify which single quarter showed the strongest revenue growth from 2023 to 2024.
--========================================================================


SELECT
	EXTRACT(YEAR FROM orders.order_date) AS year,
	EXTRACT(QUARTER FROM orders.order_date) AS quarter,
	SUM(order_items.line_total) AS total_revenue,
	ROUND(
		SUM(order_items.line_total) * 1.0
		/ COUNT(DISTINCT orders.order_id),
		2) AS avg_order_value,
	COUNT(DISTINCT orders.order_id) AS total_orders
FROM orders
JOIN order_items
ON orders.order_id = order_items.order_id
WHERE orders.order_date BETWEEN '2023-01-01' 
AND '2024-12-31'
GROUP BY
	EXTRACT(YEAR FROM orders.order_date),
	EXTRACT(QUARTER FROM orders.order_date)
ORDER BY year, quarter;