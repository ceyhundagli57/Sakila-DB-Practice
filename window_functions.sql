-- Rank films by the number of rentals and show the top 3 films.
WITH RankedFilms AS(
	SELECT f.film_id,f.title, COUNT(r.rental_id) AS rental_count,
    RANK () OVER (ORDER BY COUNT(r.rental_id) DESC ) as rental_rank
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY f.film_id, f.title
    )
SELECT film_id, title, rental_count,rental_rank FROM RankedFilms
WHERE rental_rank <=3;
    
-- Calculate cumulative sales for each film category.
SELECT c.name,p.amount,p.payment_date, 
SUM(p.amount) OVER(PARTITION BY c.name ORDER BY p.payment_date) AS cumulative_payment
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id;


-- Calculate running total of payments by date.
SELECT DATE(payment_date) AS payment_day,
SUM(amount) FROM payment
GROUP BY payment_day
ORDER BY payment_day;

-- List the top 5 customers by total payments.
SELECT c.customer_id, c.first_name, c.last_name,
SUM(amount) AS total_payment,
ROW_NUMBER() OVER(ORDER BY SUM(amount) DESC ) AS payment_rank 
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
LIMIT 5;

-- Rank films by rental frequency, allowing ties.
-- This query ranks films based on how frequently they've been rented, but ensures that films with the same number of rentals receive the same rank.

SELECT f.film_id, f.title,COUNT(r.rental_id) AS rental_count,
DENSE_RANK () OVER (ORDER BY COUNT(r.rental_id) ) AS rental_rank
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY rental_rank