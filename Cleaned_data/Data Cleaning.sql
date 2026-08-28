-- Data Cleaning

-- 1. Remove Missing Values
-- 2. Remove Duplicate Records
-- 3. Standardize Formats

--========================
--CUSTOMERS CLEANING
--========================
-- MISSING VALUES
SELECT *
FROM customers
WHERE email IS NULL OR city IS NULL;

UPDATE customers
SET email = 'unknown@email.com'
WHERE email IS NULL;
--Replaced NULL emails with placeholder to preserve order history

--DUPLICATES
SELECT first_name, last_name, email, city, state, signup_date,customer_id,COUNT(*)
FROM customers
GROUP BY first_name, last_name, email, city, state, signup_date, customer_id
HAVING COUNT(*) > 1;
--checked for duplicate full-row duplicates: none found

--STANDARDIZING FORMATS
--city names
UPDATE customers
SET city = INITCAP(city);
UPDATE customers
SET city = 'Lagos'
WHERE city ILIKE 'lago%';
--found inconsistent and misspelled entrie such as 'Lago S' and ensured uniform analysis

--state
UPDATE customers
SET state = INITCAP(state);

--dates
SELECT order_date::DATE
FROM orders;

--cross-check
SELECT *
FROM customers;


--========================
--ORDERS CLEANING
--========================
-- MISSING VALUES
SELECT *
FROM orders
WHERE order_id IS NULL
	OR customer_id IS NULL
	OR order_date IS NULL
	OR order_date IS NULL
	OR total_amount IS NULL;

SELECT *
FROM orders
WHERE delivery_date IS NULL OR total_amount IS NULL;

UPDATE orders o
SET total_amount = sub.total
FROM (
	SELECT order_id, SUM(line_total) AS total
	FROM order_items
	GROUP BY order_id
) sub
WHERE o.order_id = sub.order_id
	AND (o.total_amount IS NULL
OR o.total_amount <> sub.total); -- reconstructed missing order revenue using order_items

--dates
SELECT delivery_date::DATE
FROM orders;
--missing delivery_dates values were not replaced

--cross-check
SELECT *
FROM orders;


-- removed because financial data must be valid
DELETE FROM payments
WHERE amount IS NULL; 


--STANDARDIZING FORMAT
--category
UPDATE products
SET category = INITCAP(category);

--========================
--SELLERS CLEANING
--========================
--MISSING VALUES
SELECT*
FROM sellers
WHERE seller_id IS NULL
	OR seller_name IS NULL
	OR onboarding_date IS NULL
	OR product_category IS NULL
	OR city IS NULL
	OR state IS NULL
	OR account_status IS NULL;

--DUPLICATES
SELECT seller_id, COUNT(*)
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1; --no duplicates found

--STANDARDIZING FORMAT
--product_category
UPDATE sellers
SET product_category = INITCAP(product_category);

UPDATE sellers
SET city = INITCAP(city);

UPDATE sellers
SET city = 'Lagos'
WHERE city ILIKE 'lago%';
--found inconsistent and misspelled entrie such as 'Lago S' and ensured uniform analysis

--state
UPDATE sellers
SET state = INITCAP(state);

--dates
SELECT onboarding_date::DATE
FROM sellers;

--cross-check
SELECT *
FROM sellers;


--flagged ordered where difference exceeds 10
--validated order totals against order_items
SELECT
	o.order_id,
	o.total_amount,
	SUM(oi.line_total) AS calculated_total,
	ABS(o.total_amount - SUM(oi.line_total))
	AS difference
	FROM orders o
	JOIN order_items oi
	ON o.order_id = oi.order_id
	GROUP BY o.order_id, o.total_amount
	HAVING ABS(o.total_amount -
	SUM(oi.line_total)) > 10; 
	

--checked review for invalid ratings
SELECT *
FROM reviews
WHERE rating < 1
	OR rating > 5;

--removed invalid review ratings outside 1-5 range
DELETE FROM reviews
WHERE rating < 1 OR rating > 5;


--negative product prices
SELECT *
FROM products
WHERE unit_price < 0;
-- no negative prices found

--missing unit_price handled using imputation to preserve product records
UPDATE order_items
SET unit_price = (
	SELECT AVG(unit_price)
	FROM order_items
)
WHERE unit_price IS NULL; --replaced missing unit_prices using average

--missing line_total reconstructed
UPDATE order_items
SET line_total = quantity * unit_price
WHERE line_total IS NULL; --replaced missing line_total using quantity * unit_price

--END OF DATA CLEANING