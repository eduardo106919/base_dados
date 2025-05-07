

USE sakila;


-- Implemente um procedimento que receba o identificador (“customer_id”) de um cliente e
-- forneça uma lista com a informação de todos os alugueres (“rental”) feitos por esse cliente,
-- ordenada de forma decrescente por data de aluguer (“rental_date”).

DELIMITER //
CREATE PROCEDURE get_customer_rentals (IN customer INT)
BEGIN
	SELECT *
    FROM rental
    WHERE rental.customer_id = customer
    ORDER BY rental.rental_date DESC;
END //
DELIMITER ;

CALL get_customer_rentals(1);
CALL get_customer_rentals(30);
CALL get_customer_rentals(89);


-- Desenvolva uma função que receba o identificador de um filme (“film_id”) e forneça o preço
-- do seu aluguer. Assuma que esse valor está armazenado no atributo “replacement_cost” na
-- tabela “film”.

-- DROP FUNCTION IF EXISTS rental_price;

DELIMITER $$
CREATE FUNCTION rental_price (film INT)
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
	/*
    DECLARE val DECIMAL(5,2);
    SELECT replacement_cost INTO val
    FROM film
    WHERE film_id = film;
    RETURN val;
    */
	RETURN (SELECT replacement_cost FROM film WHERE film_id = film);
END $$
DELIMITER ;

SELECT rental_price(1);
SELECT rental_price(90);
SELECT rental_price(213);


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

-- desligar os safe updates
-- SET SQL_SAFE_UPDATES = 0;

UPDATE customer SET NrAlugueres = (SELECT COUNT(rental_id)
								   FROM rental
                                   WHERE customer.customer_id = rental.rental_id
								  );

UPDATE film f SET NrAlugueres = (SELECT COUNT(rental_id)
								   FROM rental r INNER JOIN inventory i ON r.inventory_id = i.inventory_id
                                   WHERE f.film_id = i.film_id
								);

DELIMITER &&
CREATE TRIGGER update_rentals_counter 
	AFTER INSERT
    ON rental FOR EACH ROW
    BEGIN
		UPDATE customer SET NrAlugueres = NrAlugueres + 1 WHERE customer.customer_id = NEW.customer_id;
        UPDATE film SET NrAlugueres = NrAlugueres + 1 WHERE film.film_id IN (SELECT film_id
																			 FROM inventory i
                                                                             WHERE i.inventory_id = NEW.inventory_id);
    END &&
DELIMITER ;


-- Remova o gatilho desenvolvido na alínea anterior. De seguida, desenvolva um procedimento
-- que faça o registo de um novo aluguer na tabela “rental” e, com os dados desse novo registo,
-- incremente o valor do atributo “NrAlugueres” nas tabelas “customer” e “film”,
-- respetivamente. Na implementação deste procedimento deve utilizar transações.
DROP TRIGGER update_rentals_counter;

DELIMITER &&
CREATE PROCEDURE sp_new_rental(IN inventory INT, IN customer INT, IN staff INT)
BEGIN
	DECLARE EXIT HANDLER FOR sqlexception ROLLBACK;
    START TRANSACTION;
    INSERT INTO rental(rental_date, inventory_id, customer_id, staff_id, last_update)
    VALUES (NOW(), inventory, customer, staff, NOW());
    
    UPDATE customer c SET NrAlugueres = NrAlugueres + 1 WHERE c.customer_id = customer;
    UPDATE film f SET NrAlugueres = NrAlugures + 1 WHERE f.film_id IN (SELECT film_id FROM inventory WHERE inventory_id = inventory);
    COMMIT;
END &&
DELIMITER ;

-- Criar um evento que permita transferir todos os dias, às 23:00, os dados contidos na tabela
-- “rental” para a tabela “alugueres” (com esquema igual à tabela “rental”) localizada na base de
-- dados “SakilaPt”.
CREATE SCHEMA SakilaPt;
USE SakilaPt;
CREATE TABLE Alugueres LIKE sakila.rental;

SET GLOBAL event_scheduler = ON;

-- DROP EVENT e_rental_copy;

DELIMITER &&
CREATE EVENT e_rental_copy
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '23:00:00')
DO
BEGIN
	INSERT INTO sakilaPt.alugueres
	SELECT * FROM sakila.rental;
END &&
DELIMITER ;


-- Implemente um procedimento para atribuição de “pontos de desconto” aos clientes da
-- “Sakila”. Quando executado, o procedimento deve carregar para um cursor o valor dos últimos
-- 50 pagamentos (“payment”) de alugueres, agrupados por identificador de cliente
-- (“customer_id”), e, para cada um desses clientes calcular os “pontos de desconto” a tribuir –
-- 1 ponto por cada 2,50$ pago. No final, o procedimento deve apresentar uma lista com o nome
-- dos clientes e os pontos que lhe foram atribuídos – a lista deve ser apresentada ordenada de
-- forma crescente por nome de cliente.

-- DROP PROCEDURE sp_discount_points;

USE sakila;

DELIMITER &&
CREATE PROCEDURE sp_discount_points()
BEGIN
	-- declaração de variáveis
	DECLARE done INT DEFAULT 0;
    DECLARE v_customer_id INT;
    DECLARE v_amount DECIMAL(5,2);
    DECLARE v_first_name VARCHAR(45);
    DECLARE v_last_name VARCHAR(45);
    DECLARE v_points INT;
    
    -- declaração do cursor para os últimos 50 pagamentos
    DECLARE payment_cursor CURSOR FOR
    SELECT customer_id, SUM(amount) FROM (
		SELECT * FROM payment
        ORDER BY payment_date DESC
        LIMIT 50) sq
	GROUP BY customer_id;
    
    -- declaração do handler para iterar os resultados do cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    -- criação de uma tabela temporária para armazenar os dados
    CREATE TEMPORARY TABLE temp_pontos (
		customer_id INT,
        first_name VARCHAR(45),
        last_name VARCHAR(45),
        pontos INT
	);
    
    -- abrir o cursor
    OPEN payment_cursor;
    
    read_loop: LOOP
		-- processar os dados do cursor
		FETCH payment_cursor INTO v_customer_id, v_amount;
        
        -- verificar se chegou ao fim
        IF done THEN
			LEAVE read_loop;
		END IF;
        
        -- atribuir pontos
        SET v_points = ROUND(v_amount / 2.5);
        
        -- retornar o nome do cliente
        SELECT first_name, last_name
        INTO v_first_name, v_last_name
        FROM customer
        WHERE customer_id = v_customer_id;
        
        -- inserir os valores na tabela temporária
        INSERT INTO temp_pontos (customer_id, first_name, last_name, pontos)
        VALUES (v_customer_id, v_first_name, v_last_name, v_points);
	END LOOP;
    
    -- fechar o cursor
    CLOSE payment_cursor;
    
    -- retornar a lista com os nomes dos clientes e os pontos que lhe foram atribuidos
    SELECT first_name, last_name, pontos
    FROM temp_pontos
    ORDER BY first_name, last_name;
    
    -- apagar a tabela temporaria
    DROP TEMPORARY TABLE temp_pontos;
END &&
DELIMITER ;

