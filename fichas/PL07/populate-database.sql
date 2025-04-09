
-- adicionar registos à tabela Familia
INSERT INTO Familia
(Id, Designacao)
VALUES
    (1, 'Componentes Elétricos'),
    (2, 'Estruturas Metálicas'),
    (3, 'Elementos de Fixação'),
    (4, 'Unidades de Controlo'),
    (5, 'Peças Plásticas');

-- adicionar registos à tabela Operacoes
INSERT INTO Operacoes
(Id, Designacao, CustoHora)
VALUES
    (1, 'Montagem de Estrutura', 25.50),
    (2, 'Instalação Elétrica', 30.00),
    (3, 'Teste de Qualidade', 28.75),
    (4, 'Configuração de Software', 32.00),
    (5, 'Embalamento Final', 22.40);

-- adicionar registos à tabela Aparelhos
INSERT INTO Aparelhos
(Id, Designacao, Referencia, PrecoVenda, PrecoProducao, NrPecas, NrOperacoes, Observacoes)
VALUES
    (1, 'Sistema de Ventilação Inteligente', 'SVI-2023-A', 850.00, 540.00, 34, 5, 'Inclui sensor de CO2 e módulo Wi-Fi'),
    (2, 'Painel Solar Compacto', 'PSC-450', 600.00, 400.00, 22, 4, NULL),
    (3, 'Unidade de Controle Térmico', 'UCT-X100', 1250.00, 890.00, 40, 6, 'Requer calibração antes do envio'),
    (4, 'Sistema de Alarme Residencial', NULL, 410.00, 280.00, 18, 3, NULL),
    (5, 'Purificador de Ar Automático', 'PAA-500', 720.00, 510.00, 29, 5, 'Compatível com app móvel Android/iOS');

-- adicionar registos à tabela Tecnicos
INSERT INTO Tecnicos
(Id, Nome, Funcao, CurriculumVitae, Responsavel, Tecnico_Id)
VALUES
    (1, 'Carlos Mendes', 'Supervisor de Montagem', 'Engenheiro eletromecânico com 10 anos de experiência.', 1, NULL),
    (2, 'Ana Ribeiro', 'Técnica de Montagem', NULL, 1, 1),
    (3, 'João Silva', 'Técnico de Testes', 'Especializado em testes de qualidade e certificação CE.', 1, 1),
    (4, 'Rita Santos', 'Técnica de Configuração', NULL, 1, 1),
    (5, 'Miguel Costa', 'Técnico de Embalamento', '3 anos de experiência em logística industrial.', 1, 1);

-- adicionar registos à tabela Pecas
INSERT INTO Pecas
(Id, Designacao, Familia_Id)
VALUES
    (7, 'Sensor de Temperatura Digital', 1),
    (1, 'Parafuso M4 Inox', 3),
    (9, 'Suporte em Alumínio 90º', 2),
    (10, 'Placa Controladora', 4),
    (11, 'Carcaça de Ventoinha', 5);

-- adicionar registos à tabela Producao
INSERT INTO Producao
(NrOrdemFabrico, Quantidade, InicioProducao, FimProducao, EntradaStock, JornalProducao, Aparelho_Id)
VALUES
    (1001, 50, '2025-03-01 08:00:00', '2025-03-05 16:30:00', '2025-03-06 09:00:00', 'Sem anomalias registadas.', 1),
    (1002, 30, '2025-03-10 09:00:00', '2025-03-13 17:00:00', '2025-03-14 10:00:00', NULL, 2),
    (1003, 20, '2025-04-01 07:30:00', NULL, NULL, 'Produção em curso. Falta receber lote de peças.', 3),
    (1004, 75, '2025-02-15 08:45:00', '2025-02-20 15:15:00', '2025-02-21 11:00:00', 'Houve atraso na montagem elétrica.', 4);

-- adicionar registos à tabela Montagem
INSERT INTO Montagem
(Aparelho, Peca, Operacao, Quantidade, Custo)
VALUES
    (1, 9, 1, 2, 51.00),
    (1, 11, 2, 1, 30.00),
    (2, 11, 3, 1, 28.75),
    (3, 1, 4, 2, 64.00);

-- adicionar registos à tabela TecnicosOperacoes
INSERT INTO TecnicosOperacoes
(Operacao, Tecnico)
VALUES
    (1, 2),
    (2, 3),
    (3, 3),
    (4, 4),
    (5, 5);

