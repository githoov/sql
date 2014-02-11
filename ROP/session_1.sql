-- Let's see the entire profile table

SELECT *
FROM profile


-- Let's see the "about me" column from the profile table

SELECT about_me
FROM profile


-- Let's see the city and state from each profile

SELECT current_city, state
FROM profile


-- Return the profile information for users whose current city is Santa Cruz

SELECT *
FROM profile 
WHERE current_city = 'Santa Cruz'


-- Show the cities for states that are not California

SELECT current_city
FROM profile
WHERE state != 'CA' 		-- NOTE: WHERE state <> 'CA' does the same thing


-- Let's return 85% of everyone's income as a field and call it "Net Income"

SELECT income*0.85 as net_income
FROM profile


-- Return gross and net income

SELECT income
, income*0.85 AS net_income
FROM profile


-- Return gross and net income for people in California
SELECT income
, income*0.85 AS net_income
FROM profile
WHERE state = 'CA'


-- Aggregate functons

-- How many rows are in the profile table?

SELECT COUNT(*) 
FROM profile

-- How many distinct states are represented by all of our users?

SELECT COUNT(DISTINCT state) 
FROM profile

-- What's the total income of every one of our users?

SELECT SUM(income)
FROM profile

-- What's the total income by state?

SELECT state
  , SUM(income) AS total_income
FROM profile
GROUP BY state

-- What's the total income for each city? Present results in descending order by total city income.

SELECT current_city AS city
  , SUM(income) AS total_income
FROM profile
GROUP BY city
ORDER BY total_income DESC

-- Limit your result set above to cities in California only

SELECT current_city AS city
  , SUM(income) AS total_income
FROM profile
WHERE state = 'CA'
GROUP BY city
ORDER BY total_income DESC