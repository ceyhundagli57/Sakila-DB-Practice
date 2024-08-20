-- Calculate the top 5 customers by total payments.
WITH CustomerPayment AS(
	SELECT customer_id,first_name, last_name,
    SUM(p.amount) AS total_payment FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY customer_id, first_name, last_name
    ORDER BY total_payment )

SELECT customer_id,first_name,last_name, total_payment FROM CustomerPayment
ORDER BY total_payment DESC
LIMIT 5;

-- Calculate the top 5 customers by total payments.
WITH CustomerPayments AS (
    SELECT customer_id, 
           first_name, 
           last_name, 
           SUM(amount) AS total_payment
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY customer_id, first_name, last_name
)
SELECT customer_id, first_name, last_name, total_payment
FROM CustomerPayments
ORDER BY total_payment DESC
LIMIT 5;

--  Find customers who rented films in both 2005 and 2006.
WITH Rentals2005 AS (
	SELECT customer_id FROM rental 
    WHERE YEAR(rental_date)  = 2005
),
Rentals2006 AS (
	SELECT customer_id FROM rental 
    WHERE YEAR(rental_date)  = 2006
)
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN Rentals2005 r2005 ON c.customer_id = r2005.customer_id
JOIN Rentals2006 r2006 ON c.customer_id = r2006.customer_id;

    
