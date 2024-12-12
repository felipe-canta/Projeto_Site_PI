// Importando as dependências
const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');

// Configurando o Express
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.json());

// Configurando a conexão com o banco de dados MySQL
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root', // Substitua pelo seu usuário do MySQL
    password: '', // Substitua pela sua senha do MySQL
    database: 'LojaOnline'
});

// Conectando ao banco de dados
db.connect(err => {
    if (err) {
        console.error('Erro ao conectar ao banco de dados:', err);
        return;
    }
    console.log('Conectado ao banco de dados MySQL');
});

// Rota para listar todos os produtos
app.get('/produtos', (req, res) => {
    db.query('SELECT * FROM produtos', (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json(results);
    });
});

// Rota para adicionar um novo produto
app.post('/produtos', (req, res) => {
    const { nome, marca, preco, imagem, descricao, estoque } = req.body;
    const sql = 'INSERT INTO produtos (nome, marca, preco, imagem, descricao, estoque) VALUES (?, ?, ?, ?, ?, ?)';
    db.query(sql, [nome, marca, preco, imagem, descricao, estoque], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.status(201).json({ id: result.insertId, nome });
    });
});

// Rota para atualizar um produto
app.put('/produtos/:id', (req, res) => {
    const { id } = req.params;
    const { nome, marca, preco, imagem, descricao, estoque } = req.body;
    const sql = 'UPDATE produtos SET nome = ?, marca = ?, preco = ?, imagem = ?, descricao = ?, estoque = ? WHERE id = ?';
    db.query(sql, [nome, marca, preco, imagem, descricao, estoque, id], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({ message: 'Produto atualizado com sucesso' });
    });
});

// Rota para excluir um produto
app.delete('/produtos/:id', (req, res) => {
    const { id } = req.params;
    const sql = 'DELETE FROM produtos WHERE id = ?';
    db.query(sql, [id], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({ message: 'Produto excluído com sucesso' });
    });
});

// Iniciando o servidor
app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});