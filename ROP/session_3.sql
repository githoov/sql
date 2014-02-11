-- Don't forget the LIMIT 10 at the end of your query in cases where there's no aggregate function 

1. How many unique users are there?

2. How many orders have there ever been?

3. How many unique users have placed orders?

4. How many orders are complete, pending, or have been cancelled (i.e., GROUP BY status)?

5. What is the total revenue for the store (i.e., sum of price across all order items)?

6. What are the top ten inventory items by their revenue? (hint: group by inventory_item_id; build off of question (5))

7. Return a SELECT ... LIMIT 10 of the users table, but with a new field/column that concatenates first_name, ' ', last_name as a new "name" field.

-- The following joins the users table into the orders table using a LEFT JOIN. Syntax should be FROM orders LEFT JOIN users
8. Who are the top ten users (and their names) by their number of lifetime orders? Where lifetime orders is just a count of the orders table, grouped by some
unique thing that identifies a user, such as name or user id.

-- No join on question 9
9. What do monthly orders look like since the beginning of time? (Hint: In the orders table, you want to change the date format to '%Y-%m')


Answer Key:

1. 
SELECT COUNT(*) AS number_of_users
FROM users

2. 
SELECT COUNT(*) AS number_of_orders
FROM orders

3. 
SELECT COUNT(DISTINCT user_id) AS number_of_users_with_orders
FROM orders

4. 
SELECT status
	, COUNT(*) 
FROM orders 
GROUP BY status

5. 
SELECT SUM(sale_price) AS total_revenue
FROM order_items

6.
SELECT inventory_item_id
	, SUM(sale_price) AS total_revenue
FROM order_items
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

7.
SELECT *
, CONCAT(first_name, ' ', last_name) AS name
FROM users 
LIMIT 10

8.
SELECT CONCAT(users.first_name, ' ', users.last_name) AS name
	, COUNT(*) AS lifetime_orders
FROM orders
LEFT JOIN users
ON orders.user_id = users.id
GROUP BY name
ORDER BY lifetime_orders DESC
LIMIT 10

9.
SELECT DATE_FORMAT(created_at, '%Y-%m') AS month
	, COUNT(*) AS monthly_orders
FROM orders
GROUP BY 1
ORDER BY 1 ASC


-- Additional exercises

-- Which state is associated with the largest number of orders?

SELECT u.state AS state
	, COUNT(*) AS total_orders 
FROM orders AS o
LEFT JOIN users AS u
ON o.user_id = u.id
GROUP BY 1
ORDER BY 2 DESC

-- Which state is associated with the most revenue?

SELECT u.state AS state
	, SUM(oi.sale_price) AS total_revenue 
FROM order_items AS oi
LEFT JOIN orders AS o
ON oi.order_id = o.id
LEFT JOIN users AS u
ON o.user_id = u.id
GROUP BY 1
ORDER BY 2 DESC


-- Which state is associated with the highest average order value?

SELECT u.state AS state
	, SUM(oi.sale_price) AS total_revenue
	, COUNT(o.id) AS number_of_orders 
	, SUM(oi.sale_price) / COUNT(o.id) AS average_order_value
FROM order_items AS oi
LEFT JOIN orders AS o
ON oi.order_id = o.id
LEFT JOIN users AS u
ON o.user_id = u.id
GROUP BY 1
ORDER BY 3 DESC

-- Let's use a shorthand to limit the states we look at

SELECT u.state AS state
	, SUM(oi.sale_price) AS total_revenue
	, COUNT(o.id) AS number_of_orders 
	, SUM(oi.sale_price) / COUNT(o.id) AS average_order_value
FROM order_items AS oi
LEFT JOIN orders AS o
ON oi.order_id = o.id
LEFT JOIN users AS u
ON o.user_id = u.id
WHERE u.state IN ('California', 'Texas', 'New York')
GROUP BY 1
ORDER BY 3 DESC

-- Let's get lifetime facts about users
SELECT
orders.user_id as user_id
	, COUNT(*) as lifetime_orders
	, MIN(orders.created_at) as first_order
	, MAX(orders.created_at) as latest_order
	, DATEDIFF(CURDATE(), MIN(orders.created_at)) as days_as_customer
	, DATEDIFF(CURDATE(), MAX(orders.created_at)) as days_since_last_purchase
	, COUNT(DISTINCT MONTH(orders.created_at)) as number_of_distinct_months_with_orders
FROM orders
GROUP BY user_id
LIMIT 10

-- What if we want to identify the users from this result set that have placed an order in the past day

SELECT
orders.user_id as user_id
	, COUNT(*) as lifetime_orders
	, MIN(orders.created_at) as first_order
	, MAX(orders.created_at) as latest_order
	, DATEDIFF(CURDATE(), MIN(orders.created_at)) as days_as_customer
	, DATEDIFF(CURDATE(), MAX(orders.created_at)) as days_since_last_purchase
	, COUNT(DISTINCT MONTH(orders.created_at)) as number_of_distinct_months_with_orders
FROM orders
GROUP BY user_id
HAVING days_as_customer = 1
LIMIT 10

-- Are any of these users repeat purchasers?

SELECT
orders.user_id as user_id
	, COUNT(*) as lifetime_orders
	, MIN(orders.created_at) as first_order
	, MAX(orders.created_at) as latest_order
	, DATEDIFF(CURDATE(), MIN(orders.created_at)) as days_as_customer
	, DATEDIFF(CURDATE(), MAX(orders.created_at)) as days_since_last_purchase
	, COUNT(DISTINCT MONTH(orders.created_at)) as number_of_distinct_months_with_orders
FROM orders
GROUP BY user_id
HAVING days_as_customer = 1
AND lifetime_orders > 1
LIMIT 10

-- the SUBSELECT

SELECT *
FROM users 
LEFT JOIN (
   SELECT user_id
      , MAX(created_at) AS last_order_time
   FROM orders
   GROUP BY user_id
) AS last
ON users.id = last.user_id
LIMIT 10


-- How many users placed orders and how many users total, all in one query

SELECT (
    SELECT COUNT(DISTINCT user_id)
    FROM orders) AS users_with_orders
, (
    SELECT COUNT(*)
    FROM users) AS total_users


-- How to divide these results

SELECT users_with_orders / total_users
	FROM (
		SELECT (
		    SELECT COUNT(DISTINCT user_id)
		    FROM orders) AS users_with_orders
		, (
		    SELECT COUNT(*)
		    FROM users) AS total_users
	) AS figures