/*
Let's first build a few tables to play with. 
Go to sqlfiddle.com and select a PostgreSQL version (>= 9.1).
Build the following schema.
*/

CREATE TABLE orders(
  id INT NOT NULL 
  , amount FLOAT 
);

INSERT INTO orders
VALUES(1, 200.30);

INSERT INTO orders
VALUES(2, 110.10);

INSERT INTO orders
VALUES(3, 324.00);

INSERT INTO orders
VALUES(4, 800.24);

INSERT INTO orders
VALUES(5, 88.34);

INSERT INTO orders
VALUES(6, 248.02);

INSERT INTO orders
VALUES(7, 248.02);

INSERT INTO orders
VALUES(8, 212.20);

INSERT INTO orders
VALUES(9, 100.89);


CREATE TABLE orders_alt(
  id INT NOT NULL 
  , amount FLOAT 
);

INSERT INTO orders_alt
VALUES(1, 200.30);

INSERT INTO orders_alt
VALUES(2, 110.10);

INSERT INTO orders_alt
VALUES(3, 324.00);

INSERT INTO orders_alt
VALUES(4, 800.24);

INSERT INTO orders_alt
VALUES(5, 88.34);

INSERT INTO orders_alt
VALUES(6, 248.02);

INSERT INTO orders_alt
VALUES(7, 248.02);

INSERT INTO orders_alt
VALUES(8, 212.20);


/*
APPROXIMATE MEDIAN: useful as a quick and dirty median estimate. 
However, in the event that the number of values being calculated is
even, we ought to be taking the average of the middle two values.
Failing to do so could lead to a fairly inaccurate result.
*/

SELECT MAX(amount) AS median
FROM (
      SELECT amount
        , NTILE(2) OVER(ORDER BY amount) AS bin
      FROM orders
  ) AS foo
WHERE bin = 1

/*
ACCURATE MEDIAN: so now the SQL is getting pretty intense. We
start out with a condition check: is the number of rows odd or even,
then we move on to the appropriate median calculation. When it's odd, 
the calcualtion is the same as above, in the event that it's even, we 
split the values into two groups and get the max of the lower and the min
of the upper, then average those two figures.
*/

-- Test on orders, which has an odd number of rows

SELECT
  (CASE COUNT(amount) % 2
    WHEN 1
    THEN (
      SELECT MAX(amount)
      FROM (
            SELECT amount
              , NTILE(2) OVER(ORDER BY amount) AS bin
            FROM orders
           ) AS outermost_foo
      WHERE bin = 1
    )
    ELSE (
          WITH lower_foo AS (
                            SELECT MAX(amount) AS lower
                            FROM(
                                SELECT amount
                                  , NTILE(2) OVER(ORDER BY amount) AS bin
                                FROM orders
                            ) AS first_innermost_foo
                            WHERE bin = 1
          )
          , upper_foo AS (
                            SELECT MIN(amount) AS upper
                            FROM(
                                SELECT amount
                                  , NTILE(2) OVER(ORDER BY amount) AS bin
                                FROM orders
                            ) AS second_innermost_foo
                            WHERE bin = 2
          )
          SELECT (lower + upper)/2
          FROM lower_foo, upper_foo      
    )
  END) AS median
FROM orders

-- Test on orders_alt, which has an even number of rows

SELECT
  (CASE COUNT(amount) % 2
    WHEN 1
    THEN (
      SELECT MAX(amount)
      FROM (
            SELECT amount
              , NTILE(2) OVER(ORDER BY amount) AS bin
            FROM orders_alt
           ) AS outermost_foo
      WHERE bin = 1
    )
    ELSE (
          WITH lower_foo AS (
                            SELECT MAX(amount) AS lower
                            FROM(
                                SELECT amount
                                  , NTILE(2) OVER(ORDER BY amount) AS bin
                                FROM orders_alt
                            ) AS first_innermost_foo
                            WHERE bin = 1
          )
          , upper_foo AS (
                            SELECT MIN(amount) AS upper
                            FROM(
                                SELECT amount
                                  , NTILE(2) OVER(ORDER BY amount) AS bin
                                FROM orders_alt
                            ) AS second_innermost_foo
                            WHERE bin = 2
          )
          SELECT (lower + upper)/2
          FROM lower_foo, upper_foo      
    )
  END) AS median
FROM orders_alt