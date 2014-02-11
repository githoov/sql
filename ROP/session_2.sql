-- DATE OPERATIONS


-- Let's take another look at our Facebook profiles

SELECT *
FROM profile

/*
 We use the WHERE clause to restrict the rows that we return. Suppose we want to only return users 
 who were born between 1983 and 1990.
 */

SELECT *
FROM profile
WHERE birthday >= '1983' AND birthday <= '1990'

/*
Implicitly, this is saying "having been born between 1983-01-01 and 1990-01-01",
but we're actually interested in seeing users born between 1983 and 1990, with inclusive results.
To do this, we can extract the year from everyone's birthdate.
*/

SELECT *, EXTRACT(year FROM birthday) AS birth_year
FROM profile

/*
The following throws an error. We canot reference an alias in a WHERE clause, 
as SQL is often executed in reverse order. The aliased birth_year does not yet exist.
*/

SELECT *, EXTRACT(year FROM birthday) AS birth_year
FROM profile
WHERE birth_year >= '1983' AND birth_year <= '1990'

-- So we must write it out in a lengthy manner

SELECT *, EXTRACT(year FROM birthday) AS birth_year
FROM profile
WHERE EXTRACT(year FROM birthday) >= '1983' AND EXTRACT(year FROM birthday) <= '1990'

/*
However, we can shorten the WHERE syntax with a BETWEEN statement, which is
useful for evaluating conditinal statements on some INTERVAL.
*/

SELECT *, EXTRACT(year FROM birthday) AS birth_year
FROM profile
WHERE EXTRACT(year FROM birthday) BETWEEN '1983' AND '1990'


-- Let's get the birth month from these birth_dates.

SELECT *, EXTRACT(month FROM birthday) AS birth_month
FROM profile

-- What's the distribution of birth month?

SELECT COUNT(*) AS occurrences
	, EXTRACT(month FROM birthday) AS birth_month
FROM profile
GROUP BY birth_month
ORDER BY 1 DESC

-- What if we want to know the day and month of people's birthdays, irrespective of year?

SELECT *, DATE_FORMAT(birthday, '%m-%d') AS recurring_birthday
FROM profile

-- There are many arguments for the date format. Here's a more intuitive day-month combination.

SELECT *, DATE_FORMAT(birthday, '%M %D') AS recurring_birthday
FROM profile

-- What if we want to add some time interval to a date field, like to find someone's half birthday.

SELECT birthday
	, birthday + INTERVAL 6 month AS half_birth_date
FROM profile

-- Alternatively, ...

SELECT birthday
	, DATE_ADD(birthday, INTERVAL 6 MONTH) AS half_birth_date
FROM profile

-- How about if we want to see how many days until someone's birthday?

SELECT birthday
	, CONCAT('2014-', EXTRACT(month FROM birthday), '-', EXTRACT(day FROM birthday)) AS birthday_this_year
	, NOW() AS today
	, DATEDIFF(CONCAT('2014-', EXTRACT(month FROM birthday), '-', EXTRACT(day FROM birthday)), NOW()) AS days_to_birthday
FROM profile

-- Alternatively, ...

SELECT birthday
	, DAYOFYEAR(birthday) AS birth_day_of_year
	, DAYOFYEAR(NOW()) AS today_day_of_year
	, DAYOFYEAR(birthday) - DAYOFYEAR(NOW()) AS days_to_birthday
FROM profile


-- JOINS

-- Let's see status updates and user information for all users that have had a status updates

SELECT *
FROM status AS a
INNER JOIN alt_user AS u
ON a.user_id = u.id

-- using the alt_users table, we only get info on two users' updates

/*
A FULL OUTER JOIN will give us a union of these two tables——no redundant rows.
MySQL doesn't have a command for this, so we need to hack it.
*/

SELECT *
FROM status AS a
LEFT OUTER JOIN alt_user AS u
ON a.user_id = u.id
UNION
SELECT *
FROM status AS a
RIGHT OUTER JOIN alt_user AS u
ON a.user_id = u.id

/* 
Just to make things more difficult, UNION in SQL isn't quite the same as a union in set theory. 
UNION in SQL basically allows one to stack result sets.
*/

/*
The LEFT OUTER JOIN is the go-to join in SQL. We start from a base table, in our case, status.
We then bring in information from a table of interest, alt_user. In the case that there is no
intersection in the joining key or field, a NULL value is returned for the table being joined in.
*/

SELECT *
FROM status AS a
LEFT OUTER JOIN alt_user AS u
ON a.user_id = u.id

-- A RIGHT OUTER JOIN returns the opposite of a LEFT OUTER JOIN

SELECT *
FROM status AS a
RIGHT OUTER JOIN alt_user AS u
ON a.user_id = u.id

/*
With the RIGHT OUTER JOIN every row from the right table——the table being joined in——will be return at least once. 
In the case that there is no intersection in the joining key or field, a NULL value is returned for the left table.
*/

/*
At the end of last class, we posed the problem: "return the status id, created date, status message, 
and user id provided that it was the user's first status updated"
*/

SELECT *
FROM status AS s
INNER JOIN (
  SELECT user_id
    , status_message
    , MIN(created_date) AS created_date
  FROM status
  GROUP BY 1
) AS m
ON s.user_id = m.user_id
WHERE s.created_date = m.created_date

-- Now, if we want to pull in all of the data about the users, as well as their profile information

SELECT *
FROM status AS s
LEFT JOIN user AS u
ON u.id = s.user_id
LEFT JOIN profile AS p
ON u.profile_id = p.id
INNER JOIN (
  SELECT user_id
    , status_message
    , MIN(created_date) AS created_date
  FROM status
  GROUP BY 1
) AS m
ON s.user_id = m.user_id
WHERE s.created_date = m.created_date
