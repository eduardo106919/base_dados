

-- Fazer a criação das tabelas “Modelos”, “ModelosPeças” e “Peças”.
CREATE TABLE IF NOT EXISTS Modelos (
	idModelo INT NOT NULL AUTO_INCREMENT,
    Designacao VARCHAR(100) NOT NULL,
    Custo DECIMAL(8,2) NULL,
    TempoMontagem DECIMAL(8,2) NULL,
    Observacoes TEXT NULL,
		PRIMARY KEY (idModelo)
);

CREATE TABLE IF NOT EXISTS Pecas (
	idPeca INT NOT NULL AUTO_INCREMENT,
    Cor VARCHAR(50) NOT NULL,
    Tipo INT NOT NULL,
    Imagem VARCHAR(150) NULL,
		PRIMARY KEY (idPeca)
);

CREATE TABLE IF NOT EXISTS ModelosPecas (
	idModelo INT NOT NULL,
    idPeca INT NOT NULL,
    NrPecas INT NOT NULL,
		PRIMARY KEY (idModelo, idPeca),
        FOREIGN KEY (idModelo) REFERENCES Modelos (idModelo),
        FOREIGN KEY (idPeca) REFERENCES Pecas (idPeca)
);


-- Desenvolver um script que insira um registo na tabela “ModelosPeças”, 
-- bem como a informação requerida para a operação de inserção ser realizada com sucesso.
INSERT INTO Modelos
	(Designacao)
VALUES
	('Molde para Martelo');

INSERT INTO Pecas
	(Cor, Tipo)
VALUES
	('preto', 'feramenta');

INSERT INTO ModelosPecas
	(idModelos, idPeca, NrPecas)
VALUES
	(1, 1, 13);


-- Remover da tabela “Passos” todos os registos que foram guardados para 
-- modelos (“Modelos”) com um tempo de montagem (“TempoMontagem”) inferior a 2 minutos
DELETE FROM Passos AS p
WHERE p.idModelo IN (
	SELECT m.idModelo
    FROM Modelos m
    WHERE m.tempoMontagem IS NOT NULL AND m.TempoMontagem < 2
);


-- Criar uma vista (view) que disponibilize informação de todos os modelos 
-- registados na base de dados, agrupados por “Custo” e ordenados por “Tempo de montagem”.
CREATE VIEW vw AS
SELECT *
FROM Modelos m
GROUP BY m.Custo
ORDER BY m.TempoMontagem;


-- Desenvolver um procedimento (stored procedure) que receba, como parâmetro de entrada o
-- identificador de um modelo e apresente uma lista com todas as peças (“Id”, “Cor” e “Tipo”) que esse
-- modelo considera na sua montagem
DELIMITER &&
CREATE PROCEDURE pc(IN mod_id INT)
BEGIN
	SELECT p.id, p.cor, p.tipo
    FROM modelos m INNER JOIN passos pa ON m.idModelo = pa.idModelo
				   INNER JOIN pecas p ON pa.idPeca = p.idPeca
	WHERE m.idModelo = mod_id;
END &&
DELIMITER ;


