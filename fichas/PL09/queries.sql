

USE sakila;

-- Listar os nomes dos atores (“actor”) que participaram em filmes (“film”) que forma lançados
-- (“release_year”) durante o ano de ‘2006’
SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS Nome
	FROM actor INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
			   INNER JOIN film ON film.film_id = film_actor.film_id
	WHERE film.release_year = 2006;

-- Fornecer uma única lista que inclua os endereços de email dos clientes (“customer”) e dos
-- funcionários (“staff”), ordenada por nome (“first_name” + “last_name”) (dos clientes e dos funcionários).
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
	FROM film INNER JOIN inventory ON film.film_id = inventory.film_id
			  INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
	WHERE YEAR(rental.rental_date) = 2005
	  AND MONTH(rental.rental_date) IN (1, 3);

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
-- valor pago, durante o mês de ‘dezembro’ de ‘2005’
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS Nome, SUM(payment.amount) AS Valor
	FROM customer INNER JOIN payment ON customer.customer_id = payment.customer_id
	WHERE YEAR(payment.payment_date) = 2005 -- AND MONTH(payment.payment_date) = 12
    GROUP BY Nome
    ORDER BY Valor DESC
    LIMIT 10;

-- Listar os filmes (“film”) que nunca foram alugados, com os respetivos atores. Apresente a lista
-- ordenada por ano de lançamento do filme (“release_year”).
SELECT film.film_id, actor.actor_id
	FROM film INNER JOIN film_actor ON film.film_id = film_actor.film_id
			  INNER JOIN actor ON film_actor.actor_id = actor.actor_id
	WHERE film.film_id NOT IN (
		-- Selecionar os film_ids que foram alugados
		SELECT inventory.film_id
			FROM inventory INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
		)
	ORDER BY film.release_year ASC;

-- Revelar o número médio de dias de aluguer (“rental”) que os clientes da loja ‘1’ mantêm os
-- filmes em casa.
SELECT customer.customer_id AS Cliente, AVG(DATEDIFF(rental.return_date, rental.rental_date)) AS Media
	FROM store INNER JOIN customer ON store.store_id = customer.store_id
			   INNER JOIN rental ON customer.customer_id = rental.customer_id
	WHERE store.store_id = 1
    GROUP BY customer.customer_id;

-- Apresentar uma lista com todos os alugueres (“rental”) com os respetivos pagamentos
-- (“payment”). Incluir na lista também os alugueres que não tiveram qualquer pagamento
SELECT rental.rental_id AS Aluguer, NULL AS Pagamento
	FROM rental INNER JOIN payment ON rental.rental_id = payment.rental_id
	WHERE payment.rental_id IS NULL
UNION
SELECT rental.rental_id AS Aluguer, payment.payment_id AS Pagamento
	FROM rental INNER JOIN payment ON rental.rental_id = payment.rental_id
	WHERE payment.rental_id IS NOT NULL;

-- Criar uma vista que permita fornecer os nomes dos atores (“actor”), ordenados
-- alfabeticamente, dos últimos 10 filmes alugados.

-- dados que são calculados e não armazenados
CREATE VIEW ww AS
SELECT DISTINCT CONCAT(first_name, ' ', last_name)
AS nome
FROM actor
INNER JOIN film_actor USING (actor_id)
INNER JOIN (
	SELECT film_id
    FROM inventory
    INNER JOIN rental USING (inventory_id)
    ORDER BY rental_date DESC
    LIMIT 10) last_rented_movies USING (film_id)
ORDER BY nome;


-- query usada muitas vezes e que tem variedade de valores
-- tenho de usar plicas sempre
PREPARE inserir_cidade FROM
'INSERT INTO city(city, country_id, last_update) VALUES (?, ?, NOW())';

SET @city = 'Nova Cidade';
SET @country = 44;

EXECUTE inserir_cidade USING @city, @country;





