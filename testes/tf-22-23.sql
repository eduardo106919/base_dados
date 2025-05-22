

-- Fazer a criação das tabelas “Artigos” e “Componentes”.
CREATE TABLE IF NOT EXISTS Artigos (
	id INT NOT NULL AUTO_INCREMENT,
    Designacao VARCHAR(100) NULL,
    Referencia VARCHAR(55) NULL,
    Preco DECIMAL(8,2) NULL,
    Stock DECIMAL(8,2) NULL,
    Observacoes TEXT NULL,
		PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Componentes (
	Artigo INT NOT NULL,
	Componente INT NOT NULL,
    Quantidade INT NOT NULL,
		PRIMARY KEY (Artigo, Componente),
        FOREIGN KEY (Artigo) REFERENCES Artigos (id),
        FOREIGN KEY (Componente) REFERENCES Artigos (id)
);


-- Inserir dois novos registos na tabela “Produção”.
INSERT INTO Artigos
	(id, Referencia, Preco)
VALUES
	(1, 'AKFJSD', 56.34);

INSERT INTO Componentes
	(Artigo, Componente, Quantidade)
VALUES
	(1, 1, 45);

INSERT INTO Maquinas
	(id, Designacao, CustoHora)
VALUES
	(1, 'bla bla bla', 34.12);

INSERT INTO Operacoes
	(id, Designacao)
VALUES
	(1, 'ALSFHA');

-- assumnindo que Sequencia é auto nomerado
INSERT INTO Producao
	(Artigo, Sequencia, Componente, Operacao, Maquina)
VALUES
	(1, 1, 1, 1, 1),
	(1, 2, 1, 1, 1);


-- Listar todos os registos da tabela “Produção” relativos às máquinas ‘1’ e ‘2’, 
-- que tenham realizado as operações ‘O1’, ‘O2’ e ‘O3’
SELECT p.*
FROM producao p INNER JOIN operacoes o ON p.operacao = o.id
WHERE p.maquina IN (1,2) AND o.designacao IN ('O1', 'O2', 'O3');


-- Indicar qual foi o tempo médio que foi gasto na realização das operações 
-- necessárias para produzir os artigos ‘1’ e ‘2’.
SELECT a.id AS Artigo, AVG(p.HorasProducao) AS Media
FROM artigos a LEFT OUTER JOIN producao p ON a.id = p.artigo
WHERE a.id IN (1, 2)
GROUP BY a.id;


-- Desenvolver um procedimento (stored procedure) que receba, como parâmetro de 
-- entrada o identificador de um artigo e apresente a lista completa de todos os seus componentes.
DELIMITER &&
CREATE PROCEDURE sp(IN art_id INT)
BEGIN
	SELECT a.*
    FROM Componentes c INNER JOIN Artigos a ON c.componente = a.id
    WHERE c.artigo = art_id;
END &&
DELIMITER ;


