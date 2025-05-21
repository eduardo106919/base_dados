


-- acrescentar na tabela “Investigador” dois novos atributos, “DataNascimento” e “eMail”, 
-- caracterizando-os de forma adequada;
ALTER TABLE Investigador
	ADD DataNascimento DATE NOT NULL,
	ADD eMail VARCHAR(45) NULL;


-- obter uma lista com os projetos que tenham um orçamento superior a ‘100.000,00’€, 
-- cujos investigadores responsáveis sejam da categoria ‘A’
SELECT p.*
FROM Projeto p INNER JOIN Investigador i ON p.id = i.projeto
WHERE i.categoria = 'A' AND p.orcamento > 100000.00;


-- criar uma vista que forneça uma lista com os nomes dos investigadores dos projetos, 
-- ordenada decrescentemente por orçamento dos projetos;
CREATE VIEW vw_investigadores AS
SELECT i.nome AS Nome
FROM Investigador i INNER JOIN projeto p ON i.projeto = p.id
ORDER BY p.orcamento DESC;


-- remover da base de dados toda a informação relativa à tarefa ‘Limpeza de Microscópio’;
DELETE FROM InvestigadorTarefa AS it
	WHERE it.tarefa IN (
		SELECT id
        FROM tarefa t
        WHERE t.designacao = 'Limpeza de Microscópio'
	);

DELETE FROM Tarefa AS t
	WHERE t.designacao = 'Limpeza de Microscópio';


-- desenvolver uma função que permita obter o tempo total relativo à realização 
-- das tarefas associadas com um dado investigador.
DELIMITER &&
CREATE FUNCTION fc_tempo_investigador(inv_id INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE tempo_total INT;
	
    SELECT SUM(duracao) INTO tempo_total
		FROM InvestigadorTarefa it
		WHERE it.investigador = inv_id;
    
    RETURN tempo_total;
END &&
DELIMITER ;


