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

// Rota inicial (cadastro)
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'cadastre.html'));
});

// Rota para exibir a página de login
app.get('/login', (req, res) => {
  res.sendFile(path.join(__dirname, 'login.html')); // Aqui você vai precisar colocar o caminho correto para o seu arquivo login.html
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

// Rota para processar o formulário de cadastro
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

// Rota de login
app.post("/login", (req, res) => {
  const { email, senha } = req.body;

  console.log("Dados recebidos do frontend:", { email, senha });

  const query = "SELECT * FROM clientes WHERE email = ?";
  db.query(query, [email], (err, result) => {
    if (err) {
      console.error("Erro ao consultar o banco de dados:", err);
      return res.status(500).json({ msg: "Erro no servidor" });
    }

    if (result.length === 0) {
      console.log("Usuário não encontrado:", email);
      return res.status(401).json({ msg: "Usuário não encontrado!" });
    }

    const usuario = result[0];
    console.log("Dados do banco de dados:", usuario);

    // Remove espaços extras das senhas antes de comparar
    const senhaDigitada = senha.trim();
    const senhaArmazenada = usuario.Senha.trim();

    if (senhaDigitada === senhaArmazenada) {
      console.log("Senha correta!");
      return res.json({ msg: "Login bem-sucedido!" });
    } else {
      console.log("Senha incorreta! Digitada:", senhaDigitada, "Armazenada:", senhaArmazenada);
      return res.status(401).json({ msg: "Senha incorreta!" });
    }
  });
});

// Inicia o servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});
