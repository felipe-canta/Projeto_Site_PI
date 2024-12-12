const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

// Configuração do Body Parser
app.use(bodyParser.urlencoded({ extended: true }));

// Configuração da Conexão com o Banco de Dados
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root', // Usuário do MySQL
  password: '', // Senha do MySQL
  database: 'MeuBanco' // Nome do banco
});

// Conectando ao Banco de Dados
db.connect((err) => {
  if (err) {
    console.error('Erro ao conectar ao banco de dados:', err);
    return;
  }
  console.log('Conectado ao banco de dados MySQL!');
});

// Rota para Processar o Cadastro
app.post('/cadastrar', (req, res) => {
  const { nome, usuario, senha, confirmSenha } = req.body;

  // Verifica se as senhas coincidem
  if (senha !== confirmSenha) {
    return res.send('Erro: As senhas não coincidem!');
  }

  // Insere os dados no banco de dados
  const query = 'INSERT INTO Clientes (Nome, Email, Senha) VALUES (?, ?, ?)';
  db.query(query, [nome, usuario, senha], (err, result) => {
    if (err) {
      console.error('Erro ao inserir dados:', err);
      res.send('Erro ao cadastrar cliente.');
      return;
    }

    console.log('Cliente cadastrado com sucesso!', result);
    res.send('Cliente cadastrado com sucesso!');
  });
});

// Inicia o Servidor
app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
