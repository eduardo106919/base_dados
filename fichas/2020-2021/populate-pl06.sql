USE Caderneta;

INSERT INTO TipoCromo
	(descricao)
VALUES
	('bronze'),
    ('prata'),
    ('ouro'),
    ('diamante');


INSERT INTO Posicao
	(designacao)
VALUES
	('defesa'),
    ('médio'),
    ('avançado');


INSERT INTO Pais
	(designacao)
VALUES
	('portugal'),
    ('espanha'),
    ('brazil');


INSERT INTO Localidade
	(id_localidade, designacao, pais)
VALUES
	('GMR', 'guimaraes', 1),
    ('MDR', 'Madrid', 2),
    ('RJN', 'Rio de Janeiro', 3);


INSERT INTO Equipa
	(id_equipa, designacao, treinador, localidade)
VALUES
	('VSC', 'Vitória Sport Clube', 'Rui Borges', 'GMR'),
	('RMD', 'Real Madrid', 'Carlo Ancelotti', 'MDR'),
    ('FMG', 'Flamengo', 'Filipe Luis', 'RJN');


INSERT INTO Jogador
	(nome, equipa, posicao)
VALUES
	('Zeca Mouco', 'VSC', 1),
    ('Mario Manco', 'VSC', 1),
    ('Silvino Matagal', 'VSC', 3),
    ('Mirico Mico', 'FMG', 2),
    ('Bifa Assar', 'RMD', 2);


INSERT INTO Cromo
	(tipo, pag_caderneta, adquirido)
VALUES
	(1, 56, 'N'),
    (1, 89, 'S'),
    (3, 235, 'S'),
    (4, 29, 'N');

