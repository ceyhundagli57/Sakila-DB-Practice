-- INNER JOIN: Find all films and their actors

SELECT f.title AS FilmName, 
GROUP_CONCAT(CONCAT(a.first_name,' ',a.last_name) ORDER BY a.first_name ASC SEPARATOR ',') AS ActorName  
FROM film_actor fa
INNER JOIN film f ON fa.film_id = f.film_id
INNER JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY FilmName
ORDER BY FilmName, ActorName;

-- LEFT JOIN: Find all customers who haven’t rented
-- Every customers rented on Sakila DB to see more clear for this example you can add customer
-- INSERT INTO customer (first_name,last_name,store_id,address_id) VALUES ('MIKE', 'JERSEY',1,1);

SELECT CONCAT(c.first_name,' ',c.last_name) AS CustomerName, GROUP_CONCAT( r.rental_id  SEPARATOR ',') 
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
WHERE r.customer_id IS NULL
GROUP BY CustomerName
ORDER BY CustomerName;

-- RIGHT JOIN : List all film categories and the films within each category, excluding categories with no films
-- every categories have films for Sakila DB if you want you can add category without attaching film to see more clear
-- INSERT INTO category(name) VALUES ('Anime');

SELECT c.name as CategoryName, GROUP_CONCAT(f.title ORDER BY f.title ASC SEPARATOR ',') AS Films   FROM category c 
RIGHT JOIN film_category fc ON c.category_id = fc.category_id
RIGHT JOIN film f ON fc.film_id = f.film_id
WHERE f.film_id IS NOT NULL
GROUP BY CategoryName
ORDER BY CategoryName;

-- SELF JOIN: Find actors who share the same last name

SELECT a1.actor_id, a1.first_name, a1.last_name, a2.actor_id,a2.first_name,a2.last_name FROM actor a1
INNER JOIN actor a2 ON a1.last_name = a2.last_name AND  a1.actor_id < a2.actor_id 
ORDER BY a1.last_name, a1.first_name, a2.first_name;

-- JOIN with Aggregation: Find the top 5 actors who have acted in the most films

SELECT CONCAT(a.first_name, ' ' ,a.last_name) AS ActorName, COUNT(film_id) AS FilmNumber FROM film_actor fa
JOIN  actor a ON fa.actor_id = a.actor_id
GROUP BY a.actor_id
ORDER BY FilmNumber DESC LIMIT 5;

-- JOIN with Subquery: Find all films that are in the top 3 most popular categories
SELECT f.title, c.name FROM film f 
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN(
	SELECT category_id FROM film_category
    GROUP BY category_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 3) AS PopularCategory
    ON c.category_id = PopularCategory.category_id
ORDER BY c.name, f.title;

-- CONDITIONAL JOIN: Find films rented in 2005 and classify them as 'Early' or 'Late' based on the rental date

SELECT f.title, r.rental_date, 
	CASE
		WHEN MONTH(r.rental_date) < 7 THEN 'Early 2005'
        ELSE 'Late 2005'
	END AS rent_period
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE YEAR(r.rental_date) = 2005;

-- JOIN WITH WINDOW FUNCTION: Rank films within each category by their rental frequency
-- rental count id

SELECT c.name AS CategoryName, f.title AS FilmName, COUNT(r.rental_id) AS NumberRent  FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY CategoryName,FilmName


