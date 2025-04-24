

USE sakila;

-- Listar os nomes dos atores (“actor”) que participaram em filmes (“film”) que forma lançados
-- (“release_year”) durante o ano de ‘2006’
SELECT *
	FROM actor
		INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
		INNER JOIN film ON film.film_id = film_actor.film_id
	WHERE film.release_year = 2006;

-- Fornecer uma única lista que inclua os endereços de email dos clientes (“customer”) e dos
-- funcionários (“staff”), ordenada por nome (“first_name” + “last_name”) (dos clientes e dos
-- funcionários).
-- TO DO

SELECT customer.email, CONCAT(customer.first_name, ' ', customer.last_name) AS Nome
	FROM customer
UNION
SELECT staff.email, CONCAT(staff.first_name, ' ', staff.last_name) AS Nome
	FROM staff
ORDER BY Nome ASC;

-- Indicar o número total de clientes (“customer”) para cada uma das cidades (“city”) catalogadas
-- na base de dados.
SELECT COUNT(*) AS 'Nr Customers', city.city
	FROM city INNER JOIN address ON city.city_id = address.city_id
		      INNER JOIN customer ON address.address_id = customer.address_id
	GROUP BY city.city;

-- Apresentar uma lista com os títulos dos filmes (“film”) que foram alugados (“rental”) entre os
-- meses de ‘janeiro’ e ‘março’ de ‘2005’
SELECT film.title
	FROM film
		INNER JOIN inventory ON film.film_id = inventory.film_id
        INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
	WHERE YEAR(rental.rental_date) = 2005 AND (MONTH(rental.rental_date) = 1 OR MONTH(rental.rental_date) = 3);

-- Indicar o número de filmes alugados (“rental”) por cada um dos clientes (“customer”) da
-- cidade ‘London’, durante o ano de ‘2006’
SELECT COUNT(*) AS 'Nr films', customer.customer_id
	FROM film
    INNER JOIN inventory ON film.film_id = inventory.film_id
    INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
    INNER JOIN customer ON rental.customer_id = customer.customer_id
    INNER JOIN address ON customer.address_id = address.address_id
    INNER JOIN city ON address.city_id = city.city_id
	WHERE YEAR(rental.rental_date) = 2006 AND city.city = 'London'
    GROUP BY customer.customer_id;

-- Apresentar uma lista com os nomes dos 10 melhores clientes (“customer”), em termos de
-- valor pago, duramte o mês de ‘dezembro’ de ‘2005’
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS Nome, SUM(payment.amount) AS Valor
	FROM customer INNER JOIN payment ON customer.customer_id = payment.customer_id
	WHERE YEAR(payment.payment_date) = 2005 -- AND MONTH(payment.payment_date) = 12
    GROUP BY Nome
    ORDER BY Valor DESC
    LIMIT 10;

-- Listar os filmes (“film”) que nunca foram alugados, com os respetivos atores. Apresente a lista
-- ordenada por ano de lançamento do filme (“release_year”).



-- Revelar o número médio de dias de aluguer (“rental”) que os clientes da loja ‘1’ mantêm os
-- filmes em casa.








