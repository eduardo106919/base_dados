

USE sakila;


-- Listar os nomes dos atores (“actor”) que participaram em filmes (“film”) que forma lançados
-- (“release_year”) durante o ano de ‘2006’.
SELECT CONCAT(a.first_name, ' ', a.last_name) AS Nome
FROM actor a INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
			 INNER JOIN film f ON fa.film_id = f.film_id
WHERE YEAR(f.release_year) = 2006;


-- Fornecer uma única lista que inclua os endereços de email dos clientes (“customer”) e dos
-- funcionários (“staff”), ordenada por nome (“first_name” + “last_name”) (dos clientes e dos funcionários).
SELECT CONCAT(c.first_name, ' ', c.last_name) AS Nome, c.email AS Email
	FROM customer c
UNION
SELECT CONCAT(s.first_name, ' ', s.last_name) AS Nome, s.email AS Email
	FROM staff s
ORDER BY Nome;


-- Indicar o número total de clientes (“customer”) para cada uma das cidades (“city”) catalogadas
-- na base de dados.
SELECT ct.city_id AS ID, ct.city AS Cidade, COUNT(*) AS Contagem
FROM city ct INNER JOIN address ad ON ct.city_id = ad.city_id
			 INNER JOIN customer cm ON ad.address_id = cm.address_id
GROUP BY ct.city_id;


-- Apresentar uma lista com os títulos dos filmes (“film”) que foram alugados (“rental”) entre os
-- meses de ‘janeiro’ e ‘março’ de ‘2005’.
SELECT DISTINCT f.title AS Titulo
FROM film f INNER JOIN inventory i ON f.film_id = i.film_id
			INNER JOIN rental r ON i.inventory_id = r.inventory_id
WHERE YEAR(r.rental_date) = 2005 AND MONTH(r.rental_date) IN (1,2,3);


-- Indicar o número de filmes alugados (“rental”) por cada um dos clientes (“customer”) da
-- cidade ‘London’, durante o ano de ‘2006’.
SELECT cm.customer_id AS ID, COUNT(*) AS Contagem
FROM customer cm INNER JOIN address a ON cm.address_id = a.address_id
				 INNER JOIN city ct ON a.city_id = ct.city_id
                 INNER JOIN rental r ON cm.customer_id = r.customer_id
WHERE YEAR(r.rental_date) = 2006 AND ct.city = 'London'
GROUP BY cm.customer_id;


-- Apresentar uma lista com os nomes dos 10 melhores clientes (“customer”), em termos de
-- valor pago, durante o mês de ‘dezembro’ de ‘2005’.
SELECT c.customer_id AS ID, CONCAT(c.first_name, ' ', c.last_name) AS Nome, SUM(p.amount) AS Total
FROM customer c INNER JOIN payment p ON c.customer_id = p.customer_id
WHERE YEAR(p.payment_date) = 2005 AND MONTH(p.payment_date) IN (12)
GROUP BY ID
ORDER BY Total DESC
LIMIT 10;


-- Listar os filmes (“film”) que nunca foram alugados, com os respetivos atores. Apresente a lista
-- ordenada por ano de lançamento do filme (“release_year”).
SELECT f.title AS Titulo, fa.actor_id AS 'Actor ID'
FROM film f INNER JOIN film_actor fa ON f.film_id = fa.film_id
WHERE f.film_id NOT IN (
	SELECT f.film_id
    FROM film f INNER JOIN inventory i ON f.film_id = i.film_id
				INNER JOIN rental r ON i.inventory_id = r.inventory_id)
ORDER BY f.release_year ASC;


-- Revelar o número médio de dias de aluguer (“rental”) que os clientes da loja ‘1’ mantêm os
-- filmes em casa.
SELECT AVG(DATEDIFF(r.return_date, r.rental_date)) AS 'Média'
FROM store s INNER JOIN customer c ON s.store_id = c.store_id
			 INNER JOIN rental r ON c.customer_id = r.customer_id
WHERE s.store_id = 1;


-- Apresentar uma lista com todos os alugueres (“rental”) com os respetivos pagamentos
-- (“payment”). Incluir na lista também os alugueres que não tiveram qualquer pagamento.
SELECT r.rental_id AS Aluguer, p.payment_id AS Pagamento
	FROM rental r INNER JOIN payment p ON r.rental_id = p.rental_id
UNION
SELECT r.rental_id AS Aluguer, NULL AS Pagamento
	FROM rental r
	WHERE r.rental_id NOT IN (
		SELECT p.*
        FROM payment p
        WHERE p.rental_id IS NULL);


-- Criar uma vista que permita fornecer os nomes dos atores (“actor”), ordenados
-- alfabeticamente, dos últimos 10 filmes alugados.
CREATE VIEW vw_actors_names AS
SELECT DISTINCT CONCAT(first_name, ' ', last_name) AS Nome
FROM actor INNER JOIN film_actor USING (actor_id)
		   INNER JOIN (
				SELECT film_id
				FROM inventory INNER JOIN rental USING (inventory_id)
				ORDER BY rental_date DESC
				LIMIT 10) last_rented_movies USING (film_id)
ORDER BY Nome;

SELECT * FROM vw_actors_names;


-- Desenvolver uma instrução preparada (prepared statement) que permita inserir os dados de
-- uma nova cidade (“city”). Demonstre.
PREPARE inserir_cidade FROM
'INSERT INTO city(city, country_id, last_update) VALUES (?, ?, NOW())';

SET @city = 'Nova Cidade';
SET @country = 44;

EXECUTE inserir_cidade USING @city, @country;


-- Desenvolver uma instrução preparada utilizando a MySQL Command Line Client que permita
-- listar os filmes (“film”) que foram alugados (“rental”) por um determinado cliente. Demonstre.
PREPARE show_films_client FROM
'SELECT f.film_id AS ID, f.title AS Titulo
FROM film f INNER JOIN inventory i ON f.film_id = i.film_id
			INNER JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.customer_id = ?';

SET @customer_id = 98;
EXECUTE show_films_client USING @customer_id;

