-- Cria o banco de dados da loja
CREATE DATABASE LojaOnline;
USE LojaOnline;

CREATE TABLE Produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    marca VARCHAR(50),
    preco DECIMAL(10, 2) NOT NULL CHECK (preco >= 0),
    imagem_url VARCHAR(255),
    descricao TEXT,
    quantidade INT DEFAULT 1 CHECK (quantidade >= 0)
);

-- Tabela para gerenciar os usuários da loja
CREATE TABLE Usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL -- a senha deve ser criptografada para segurança
);

-- Tabela para armazenar os itens no carrinho de cada usuário
CREATE TABLE Carrinho (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT DEFAULT 1 CHECK (quantidade > 0),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES Produtos(id) ON DELETE CASCADE
);

-- Tabela para registrar os pedidos
CREATE TABLE Pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) NOT NULL,
    status ENUM('pendente', 'enviado', 'concluído') DEFAULT 'pendente',
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);
-- Tabela para armazenar os detalhes de cada item em um pedido
CREATE TABLE PedidoItens (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT,
    preco DECIMAL(10, 2),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);

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
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE
);