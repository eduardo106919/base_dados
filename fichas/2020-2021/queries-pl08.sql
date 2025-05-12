

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






