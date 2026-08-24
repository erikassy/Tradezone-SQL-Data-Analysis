--Q3 - SELLER FULFILLMENT EFFICIENCY
--========================================================================
--Calculate the average time in hours between order placement
--and delivery for each seller. Return the top 20 sellers with
--the fastest average fulfillment times among sellers who have completed
--at least 20 orders. Include their total completed orders and average customer rating.
--========================================================================

SELECT
	orders.seller_id,
	ROUND(AVG((orders.delivery_date -
	orders.order_date) * 24), 2) AS
avg_delivery_hours,
	COUNT(orders.order_id) AS total_orders,
	ROUND(AVG(reviews.rating), 2) AS
avg_rating
FROM orders
LEFT JOIN reviews
ON orders.order_id = reviews.order_id
WHERE orders.delivery_date IS NOT NULL
AND LOWER(TRIM(orders.order_status)) = 'delivered'
GROUP BY orders.seller_id
HAVING COUNT(orders.order_id) >= 20
ORDER BY avg_delivery_hours ASC
LIMIT 20;
