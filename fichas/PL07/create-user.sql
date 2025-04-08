
USE MontagemAparelhos;

-- criar utilizador
CREATE USER 'eduardo'@'localhost'
	IDENTIFIED BY 'edufernandes';

-- permitir que adicione dados às tabelas
GRANT INSERT 
	ON MontagemAparelhos.*
    TO 'eduardo'@'localhost';
