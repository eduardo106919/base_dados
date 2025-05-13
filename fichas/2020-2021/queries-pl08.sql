

-- Quais as vendas que foram realizadas aos clientes ‘1’, ‘2’ e ‘3’ durante o mês de ‘fevereiro’ de ‘2018’?
SELECT *
FROM venda v
WHERE c.cliente IN (1,2,3) AND MONTH(v.data_venda) = 2 AND YEAR(v.data_venda) = 2018;


-- Qual o valor dos produtos que foram vendidos aos clientes das localidades ‘1’ e ‘5’?
SELECT vp.valor
FROM vendaproduto vp INNER JOIN venda v ON vp.venda = v.numero
					 INNER JOIN cliente c ON v.cliente = c.numero
WHERE c.localidade IN ('1', '5');


-- Quais os três tipos de produtos mais vendidos durante a semana ‘3’ de ‘2018’
SELECT p.tipo AS Tipo, COUNT(*) AS NrVendas
FROM produto p INNER JOIN vendaproduto vp ON p.numero = vp.produto
			   INNER JOIN venda v ON vp.venda = v.numero
WHERE WEEK(v.data_venda) = 3 AND YEAR(v.data_venda) = 2018
GROUP BY Tipo
ORDER BY NrVendas DESC
LIMIT 3;


-- Quais os produtos que ainda não foram vendidos até hoje?
SELECT p.*
FROM produto p
WHERE p.numero NOT IN (
	SELECT vp.produto
	FROM vendaproduto vp
    );


-- Qual é o produto mais vendido na mercearia? Apresente uma relação das vendas (em valor e
-- quantidade) desse produto ao longo das semanas de ‘2018’.
SELECT WEEK(v.data_venda) AS Semana, SUM(vp.quantidade) AS Quantidade, SUM(vp.valor) AS Valor
FROM venda v INNER JOIN vendaproduto vp ON v.numero = vp.venda
WHERE vp.produto IN (
	SELECT p.numero
    FROM produto p INNER JOIN vendaproduto vp ON p.numero = vp.produto
    GROUP BY p.numero
    ORDER BY SUM(vp.quantidade) DESC
    LIMIT 1
);


-- Definir uma vista (view) que disponibilize uma lista com as datas de aniversário e as idades
-- atuais dos clientes da mercearia.
CREATE VIEW vw_aniversarios_idade AS
SELECT c.datanascimento AS Nascimento, TIMESTAMPDIFF(YEAR, Nascimento, CURDATE()) AS Idade
FROM clientes c;


-- Definir uma vista (view) que disponibilize uma lista com o total das vendas por localidade dos
-- clientes. A lista deverá ser apresentada ordenada decrescentemente pelo valor das vendas.
CREATE VIEW sw_vendas_local AS
SELECT c.localidade AS Localidade, SUM(v.total) AS Total
FROM clientes c INNER JOIN vendas v ON c.numero = v.cliente
GROUP BY Localidade
ORDER BY Total DESC;


-- Implementar um procedimento (stored procedure) que indique os clientes que fazem anos
-- numa determinada data.
DELIMITER &&
CREATE PROCEDURE pc_clientes_anos(IN aniversario DATE)
BEGIN
	SELECT *
    FROM clientes
    WHERE clientes.data_nascimento = aniversario;
END &&
DELIMITER ;


-- Implementar um procedimento (stored procedure) que apresente uma relação das vendas de
-- produtos realizadas num determinado dia, ordenadas de forma decrescente por valor total do
-- produto vendido.
DELIMITER &&
CREATE PROCEDURE pc_vendas_dia(IN dia DATE)
BEGIN
	SELECT vp.produto AS Produto, SUM(vp.valor) AS Total
    FROM vendaproduto vp INNER JOIN venda v ON vp.venda = v.numero
    WHERE v.data_venda = dia
    GROUP BY Produto
    ORDER BY Total DESC;
END &&
DELIMITER ;


-- Implementar uma função (function) que, dado o número de um cliente, indique qual o produto
-- que esse cliente mais adquire na loja
DELIMITER &&
CREATE FUNCTION fc_cliente_produto(cliente_id INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE prod INT;
    SELECT p.numero INTO prod
		FROM produto p INNER JOIN vendaproduto vp ON p.numero = vp.produto
					   INNER JOIN vendas v ON vp.venda = v.numero
		WHERE v.cliente = cliente_id
		GROUP BY p.numero
		ORDER BY COUNT(vp.quantidade) DESC
		LIMIT 1;
	RETURN prod;
END &&
DELIMITER ;


-- Implementar uma função (function) que, dado o número de uma venda, indique o número de
-- produtos adquiridos nessa venda e o seu valor total.
DELIMITER &&
CREATE FUNCTION fc_venda_total(venda_id INT)
RETURNS VARCHAR(45) DETERMINISTIC
BEGIN
	DECLARE str VARCHAR(45);
	SELECT CONCAT('Nr Produtos: ', SUM(vp.quantidade), ' Valor Total', v.total) INTO str
		FROM vendas v INNER JOIN vendasproduto vp ON v.numero = vp.venda
		WHERE v.numero = venda_id;
	RETURN str;
END &&
DELIMITER ;


-- Implementar um gatilho (trigger) que registe numa tabela de auditoria
-- (“logProdutosVendidos”), que deve criar especificamente para o efeito, a data e a hora na qual
-- um dado produto foi adquirido e qual o cliente que o adquiriu.
CREATE TABLE IF NOT EXISTS logProdutosVendidos (
	numero INT NOT NULL AUTO_INCREMENT,
    instante DATETIME NOT NULL DEFAULT NOW(),
    produto INT NOT NULL,
    cliente INT NOT NULL,
		PRIMARY KEY (numero),
        FOREIGN KEY (produto) REFERENCES Produtos (numero),
        FOREIGN KEY (cliente) REFERENCES Clientes (numero)
);

DELIMITER &&
CREATE TRIGGER tg_produtos_vendidos
AFTER INSERT
ON vendaproduto FOR EACH ROW
BEGIN
	DECLARE cliente_id INT;
    SELECT v.cliente INTO cliente_id
		FROM vendas v
		WHERE v.numero = NEW.venda;
	INSERT INTO logProdutosVendidos
		(produto, cliente)
	VALUES
		(NEW.produto, cliente_id);
END &&
DELIMITER ;

