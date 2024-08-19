-- Find customers who rented the most popular film
SELECT customer_id, first_name, last_name FROM customer
WHERE customer_id IN (
	SELECT r.customer_id from rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    WHERE i.film_id =(
		SELECT i2.film_id from rental r2
        JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
        GROUP BY i2.film_id
        ORDER BY COUNT(r2.rental_id) DESC LIMIT 1
        )
	);
    
-- Find actors with more than the average number of films
SELECT a.actor_id,a.first_name,a.last_name,COUNT(fa.film_id) as NumberFilm FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id,a.first_name,a.last_name
HAVING NumberFilm > (
	SELECT AVG(NumberFilm)
    FROM (
		SELECT COUNT(fa2.film_id) AS NumberFilm FROM actor a2
        JOIN film_actor fa2 ON a2.actor_id = fa2.actor_id
        GROUP BY a2.actor_id
        ) AS Subquery
);

-- Find Films in Both 'Comedy' and 'Action' Categories
SELECT title FROM film
WHERE film_id IN (
	SELECT film_id FROM film_category 
    WHERE category_id IN (
		SELECT category_id FROM category
		WHERE name = 'Comedy' OR 'Action'
        )
	);
    
-- Subquery with EXISTS: Find Customers with No Rentals in the Last Year
-- The subquery with `EXISTS` efficiently checks if a customer has made any rentals in the past year, filtering out active customers.

SELECT customer_id, first_name, last_name FROM customer c
WHERE NOT EXISTS (
	SELECT 1 FROM rental r
    WHERE r.customer_id = c.customer_id
    AND r.rental_date >= CURDATE() - INTERVAL 1 YEAR
    );
    
-- Scalar Subquery: Calculate the Average Rental Duration
-- The subquery calculates the average rental duration, which is then displayed alongside each rental's actual duration.
SELECT rental_id,DATEDIFF(return_date,rental_date) AS rental_duration,
(SELECT AVG(DATEDIFF(return_date,rental_date)) AS avgRental_duration FROM rental)FROM rental;
