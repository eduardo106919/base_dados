
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
SELECT COUNT(*) AS 'Contagem'
	FROM rental
    WHERE MONTH(rental_date) = 5 AND YEAR(rental_date) = 2005;

-- Listar o número dos clientes ("customer_id") que alugaram filmes durante '2006'.
-- Apresentar a lista dos números dos clientes, sem valores repetidos.
SELECT DISTINCT customer_id
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
	  AND MONTH(payment_date) = 12
      AND YEAR(payment_date) = 2005
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
    WHERE rental.return_date = null;

-- Registar a entrega dos filmes que foram alugados na alínea i)















