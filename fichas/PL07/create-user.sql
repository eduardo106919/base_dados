
USE MontagemAparelhos;

-- criar utilizador
CREATE USER 'eduardo'@'localhost'
	IDENTIFIED BY 'edufernandes';

-- permitir que adicione dados às tabelas
GRANT INSERT, SELECT
	ON MontagemAparelhos.*
    TO 'eduardo'@'localhost';


-- Adicionar elementos à tabela da Familia
INSERT INTO Familia
	(Id, Designacao)
    VALUES ('1', 'Marques');
    
INSERT INTO Familia
	(Id, Designacao)
    VALUES
    ('2', 'Fernandes'),
    ('3', 'Pinheiro');


-- Adicionar elementos à tabela dos Aparelhos
INSERT INTO Aparelhos
	(Id, Designacao, PrecoVenda, PrecoProducao, Referencia)
    VALUES
    (1, 'Centralina', 60.00, 23.00, 'IAW 6F'),
    (2, 'Pneu', 6.00, 3.00, 'kkjggu');

INSERT INTO Aparelhos
	(Id, Designacao, PrecoVenda, PrecoProducao, NrPecas)
    VALUES
    (3, 'Transmissao', 200.40, 120.78, 9);


-- Adicionar elementos à tabela das Operacoes
INSERT INTO Operacoes
	(Id, Designacao, CustoHora)
    VALUES
    (1, 'Revisao', 2.89),
    (2, 'Abate', 90.67),
	(3, 'Abate', 90.67);


-- Adicionar elementos à tabela das Peças
INSERT INTO Pecas
	(Id, Designacao, Familia_Id)
    VALUES
    (1, 'Sensor', 1),
    (2, 'Injetor', 1),
    (3, 'Vela', 3);


-- Adicionar elementos à tabela da Produção
INSERT INTO Producao
	(NrOrdemFabrico, Quantidade, InicioProducao, FimProducao, EntradaStock, JornalProducao, Aparelho_Id)
    VALUES
    (1, 56, DATE(NOW()), '2026-12-25', '2025-06-23', 'Produto bastante interessante', 3),
    (2, 5, '2024-02-02', '2027-03-05', NULL, 'Produto pouco interessante', 3),
    (3, 8, '2006-01-05', '2026-06-13', '2006-01-03', NULL, 3);


-- Adicionar elementos à tabela da Montagem
INSERT INTO Montagem
	(Aparelho, Peca, Operacao, Quantidade, Custo)
    VALUES
    (3, 1, 1, 5, 78.90),
    (1, 2, 3, 23, 34.78);


-- Adicionar elementos à tabela dos Tecnicos
INSERT INTO Tecnicos
	(Id, Nome, Funcao, CurriculumVitae, Responsavel, Tecnico_Id)
    VALUES
    (1, 'Fernando', 'Mecanico', 'Trabalhou em várias empresas', 2, NULL),
    (2, 'Mário', 'Chapeiro', 'Trabalhou em poucas empresas', 1, 1),
    (3, 'Joao', 'Mecanico', NULL, 5, 1);


-- Adicionar elementos à tabela dos TecnicosOperacoes
INSERT INTO TecnicosOperacoes
	(Operacao, Tecnico)
	VALUES
    (1, 2),
    (3, 2);
