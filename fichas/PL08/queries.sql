
USE sakila;

-- Mostrar o conteúdo da tabela 'customer'
SELECT *
	FROM customer;

-- Mostrar o conteúdo da tabela 'film', ordenado por título ("title") do filme
SELECT *
	FROM film
    ORDER BY film.title ASC;

-- Listar os nomes dos atores, nome próprio e apelido, ordenados por apelido
SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS 'Actor Name', actor.first_name, actor.last_name
	FROM actor
    ORDER BY actor.last_name;

-- Apresentar uma lista com os números e datas dos alugueres ("rental_id") que foram
-- realizados entre os dias '2005/05/01' e '2005/05/31'. Apresente duas possíveis soluções.
SELECT rental_id, rental_date
	FROM rental
    WHERE rental_date BETWEEN '2005/05/01' AND '2005/05/31';

-- Indicar quantos alugueres foram realizados durante o mês de 'maio' de '2005'
SELECT COUNT(*) AS Contagem
	FROM rental
    WHERE MONTH(rental_date) = 5 AND YEAR(rental_date) = 2005;

-- Listar o número dos clientes ("customer_id") que alugaram filmes durante '2006'.
-- Apresentar a lista dos números dos clientes, sem valores repetidos.
SELECT DISTINCT customer_id AS Clientes
	FROM rental
	WHERE YEAR(rental_date) = 2006;

-- Calcular o valor total e o número de pagamentos que foram realizados até ao momento.
SELECT SUM(amount) AS 'Total', COUNT(*) AS 'Contagem'
	FROM payment
	WHERE payment_date <= NOW();

-- Calcular o valor total pago pelos clientes '1', '11', e '111', durante a última semana do
-- mês de 'dezembro' de '2005'
SELECT customer_id, SUM(amount) AS 'Total Pago'
	FROM payment
    WHERE customer_id IN (1, 11, 111)
      AND payment_date BETWEEN '2005-12-25' AND '2005-12-31'
	GROUP BY customer_id;

-- Inserir um aluguer de um filme para o cliente '1' e outro para o cliente '11'
INSERT INTO sakila.rental
	(rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
    VALUES
    ('2006-03-15', 1, 1, NULL, 1, '2007-09-10 14:30:00'),
    ('2013-10-05', 1, 11, NULL, 1, '2017-02-07 04:56:20');

-- Registar os pagamentos dos alugueres realizados na alínea anterior



-- Apresentar uma lista dos alugueres que ainda estão em curso e os respetivos
-- números dos clientes
SELECT rental_id, rental_date, customer_id
	FROM rental
    WHERE rental.return_date IS NULL;

-- Registar a entrega dos filmes que foram alugados na alínea i)



-- Criar uma vista (“vw_customer_emails”) que forneça uma lista com os nomes
-- completos dos clientes (“first_name” + “last_name”) e os seus emails. A lista deve ser
-- apresentada ordenada pelo número do cliente (“customer_id”)
SELECT CONCAT(first_name, ' ', last_name) AS Nome, email AS Email
	FROM customer AS vw_customer_emails
    ORDER BY customer_id;

-- Criar uma nova tabela (“customer_old”), com um esquema igual à da tabela
-- “customer”. De seguida, copiar para a nova tabela todos os registos dos clientes da
-- tabela “customer” que já não estejam ativos (active=0). Por fim, remover da tabela
-- “customer” os registos copiados

CREATE TABLE IF NOT EXISTS customer_old LIKE customer;

INSERT INTO customer_old
SELECT *
FROM customer
WHERE customer.active=0;

DELETE FROM customer
WHERE customer.active=0;

-- Apresentar uma lista com os nomes dos clientes (“first_name” e “last_name”) que
-- realizaram alugueres com o funcionário (“staff_id”) ‘1’.
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS Cliente
	FROM customer INNER JOIN rental ON customer.customer_id = rental.customer_id
	WHERE rental.staff_id = 1;

-- Listar os dados dos clientes cujos países sejam a ‘Itália’, a ‘Espanha’ ou a ´Grécia´
SELECT customer.*
	FROM customer INNER JOIN address ON customer.address_id = address.address_id
				  INNER JOIN city ON address.city_id = city.city_id
				  INNER JOIN country ON city.country_id = country.country_id
	WHERE country.country IN ('Itália', 'Espanha', 'Grécia');

-- Visualizar os nomes dos filmes que foram alugados durante os fins de semana de
-- ‘2005’. Ordenar a lista apresentada por título de filme.
SELECT DISTINCT film.title
	FROM film INNER JOIN inventory ON film.film_id = inventory.film_id
			  INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
	WHERE YEAR(rental.rental_date) = 2005 AND dayofweek(rental.rental_date) IN (1, 7)
	ORDER BY film.title ASC;

-- Assumindo-se que a margem de lucro dos alugueres dos filmes é de 12,5%,
-- apresentar o valor do lucro obtido pela empresa durante o ano de ‘2005’
SELECT SUM(payment.amount) * 0.125 AS Lucro
	FROM payment
	WHERE YEAR(payment.payment_date) = 2005;

-- Listar os 10 filmes mais alugados
SELECT film.*, COUNT(*) AS Contagem
	FROM film INNER JOIN inventory ON film.film_id = inventory.film_id
              INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
	GROUP BY film.film_id
    ORDER BY Contagem DESC
	LIMIT 10;

-- Listar os três melhores clientes - o clientes que mais filmes alugaram.
SELECT customer.*, COUNT(*) AS Contagem
	FROM customer INNER JOIN rental ON customer.customer_id = rental.customer_id
    GROUP BY customer.customer_id
    ORDER BY Contagem DESC
    LIMIT 3;


