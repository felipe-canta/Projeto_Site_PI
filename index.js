const express = require('express');
const path = require('path');
const mysql = require('mysql');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware para interpretar os dados do corpo da requisição
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Configurar arquivos estáticos
app.use(express.static(path.join(__dirname)));

// Rota inicial
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'cadastre.html'));
});

// Configuração do MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '', // Altere conforme necessário
  database: 'lojatenis',
});

db.connect(err => {
  if (err) {
    console.error('Erro ao conectar ao MySQL:', err);
    return;
  }
  console.log('Conectado ao MySQL!');
});

// Rota para processar o formulário
app.post('/cadastrar', (req, res) => {
  const { nome, usuario, senha } = req.body;

  const sql = 'INSERT INTO Clientes (Nome, Email, Senha) VALUES (?, ?, ?)';
  db.query(sql, [nome, usuario, senha], (err, result) => {
    if (err) {
      console.error('Erro ao inserir no MySQL:', err);
      res.status(500).send('Erro ao cadastrar usuário.');
    } else {
      res.send('Usuário cadastrado com sucesso!');
    }
  });
});

// Inicia o servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});
