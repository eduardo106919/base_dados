
-- DROP SCHEMA Caderneta;

CREATE SCHEMA IF NOT EXISTS Caderneta;

USE Caderneta;


CREATE TABLE IF NOT EXISTS TipoCromo (
	nr_tipocromo INT NOT NULL AUTO_INCREMENT,
    descricao VARCHAR(75) NOT NULL,
		PRIMARY KEY (nr_tipocromo)
);


CREATE TABLE IF NOT EXISTS Posicao (
	id_posicao INT NOT NULL AUTO_INCREMENT,
    designacao VARCHAR(20) NOT NULL,
		PRIMARY KEY (id_posicao)
);


CREATE TABLE IF NOT EXISTS Pais (
	id_pais INT NOT NULL AUTO_INCREMENT,
    designacao VARCHAR(50) NOT NULL,
		PRIMARY KEY (id_pais)
);


CREATE TABLE IF NOT EXISTS Localidade (
	id_localidade CHAR(3) NOT NULL,
    designacao VARCHAR(75) NOT NULL,
    pais INT NOT NULL,
		PRIMARY KEY (id_localidade),
        FOREIGN KEY (pais) REFERENCES Pais (id_pais)
);


CREATE TABLE IF NOT EXISTS Equipa (
	id_equipa CHAR(3) NOT NULL,
    designacao VARCHAR(45) NOT NULL,
    treinador VARCHAR(50) NOT NULL,
    localidade CHAR(3) NOT NULL,
    ano_fundacao INT NULL,
    estado VARCHAR(50) NULL,
    presidente VARCHAR(50) NULL,
    url VARCHAR(150) NULL,
    observacoes TEXT NULL,
		PRIMARY KEY (id_equipa),
        FOREIGN KEY (localidade) REFERENCES Localidade (id_localidade)
);


CREATE TABLE IF NOT EXISTS Jogador (
	nr_jogador INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(75) NOT NULL,
    equipa CHAR(3) NOT NULL,
	posicao INT NOT NULL,
    data_nascimento DATE NULL,
    local_nascimento CHAR(3) NULL,
    altura DECIMAL(6,2) NULL,
    peso DECIMAL(6,2) NULL,
    observacoes TEXT NULL,
		PRIMARY KEY (nr_jogador),
        FOREIGN KEY (equipa) REFERENCES Equipa (id_equipa),
        FOREIGN KEY (posicao) REFERENCES Posicao (id_posicao),
        FOREIGN KEY (local_nascimento) REFERENCES Localidade (id_localidade)
);


CREATE TABLE IF NOT EXISTS Cromo (
	nr_cromo INT NOT NULL AUTO_INCREMENT,
    tipo INT NOT NULL,
    jogador INT NULL,
    pag_caderneta INT NOT NULL,
    descricao TEXT NULL,
    adquirido CHAR(1) NOT NULL,
		PRIMARY KEY (nr_cromo),
        FOREIGN KEY (tipo) REFERENCES TipoCromo (nr_tipocromo),
        FOREIGN KEY (jogador) REFERENCES Jogador (nr_jogador)
);
