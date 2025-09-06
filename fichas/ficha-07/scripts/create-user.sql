
-- DROP USER IF EXISTS 'eduardo'@'localhost';

-- criar utilizador
CREATE USER 'eduardo'@'localhost'
	IDENTIFIED BY 'edufernandes';

-- permitir que adicione dados às tabelas
GRANT INSERT, SELECT
	ON MontagemAparelhos.*
    TO 'eduardo'@'localhost';
