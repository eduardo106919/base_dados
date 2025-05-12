

-- Quais são os clientes da mercearia?
SELECT *
FROM Cliente;


-- Quais são os nomes dos clientes que moram em 'Aguada do Queixo'?
SELECT *
FROM Cliente c
WHERE c.localidade = 'Aguada do Queixo';


-- Quais são as profissões dos clientes da D. Acácia?
SELECT c.profissao
FROM cliente c;


-- Quais são os nomes dos produtos, e respetivos preço, que estão catalogados na base
-- de dados? Apresente-os ordenados alfabeticamente.
SELECT p.designacao AS Nome, p.preco AS Preco
FROM produto p
ORDER BY Nome ASC;


-- Quais são os melhores clientes da mercearia?
SELECT c.numero AS Numero, c.nome AS Nome, SUM(v.total) AS TotalGasto
FROM cliente c INNER JOIN venda v ON c.numero = v.cliente
GROUP BY Numero
ORDER BY TotalGasto DESC;


-- Quais as vendas, e respetivos valores, que foram realizadas no dia '2017/10/05'?
SELECT v.numero, v.valor
FROM vendas v
WHERE v.data_venda = '2017-10-05';


-- Quais foram os produtos mais vendidos durante a semana ‘40’?
SELECT p.*
FROM venda v INNER JOIN vendaproduto vp ON v.numero = vp.venda
			 INNER JOIN produto p ON vp.produto = p.numero
WHERE WEEK(v.data_venda) = 40;


-- Qual o valor médio das vendas realizadas por dia da semana (segunda, terça, etc.)?
SELECT DAYOFWEEK(v.data_venda) AS DiaSemana, SUM(v.valor) AS Total
FROM venda V
GROUP BY DiaSemana;


-- Insira na base de dados um novo cliente.
INSERT INTO Cliente
	(numero, nome, dataNascimento, profissao, rua, localidade, CodPostal, Contribuinte, email, compras, recomendadoPor)
VALUES
	(11, 'Raul Rafeiro', '1999-01-01', 'trolha', 'ria da vesga', 'curral de moinas', '3252-123', 99234242, NULL, NULL, NULL);

-- Modifique o valor da rua do cliente criado na alínea anterior
UPDATE Cliente
	SET rua = 'Rua da Velha Vesga'
    WHERE numero = 11;

-- Atualize em +10% o preço de todos os produtos do tipo ’Peixe’
UPDATE Produto
	SET preco = preco + 0.1 * preco;


-- Insira uma venda para o cliente criado na alínea 1, na qual ele adquiriu 4 produtos distintos.
INSERT INTO Venda
	(numero, data_venda, estado, total, cliente)
VALUES
    (20, '2023-10-09', 'P', 87.23, 11);

INSERT INTO VendaProduto
	(venda, produto, quantidade, preco, valor)
VALUES
	(20, 1, 5.02, 12.90),
    (20, 2, 1.40, 67.43),
    (20, 3, 14.30, 23.47),
    (20, 4, 9.07, 18.14);


-- Remova da base de dados todos os registos relativos à venda realizada na alínea anterior.
DELETE FROM venda
	WHERE numero = 20;

DELETE FROM VendaProduto
	WHERE venda = 20;


