--Q7

SELECT
	rating_category,
	COUNT(DISTINCT products.product_id) AS product_count,
	ROUND(SUM(order_items.line_total), 2) AS total_revenue,
	ROUND(AVG(products.unit_price), 2) AS avg_unit_price
FROM(
	SELECT
		products.product_id,
		products.unit_price,
		CASE
			WHEN AVG(reviews.rating) >= 4
				THEN 'High Rated'
			WHEN AVG(reviews.rating) BETWEEN 3 AND 3.99
				THEN 'Mid Rated'
				ELSE 'Low Rated'
			END AS rating_category
	FROM products
	LEFT JOIN reviews
	ON products.product_id = reviews.product_id
	GROUP BY products.product_id, products.unit_price)
		AS rated_products
LEFT JOIN order_items
ON rated_products.product_id = order_items.product_id
JOIN products
ON rated_products.product_id = products.product_id
GROUP BY rating_category
ORDER BY total_revenue DESC;