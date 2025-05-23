


-- Criar a tabela “Administradores”, caracterizando-a de forma adequada.
CREATE TABLE IF NOT EXISTS Administradores (
	Id INT NOT NULL,
    Nome VARCHAR(75) NOT NULL,
    Categoria VARCHAR(45) NOT NULL,
    Competencias TEXT NOT NULL,
    Supervisor INT NOT NULL,
		PRIMARY KEY (Id),
        FOREIGN KEY (Supervisor) REFERENCES Administradores (Id)
);


-- Remover o atributo “Motor” da tabela “Tabelas”
ALTER TABLE Tabelas
DROP COLUMN Motor;


-- Obter uma lista com os nomes (“Designação”) e dimensões (“Dimensão”) das 
-- bases de dados geridas pelo administrador de nome ‘Hipólito Mestre’.
SELECT bd.designacao AS Nome, bd.dimensao AS Dimensao
FROM Administradores a INNER JOIN BasesdeDados bd ON a.id = bd.administrador
WHERE a.nome = 'Hipólito Mestre';


-- Obter uma lista com os nomes (“Designação”) dos SGBD que acolhem as 
-- bases de dados com os identificadores (“Id”) ‘1’, ‘4’ e ‘20’.
SELECT s.designacao AS Nome
FROM sgbd s INNER JOIN SGBDBasesdeDados sbd ON s.id = sbd.sgbd
WHERE sbd.basededados IN (1,4,20);


-- Obter uma vista que forneça uma lista com os nomes (“Designação”), dimensões (“Dimensão”) e
-- administradores (“Administrador”) de todas as bases de dados, com dimensão superior a 500GB.
-- Apresentar a lista ordenada decrescentemente por dimensão da base de dados.
CREATE VIEW vw AS
	SELECT Designacao, Dimensao, Administrador
	FROM BasesdeDados bd
	WHERE Dimensao > 500
    ORDER BY Dimensao DESC;


-- Mudar os administradores das bases de dados ‘1’ e ‘9’ para o administrador 
-- ‘Ana Francisca Tolerante’, cujo identificador tem o valor ‘3’.
UPDATE BasesdeDados
	SET Administrador = 3
    WHERE Id IN (1,9);


-- Atualizar o valor da dimensão (“Dimensão”) da base de dados ‘5’, tendo 
-- em consideração as dimensões (“Tamanho”) atuais de cada uma das suas tabelas.
UPDATE BasesdeDados AS bd
	SET Dimensao = (
		SELECT SUM(Tamanho)
        FROM Tabelas
        WHERE Tabelas.basededados = 5)
	WHERE bd.id = 5;


-- Desenvolver um procedimento (stored procedure) que permita obter todos os 
-- dados relativos às bases de dados que estão sob a supervisão de um dado administrador.
DELIMITER &&
CREATE PROCEDURE sp(IN admin_id INT)
BEGIN
	SELECT *
	FROM BasesdeDados bd
    WHERE bd.administrador = admin_id;
END &&
DELIMITER ;


