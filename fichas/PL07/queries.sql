
-- todas as ordens de fabrico que foram registadas
SELECT *
    FROM Producao;

-- os aparelhos que a empresa monta, com um preço de venda superior ou igual a 100,00 euros
SELECT *
    FROM Aparelhos
    WHERE PrecoVenda >= 100.00;

-- O custo de todas as peças que são utilizadas na produção dos aparelhos '1' e '11'
SELECT Peca, Custo
	FROM Montagem
	WHERE Montagem.Aparelho IN (1, 11);

-- O lucro ("PreçoVenda" – "PreçoProdução") que a empresa obtém com cada um dos
-- aparelhos que produz, ordenada de forma decrescente pelo lucro calculado
SELECT Designacao, (PrecoVenda - PrecoProducao) AS Lucro
	FROM Aparelhos
    ORDER BY Lucro DESC;


