


USE sakila;

-- Mostrar o conteúdo da tabela “customer”.
SELECT *
FROM customer;


-- Mostrar o conteúdo da tabela “film”, ordenado por título (“title”) do filme.
SELECT *
FROM film
ORDER BY film.title;


-- Listar os nomes dos atores, nome próprio e apelido, ordenados por apelido.
SELECT CONCAT(a.first_name, ' ', a.last_name) AS Nome
FROM actor a
ORDER BY a.last_name;


-- Apresentar uma lista com os números e datas dos alugueres (“rental_id.”) que foram
-- realizados entre os dias '2005/05/01' e '2005/05/31'’. Apresente duas possíveis soluções.
SELECT r.rental_id AS Numero, r.rental_date AS 'Data'
FROM rental r
WHERE r.rental_date BETWEEN '2005/05/01' AND '2005/05/31';

SELECT r.rental_id AS Numero, r.rental_date AS 'Data'
FROM rental r
WHERE YEAR(r.rental_date) = 2005 AND MONTH(r.rental_date) = 5 AND DAY(r.rental_date) BETWEEN 1 AND 31;


-- Indicar quantos alugueres foram realizados durante o mês de ‘maio’ de ‘2005’
SELECT COUNT(*) AS Contagem
FROM rental r
WHERE YEAR(r.rental_date) = 2005 AND MONTH(r.rental_date) = 5;


-- Listar o número dos clientes (“customer_id”) que alugaram filmes durante ‘2006’.
-- Apresentar a lista dos números dos clientes, sem valores repetidos.
SELECT DISTINCT r.customer_id AS Numero
FROM rental r
WHERE YEAR(r.rental_date) = 2006;


-- Calcular o valor total e o número de pagamentos que foram realizados até ao momento.
SELECT SUM(p.amount) AS 'Valor Total', COUNT(*) AS Contagem
FROM payment p
WHERE p.payment_date <= NOW();


-- Calcular o valor total pago pelos clientes ‘1’, ‘11’, e ‘111’, durante a última semana do
-- mês de ‘dezembro’ de ‘2005’.
SELECT p.customer_id AS Numero, SUM(p.amount) AS 'Total Pago'
FROM payment p
WHERE YEAR(p.payment_date) = 2005 AND WEEK(p.payment_date) = 52 AND p.customer_id IN (1, 11, 111)
GROUP BY Numero;


-- Inserir um aluguer de um filme para o cliente ‘1’ e outro para o cliente ‘11’
INSERT INTO rental
	(rental_date, inventory_id, customer_id, staff_id)
VALUES
	('2025/02/06', 1, 1, 1),
    ('2025/03/13', 1, 11, 1);


-- Registar os pagamentos dos alugueres realizados na alínea anterior.
INSERT INTO payment
	(customer_id, staff_id, amount, payment_date)
VALUES
	(1, 1, 20.56, NOW()),
    (11, 1, 45.34, NOW());


-- Apresentar uma lista dos alugueres que ainda estão em curso e os respetivos números dos clientes
SELECT r.rental_id AS Aluguer, r.customer_id AS Cliente
FROM rental r
WHERE r.return_date IS NULL;


-- Registar a entrega dos filmes que foram alugados na alínea i)



-- Criar uma vista (“vw_customer_emails”) que forneça uma lista com os nomes
-- completos dos clientes (“first_name” + “last_name”) e os seus emails. A lista deve ser
-- apresentada ordenada pelo número do cliente (“customer_id”).
CREATE VIEW vw_customer_emails AS
	SELECT CONCAT(c.first_name, ' ', c.last_name) AS Nome, c.email AS Email
    FROM customer c
    WHERE c.email IS NOT NULL
    ORDER BY c.customer_id ASC;

SELECT * FROM vw_customer_emails;


-- Criar uma nova tabela (“customer_old”), com um esquema igual à da tabela
-- “customer”. De seguida, copiar para a nova tabela todos os registos dos clientes da
-- tabela “customer” que já não estejam ativos (active=0). Por fim, remover da tabela
-- “customer” os registos copiados.
CREATE TABLE IF NOT EXISTS customer_old LIKE customer;

SELECT *
FROM customer
WHERE customer.active IS FALSE;

INSERT INTO customer_old
	(store_id, first_name, last_name, email, address_id, active, create_date, last_update)
SELECT c.store_id, c.first_name, c.last_name, c.email, c.address_id, c.active, c.create_date, c.last_update
    FROM customer c
    WHERE c.active IS FALSE;

-- SET SQL_SAFE_UPDATES = 0;

-- apagar referências na tabela dos pagamentos
DELETE FROM payment AS p
WHERE p.customer_id IN (
	SELECT c.customer_id
    FROM customer c
    WHERE c.active IS FALSE
);

-- apagar referências na tabela dos alugueres
DELETE FROM rental AS r
WHERE r.customer_id IN (
	SELECT c.customer_id
    FROM customer c
    WHERE c.active IS FALSE
);

DELETE FROM customer
WHERE customer.active IS FALSE;


-- Apresentar uma lista com os nomes dos clientes (“first_name” e “last_name”) que
-- realizaram alugueres com o funcionário (“staff_id”) ‘1’.
SELECT CONCAT(c.first_name, ' ', c.last_name) AS Nome
FROM customer c INNER JOIN rental r ON c.customer_id = r.customer_id
WHERE r.staff_id = 1;


-- Listar os dados dos clientes cujos países sejam a ‘Itália’, a ‘Espanha’ ou a ´Grécia´.
SELECT c.*
FROM customer c INNER JOIN address a ON c.address_id = a.address_id
				INNER JOIN city ct ON a.city_id = ct.city_id
                INNER JOIN country cr ON ct.country_id = cr.country_id
WHERE cr.country IN ('Spain', 'Italy', 'Greece');


-- Visualizar os nomes dos filmes que foram alugados durante os fins de semana de
-- ‘2005’. Ordenar a lista apresentada por título de filme.
SELECT DISTINCT f.title AS Titulo
FROM film f INNER JOIN inventory i ON f.film_id = i.film_id
			INNER JOIN rental r ON i.inventory_id = r.inventory_id
WHERE DAYOFWEEK(r.rental_date) IN (1, 7)
ORDER BY f.title;


-- Assumindo-se que a margem de lucro dos alugueres dos filmes é de 12,5%,
-- apresentar o valor do lucro obtido pela empresa durante o ano de ‘2005’.
SELECT SUM(p.amount) * 1.125 AS Lucro
FROM payment p
WHERE YEAR(p.payment_date) = 2005;


-- Listar os 10 filmes mais alugados.
SELECT f.film_id AS ID, f.title AS Titulo, COUNT(*) AS Contagem
FROM film f INNER JOIN inventory i ON f.film_id = i.film_id
			INNER JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY Contagem DESC
LIMIT 10;


-- Listar os três melhores clientes – o clientes que mais filmes alugaram.
SELECT c.customer_id As ID, CONCAT(c.first_name, ' ', c.last_name) AS Nome, COUNT(*) AS NrAlugueres
FROM customer c INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY NrAlugueres DESC
LIMIT 3;


