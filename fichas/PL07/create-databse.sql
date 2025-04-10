
-- DROP DATABASE IF EXISTS MontagemAparelhos;

CREATE DATABASE MontagemAparelhos;

USE MontagemAparelhos;

-- Cria a tabela da Familia das Peças
CREATE TABLE IF NOT EXISTS Familia (
	Id INT NOT NULL,
    Designacao VARCHAR(45) NOT NULL,
	PRIMARY KEY (Id)
);

-- Cria a tabela das Operações
CREATE TABLE IF NOT EXISTS Operacoes (
	Id INT NOT NULL,
    Designacao VARCHAR(45) NOT NULL,
    CustoHora DECIMAL(8,2) NOT NULL,
	PRIMARY KEY (Id)
);

-- Cria a tabela dos Aparelhos
CREATE TABLE IF NOT EXISTS Aparelhos (
	Id INT NOT NULL,
    Designacao VARCHAR(45) NOT NULL,
    Referencia VARCHAR(45) NULL,
    PrecoVenda DECIMAL(10,2) NOT NULL,
    PrecoProducao DECIMAL(10,2) NOT NULL,
	NrPecas INT NULL,
    NrOperacoes INT NULL,
    Observacoes TEXT NULL,
	PRIMARY KEY (Id)
);

-- Cria a tabela dos Técnicos
CREATE TABLE IF NOT EXISTS Tecnicos (
	Id INT NOT NULL,
	Nome VARCHAR(45) NULL,
    Funcao VARCHAR(45) NOT NULL,
    CurriculumVitae TEXT NULL,
	Responsavel INT NOT NULL,
    Tecnico_Id INT NULL,
		PRIMARY KEY (Id),
		FOREIGN KEY (Tecnico_Id)
			REFERENCES Tecnicos (Id)
);

-- Cria a tabela das Peças
CREATE TABLE IF NOT EXISTS Pecas (
	Id INT NOT NULL,
    Designacao VARCHAR(45) NOT NULL,
    Familia_Id INT NOT NULL,
	PRIMARY KEY (Id),
	FOREIGN KEY (Familia_Id)
		REFERENCES Familia (Id)
);

-- Cria a tabela da Produção de Aparelhos
CREATE TABLE IF NOT EXISTS Producao (
	NrOrdemFabrico INT NOT NULL,
    Quantidade INT NOT NULL,
    InicioProducao DATETIME NOT NULL,
    FimProducao DATETIME NULL,
    EntradaStock DATETIME NULL,
    JornalProducao TEXT NULL,
    Aparelho_Id INT NOT NULL,
	PRIMARY KEY (NrOrdemFabrico),
	FOREIGN KEY (Aparelho_Id)
			REFERENCES Aparelhos (Id)
);

-- Cria a tabela das Montagens de Aparelhos
CREATE TABLE IF NOT EXISTS Montagem (
	Aparelho INT NOT NULL,
    Peca INT NOT NULL,
    Operacao INT NOT NULL,
    Quantidade INT NOT NULL,
    Custo DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (Aparelho, Peca, Operacao),
    FOREIGN KEY (Aparelho)
		REFERENCES Aparelhos (Id),
	FOREIGN KEY (Operacao)
		REFERENCES Operacoes (Id),
	FOREIGN KEY (Peca)
		REFERENCES Pecas (Id)
);

-- Cria a tabela dos Técnicos-Operações
CREATE TABLE IF NOT EXISTS TecnicosOperacoes (
	Operacao INT NOT NULL,
    Tecnico INT NOT NULL,
    PRIMARY KEY (Operacao, Tecnico),
    FOREIGN KEY (Tecnico)
		REFERENCES Tecnicos (Id),
	FOREIGN KEY (Operacao)
		REFERENCES Operacoes (Id)
);

