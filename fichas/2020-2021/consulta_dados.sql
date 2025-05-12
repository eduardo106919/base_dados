
USE sakila;


SELECT *
FROM customer;


SELECT c.email
FROM customer c
WHERE C.last_name IN ('Smith', 'Moore');


SELECT c.customer_id AS Id, CONCAT(c.first_name, ' ', c.last_name) AS Nome, c.email AS Email
FROM customer c
ORDER BY Email ASC;


SELECT f.title
FROM film f
WHERE f.language_id = 1 AND f.release_year IN (2005, 2006);


SELECT r.rental_date
FROM customer c INNER JOIN rental r ON c.customer_id = r.customer_id
WHERE c.customer_id = 10;


SELECT c.customer_id AS Id, COUNT(*) AS NrAlugueres, AVG(p.amount) AS Media
FROM payment p INNER JOIN rental r ON p.rental_id = r.rental_id
			   INNER JOIN customer c ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY Media DESC
LIMIT 5;


SELECT COUNT(*) AS Contagem
FROM rental r
WHERE YEAR(r.rental_date) = 2006;


SELECT f.*
FROM film f INNER JOIN inventory i ON f.film_id = i.film_id
			INNER JOIN rental r ON r.inventory_id = i.inventory_id
WHERE YEAR(r.rental_date) = 2005 AND WEEK(r.rental_date) = 25;



SELECT f.film_id, SUM(p.amount) AS Lucro, COUNT(*) AS Contagem
FROM film f INNER JOIN inventory i
				ON f.film_id = i.film_id
			INNER JOIN rental r
				ON i.inventory_id = r.inventory_id
			INNER JOIN payment p
				ON r.rental_id = p.rental_id
WHERE f.film_id IN (1,2,3,4)
GROUP BY f.film_id;
