--Q5 - CUSTOMER SPEND SEGMENTATION
--========================================================================
--Segment customers based on their total spend in 2024 into three groups;
--High spenders: >=100000 Medium spenders: 50000-99999 Low spenders: <50000.
--For each group, calculate the customer count, average spend per customer
--and total revenue contribution.
--========================================================================

SELECT
	spend_segment,
	COUNT(customer_id) AS customer_count,
	ROUND(AVG(total_spend), 2) AS avg_spend_per_customer,
	ROUND(SUM(total_spend), 2) AS total_revenue
FROM(
	SELECT
		orders.customer_id,
		SUM(order_items.line_total) AS total_spend,
		CASE
			WHEN SUM(order_items.line_total) >= 100000
		THEN 'High Spenders'
			WHEN SUM(order_items.line_total) BETWEEN 50000
				AND 99999
		THEN 'Medium Spenders'
			ELSE 'Low Spenders'
			END AS spend_segment
FROM orders
JOIN order_items
ON orders.order_id = order_items.order_id
WHERE orders.order_date BETWEEN '2024-01-01'
	AND '2024-12-31'
	GROUP BY orders.customer_id
) AS customer_spend
GROUP BY spend_segment
ORDER BY total_revenue DESC;