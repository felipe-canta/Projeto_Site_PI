-- Criação do banco de dados da loja
CREATE DATABASE LojaOnline;
USE LojaOnline;

-- Tabela para armazenar as categorias de produtos
CREATE TABLE Categorias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT
);

-- Tabela para armazenar os produtos
CREATE TABLE Produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    marca VARCHAR(50),
    preco DECIMAL(10, 2) NOT NULL CHECK (preco >= 0),
    imagem_url VARCHAR(255),
    descricao TEXT,
    quantidade INT DEFAULT 1 CHECK (quantidade >= 0), -- Estoque
    destaque BOOLEAN DEFAULT FALSE, -- Produtos em destaque
    categoria_id INT,
    FOREIGN KEY (categoria_id) REFERENCES Categorias(id)
);

-- Criação da tabela de usuários com novos campos
CREATE TABLE Usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,           -- Identificador único e chave primária
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
ALTER TABLE Usuarios ADD UNIQUE (email);

-- Tabela para armazenar os endereços dos usuários
CREATE TABLE Enderecos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    logradouro VARCHAR(255) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(100) NOT NULL,
    cep VARCHAR(10) NOT NULL,
    telefone VARCHAR(15),
    principal BOOLEAN DEFAULT FALSE, -- Indica se é o endereço principal
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE
);

-- Tabela para armazenar os itens no carrinho de cada usuário
CREATE TABLE Carrinho (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT DEFAULT 1 CHECK (quantidade > 0),
    data_adicionado TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data do item no carrinho
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES Produtos(id) ON DELETE CASCADE
);

-- Tabela para registrar os pedidos
CREATE TABLE Pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    endereco_entrega_id INT, -- Endereço de entrega do pedido
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) NOT NULL,
    status ENUM('pendente', 'enviado', 'concluído') DEFAULT 'pendente',
    observacoes TEXT, -- Observações do cliente
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (endereco_entrega_id) REFERENCES Enderecos(id)
);

-- Tabela para armazenar os detalhes de cada item em um pedido
CREATE TABLE PedidoItens (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT CHECK (quantidade > 0),
    preco DECIMAL(10, 2) CHECK (preco >= 0), -- Preço do item no momento do pedido
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);

-- Tabela para registrar os pagamentos
CREATE TABLE Pagamentos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    metodo_pagamento ENUM('cartão', 'boleto', 'paypal') NOT NULL,
    status ENUM('pendente', 'confirmado', 'cancelado') DEFAULT 'pendente',
    valor_pago DECIMAL(10, 2), -- Valor pago
    detalhes_transacao TEXT, -- Informações adicionais
    data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id) ON DELETE CASCADE
);

-- Tabela para registrar logs de atividade dos usuários
CREATE TABLE LogsAtividade (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    acao VARCHAR(255) NOT NULL,              -- Descrição da ação realizada
    endereco_ip VARCHAR(45),                 -- IP de origem
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data e hora do log
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE
);

