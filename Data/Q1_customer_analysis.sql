--Q1 - CUSTOMER ACQUISTION AND 30-DAY CONVERSION
--========================================================================
--Find the top 5 states by number of new customer sign-ups in 2024
--For each state, calculate what percentage of these new customers
--made at least one purchase within their first 30 days of signing up.
--========================================================================


--a. new customers who signed up in 2024
SELECT customer_id, state, signup_date
FROM customers
WHERE signup_date BETWEEN '2024-01-01' AND '2024-12-31';

--b. orders made by new customers in 2024
SELECT
	c.customer_id,
	c.state,
	c.signup_date,
	o.order_date
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE c.signup_date BETWEEN '2024-01-01' AND '2024-12-31';

--c. orders made within 30 days
SELECT
	c.customer_id,
	c.state,
	c.signup_date,
	o.order_date
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
AND o.order_date <= c.signup_date + INTERVAL
'30 days'
WHERE c.signup_date BETWEEN '2024-01-01' AND '2024-12-31';

--d. conversions count
SELECT
	c.state,
	COUNT(DISTINCT c.customer_id) AS
total_signups,
	COUNT(DISTINCT CASE
		WHEN o.order_id IS NOT NULL THEN
c.customer_id
	END) AS converted_customers
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
AND o.order_date <= c.signup_date + INTERVAL
'30 days'
WHERE c.signup_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY c.state;

--e. conversion rate calculation
SELECT
	c.state,
	COUNT(DISTINCT c.customer_id) AS
total_signups,
	COUNT(DISTINCT CASE
		WHEN o.order_id IS NOT NULL THEN
c.customer_id
	END) AS converted_customers,
	ROUND(
		COUNT(DISTINCT CASE
			WHEN o.order_id IS NOT NULL THEN
c.customer_id
	END) * 100.0
	/ COUNT(DISTINCT c.customer_id),
	2) AS conversion_rate
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
AND o.order_date <= c.signup_date + INTERVAL
'30 days'
WHERE c.signup_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY c.state
ORDER BY total_signups DESC
LIMIT 5;

--END OF Q1