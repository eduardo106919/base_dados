


USE sakila;


-- Implemente um procedimento que receba o identificador (“customer_id”) de um cliente e
-- forneça uma lista com a informação de todos os alugueres (“rental”) feitos por esse cliente,
-- ordenada de forma decrescente por data de aluguer (“rental_date”).
DROP PROCEDURE IF EXISTS pc_client_rentals;

DELIMITER &&
CREATE PROCEDURE pc_client_rentals(IN client_id INT)
BEGIN
	SELECT r.rental_id AS ID, r.rental_date AS 'Data'
    FROM rental r
    WHERE r.customer_id = client_id
    ORDER BY r.rental_date DESC;
END &&
DELIMITER ;

CALL pc_client_rentals(67);
CALL pc_client_rentals(90);
CALL pc_client_rentals(135);


-- Desenvolva uma função que receba o identificador de um filme (“film_id”) e forneça o preço
-- do seu aluguer. Assuma que esse valor está armazenado no atributo “replacement_cost” na
-- tabela “film”.
DROP FUNCTION IF EXISTS fc_film_price;

DELIMITER &&
CREATE FUNCTION fc_film_price(movie_id INT)
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
	DECLARE val DECIMAL(5,2);
    SELECT f.replacement_cost INTO val
    FROM film f
    WHERE f.film_id = movie_id;
	RETURN val;
END &&
DELIMITER ;

SELECT fc_film_price(67);
SELECT fc_film_price(34);
SELECT fc_film_price(298);


-- Modifique os esquemas das tabelas “customer” e “film”, acrescentando a cada uma delas o
-- atributo “NrAlugueres”. De seguida, crie na tabela “rental” um gatilho que atue sempre que
-- seja registado um novo aluguer, incrementando o valor dos atributos agora criados, nas
-- respetivas tabelas.
ALTER TABLE customer
	ADD COLUMN NrAlugueres INT NOT NULL DEFAULT 0;

-- ALTER TABLE customer DROP COLUMN NrAlugueres;

ALTER TABLE film
	ADD COLUMN NrAlugueres INT NOT NULL DEFAULT 0;

-- ALTER TABLE film DROP COLUMN NrAlugueres;

-- SET SQL_SAFE_UPDATES = 0;

UPDATE customer c
SET NrAlugueres = (SELECT COUNT(r.rental_id)
				  FROM rental r
                  WHERE r.customer_id = c.customer_id);

UPDATE film f
SET NrAlugueres = (SELECT COUNT(r.rental_id)
				   FROM rental r INNER JOIN inventory i ON r.inventory_id = i.inventory_id
				   WHERE i.film_id = f.film_id);

DELIMITER &&
CREATE TRIGGER tg_update_rental_count
AFTER INSERT ON rental FOR EACH ROW
BEGIN
	UPDATE customer c
		SET NrAlugueres = NrAlugueres + 1
        WHERE c.customer_id = NEW.customer_id;
	UPDATE film f
		SET NrAlugueres = NrAlugueres + 1
        WHERE f.film_id IN (SELECT i.film_id
							FROM inventory i
                            WHERE i.inventory_id = NEW.inventory_id);
END &&
DELIMITER ;


-- Remova o gatilho desenvolvido na alínea anterior. De seguida, desenvolva um procedimento
-- que faça o registo de um novo aluguer na tabela “rental” e, com os dados desse novo registo,
-- incremente o valor do atributo “NrAlugueres” nas tabelas “customer” e “film”,
-- respetivamente. Na implementação deste procedimento deve utilizar transações
DROP TRIGGER IF EXISTS tg_update_rental_count;

DELIMITER &&
CREATE PROCEDURE pc_insert_rental(IN inventory INT, IN customer INT, IN staff INT)
BEGIN
	DECLARE EXIT HANDLER FOR sqlexception ROLLBACK;
    START TRANSACTION;
    INSERT INTO rental
		(rental_date, inventory_id, customer_id, staff, last_update)
	VALUES
		(NOW(), inventory, customer, staff_id, NOW());
	UPDATE customer c SET NrAlugueres = NrAlugueres + 1
		WHERE c.customer_id = customer;
    UPDATE film f SET NrAlugueres = NrAlugures + 1
		WHERE f.film_id IN (SELECT film_id FROM inventory WHERE inventory_id = inventory);

	COMMIT;
END &&
DELIMITER ;


-- Implemente um procedimento para atribuição de “pontos de desconto” aos clientes da
-- “Sakila”. Quando executado, o procedimento deve carregar para um cursor o valor dos últimos
-- 50 pagamentos (“payment”) de alugueres, agrupados por identificador de cliente
-- (“customer_id”), e, para cada um desses clientes calcular os “pontos de desconto” a tribuir –
-- 1 ponto por cada 2,50$ pago. No final, o procedimento deve apresentar uma lista com o nome
-- dos clientes e os pontos que lhe foram atribuídos – a lista deve ser apresentada ordenada de
-- forma crescente por nome de cliente.








