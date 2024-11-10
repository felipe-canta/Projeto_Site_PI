-- Criação da tabela de usuários
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,           -- Identificador único e chave primária
    nome VARCHAR(100) NOT NULL,                  -- Nome completo do usuário
    email VARCHAR(100) NOT NULL UNIQUE,          -- Email único do usuário (nome de usuário para login)
    senha VARCHAR(255) NOT NULL,                 -- Senha do usuário
    telefone VARCHAR(20),                        -- Telefone do usuário
    endereco VARCHAR(255),                       -- Endereço do usuário
    cidade VARCHAR(100),                         -- Cidade de residência
    estado VARCHAR(100),                         -- Estado de residência
    cep VARCHAR(10),                             -- Código postal
    data_nascimento DATE,                        -- Data de nascimento (opcional)
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Data e hora do registro
);

-- Garantindo um índice único no email para evitar duplicidades
ALTER TABLE usuarios ADD UNIQUE (email):
