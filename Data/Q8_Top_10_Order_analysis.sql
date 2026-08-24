--Q8

SELECT
	orders.seller_id,
	COUNT(DISTINCT orders.order_id) AS total_orders,
	ROUND(AVG(reviews.rating), 2) AS avg_rating,
	ROUND(SUM(order_items.line_total), 2) AS total_revenue
FROM orders
JOIN order_items
ON orders.order_id = order_items.order_id
LEFT JOIN reviews
ON orders.order_id = reviews.order_id
WHERE orders.order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY orders.seller_id
HAVING
	COUNT(DISTINCT orders.order_id) >= 10
	AND AVG(reviews.rating) >= 4.0
ORDER BY total_revenue DESC
LIMIT 10;