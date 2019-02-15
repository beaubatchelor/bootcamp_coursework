USE sakila;

-- 1a.
SELECT first_name, last_name FROM actor;
-- 1b.
ALTER TABLE actor
ADD COLUMN Actor_Name VARCHAR(80);
UPDATE actor SET Actor_Name = CONCAT(first_name, ' ', last_name);
-- 2a.
SELECT * FROM actor WHERE first_name = 'Joe';
-- 2b.
SELECT * FROM actor WHERE Actor_Name LIKE '%GEN%';
-- 2c.
SELECT * FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name;
-- 2d.
SELECT country_id, country FROM country WHERE country IN (
	'Afghanistan', 'Bangladesh', 'China'
);
-- 3a.
ALTER TABLE actor
ADD COLUMN description BLOB;
-- 3b.
ALTER TABLE actor
DROP description;
-- 4a.
SELECT last_name, COUNT(last_name) AS 'Name_Count' FROM actor GROUP BY last_name; 
-- 4b.
SELECT last_name, COUNT(last_name) AS 'Name_Count' FROM actor GROUP BY last_name 
HAVING Name_Count > 1;
-- 4C.
SELECT * FROM actor WHERE last_name = 'WILLIAMS';
UPDATE actor SET first_name = 'HARPO', Actor_Name = CONCAT(first_name," ",last_name) 
WHERE actor_id = 172;
-- 4d.
UPDATE actor SET first_name = 'GROUCHO', Actor_Name = CONCAT(first_name," ",last_name) 
WHERE first_name = 'HARPO';
-- 5a.
SHOW CREATE TABLE address;
-- 6a.
SELECT * FROM staff
INNER JOIN address
ON address.address_id = staff.address_id;
-- 6b.
CREATE VIEW 2005_sales AS
SELECT amount, payment_date, first_name, last_name FROM payment
INNER JOIN staff
ON staff.staff_id = payment.staff_id
HAVING YEAR(payment_date) = 2005;

SELECT SUM(amount), first_name, last_name FROM 2005_sales;
-- 6c.
SELECT title, COUNT(Actor_Name) FROM film_actor
INNER JOIN film
ON film.film_id = film_actor.film_id
INNER JOIN actor
ON actor.actor_id = film_actor.actor_id
GROUP BY title;
-- 6d.
SELECT COUNT(title) AS "COUNT" FROM inventory
INNER JOIN film
ON film.film_id = inventory.film_id
WHERE title = "Hunchback Impossible";
-- 6e.
SELECT first_name, last_name, SUM(amount) AS "Total Amount Paid" FROM customer
INNER JOIN payment
ON payment.customer_id = customer.customer_id
GROUP BY CONCAT(first_name, last_name)
ORDER BY last_name;
-- 7a.
SELECT * FROM film
WHERE language_id IN (
	SELECT language_id FROM language
	WHERE name = 'English'
)AND title LIKE'K%' OR title LIKE'Q%';
-- 7b
SELECT * FROM actor
WHERE actor_id IN (
	SELECT actor_id FROM film_actor
	WHERE film_id IN (
		SELECT film_id FROM film
        WHERE title = 'Alone Trip'
    )
);
-- 7c.
SELECT first_name, last_name, email FROM customer
INNER JOIN address
ON address.address_id = customer.address_id
INNER JOIN city
ON city.city_id = address.city_id
INNER JOIN country
on country.country_id = city.country_id
WHERE country = 'Canada';
-- 7d
SELECT title, name FROM film
INNER JOIN film_category
ON film_category.film_id = film.film_id
INNER JOIN category
ON category.category_id = film_category.category_id
WHERE name = 'Family';
-- 7e.
SELECT title, COUNT(rental_date) AS 'Rental_Count' FROM rental
INNER JOIN inventory
ON inventory.inventory_id = rental.inventory_id
INNER JOIN film
ON film.film_id = inventory.film_id
GROUP BY title
ORDER BY Rental_Count DESC;
-- 7f.
SELECT store_id, SUM(amount) as 'Total per Store' FROM payment
JOIN customer
ON customer.customer_id = payment.customer_id
GROUP BY store_id;
-- 7g.
SELECT store_id, city, country FROM store
JOIN address
ON address.address_id = store.address_id
JOIN city
ON city.city_id = address.city_id
JOIN country
ON country.country_id = city.country_id;
-- 7h.
SELECT name, SUM(amount) AS 'Total_Dollars' FROM payment
JOIN rental
ON rental.rental_id = payment.rental_id
JOIN inventory
ON inventory.inventory_id = rental.inventory_id
JOIN film_category
ON film_category.film_id = inventory.film_id
JOIN category
ON category.category_id = film_category.category_id
GROUP BY name 
ORDER BY Total_Dollars DESC;
-- 8a.
CREATE VIEW top_genres AS 
SELECT name, SUM(amount) AS 'Total_Dollars' FROM payment
JOIN rental
ON rental.rental_id = payment.rental_id
JOIN inventory
ON inventory.inventory_id = rental.inventory_id
JOIN film_category
ON film_category.film_id = inventory.film_id
JOIN category
ON category.category_id = film_category.category_id
GROUP BY name 
ORDER BY Total_Dollars DESC;
-- 8b.
SELECT * FROM top_genres;
-- 8c.
DROP VIEW top_genres;
