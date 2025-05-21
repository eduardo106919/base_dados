

-- Fornecer uma lista com os nomes dos funcionários do departamento ‘Científico-Técnico’ que têm atribuídas
-- tarefas com realização à segunda-feira (“DiaSemana”). Apresente a lista solicitada ordenada de forma alfabética.
SELECT f.nome AS Nome
FROM departamentos d INNER JOIN funcionarios f ON d.id = f.departamentos
					 INNER JOIN funcionariotarefas ft ON f.id = ft.funcionario
WHERE d.designacao = 'Cientifico-Tecnico' AND ft.diasemana = 'Segunda-Feira'
ORDER BY Nome ASC;


-- Remover da base de dados os registos dos funcionários que aparecem na lista apresentada pela query
-- desenvolvida na alínea a
CREATE VIEW vw_aux AS
SELECT f.id
FROM departamentos d INNER JOIN funcionarios f ON d.id = f.departamentos
					 INNER JOIN funcionariotarefas ft ON f.id = ft.funcionario
WHERE d.designacao = 'Cientifico-Tecnico' AND ft.diasemana = 'Segunda-Feira';

DELETE FROM Departamentos AS d
WHERE d.responsavel IN (
	SELECT * FROM vw_aux
);

DELETE FROM FuncionarioTarefas AS ft
WHERE ft.funcionario IN (
	SELECT * FROM vw_aux
);

DELETE FROM Funcionarios AS f
WHERE f.id IN (
	SELECT * FROM vw_aux
);


-- Criar uma vista (view) que permita obter uma lista com o total do tempo (“Tempo”) das tarefas atribuídas aos
-- funcionários da empresa, agrupado por funcionário. A lista deverá ser apresentada ordenada, de forma
-- decrescente, pelo total do tempo determinado.
CREATE VIEW vw_total_tempo AS
SELECT ft.funcionario AS Funcionario, SUM(t.tempo) AS Tempo
FROM funcionariotarefas tf INNER JOIN tarefas t ON tf.tarefa =  t.id
GROUP BY Funcionario
ORDER BY Tempo DESC;


-- Criar uma nova tabela “FuncionáriosPrémios” na base de dados, com esquema {Funcionário INT, NrPrémio
-- INT AUTONUMERADO, Descrição TEXT}, tendo em consideração que “Funcionário” e “NrPrémio” constituem
-- a chave principal desta nova tabela e que “Funcionário” é uma chave estrangeira com referência à tabela “Funcionários”.
CREATE TABLE FuncionariosPremios (
	funcionario INT NOT NULL,
    nrpremio INT NOT NULL AUTO_INCREMENT,
    descricao TEXT NOT NULL,
		PRIMARY KEY (funcionario, nrpremio),
        FOREIGN KEY (funcionario) REFERENCES Funcionarios (id)
);


-- Desenvolver uma função (function) que, dado um número (“Id”) específico de um funcionário, indique a
-- descrição da categoria desse funcionário.
DELIMITER &&
CREATE FUNCTION fc_categoria_funcionario(func_id INT)
RETURNS VARCHAR(45) DETERMINISTIC
BEGIN
	DECLARE descricao VARCHAR(45);
    SELECT c.designacao INTO descricao
    FROM categoria c INNER JOIN funcionarios f ON c.id = f.categoria
	WHERE f.id = func_id;
    RETURN descricao;
    END &&
DELIMITER ;


