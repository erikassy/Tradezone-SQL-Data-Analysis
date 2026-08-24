--Q6- PAYMENT METHOD PREFERENCE
--========================================================================
--By state analyse payment method preferences across each state in the dataset.
--For each state, show the transaction count and total amount for each
--payment method (Cash on Delivery, Card, Mobile Money, Bank transfer) and
--identify the most popular method per state.
--========================================================================

SELECT
	state,
	payment_method,
	transaction_count,
	total_amount,
	CASE
		WHEN transaction_count = MAX(transaction_count)
			OVER(PARTITION BY state)
				THEN 'Most Popular'
				ELSE ''
		END AS popularity_flag
FROM(
	SELECT
		customers.state,
		payments.payment_method,
		COUNT(payments.payment_id) AS transaction_count,
		SUM(payments.amount) AS total_amount
	FROM payments
	JOIN orders
	ON payments.order_id = orders.order_id
	JOIN customers
	ON orders.customer_id = customers.customer_id
	GROUP BY customers.state,
payments.payment_method
) AS payment_stats
ORDER BY state, transaction_count DESC;